#include "app.h"
#include "csvwriter.h"

#include <QDebug>
#include <QStandardPaths>
#include <QDir>
#include <QFileSystemWatcher>
#include <QQmlEngine>
#include <QQmlContext>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>
#include <QRegularExpression>
#include <QMimeDatabase>
#include <quazipfile.h>
#include <JlCompress.h>
#include "share/shareutils.h"

static App* instance = nullptr;

App::App(QObject *parent)
        : QObject(parent) {
    
    appPath = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first();
    imagesPaths = QStandardPaths::standardLocations(QStandardPaths::PicturesLocation);
    csvPath = QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation).first();
    
#if defined(Q_OS_ANDROID)
    QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).last();
#endif
    
    dbPath = appPath + "/db.json";
    cameraPath = imagesPaths.first() + "/Field Assistant";
    csvPath.append("/Field Assistant");
    
    if (!QDir(appPath).exists()) {
        QDir().mkpath(appPath);
    }
    
    if (!QDir(cameraPath).exists()) {
        QDir().mkpath(cameraPath);
    }
    
    if (!QDir(csvPath).exists()) {
        QDir().mkpath(csvPath);
    }
    
    loadDb();
    loadTemplates();
    
    imageWatcher = new QFileSystemWatcher(this);
    imageWatcher->addPaths(imagesPaths);
    
    connect(imageWatcher, &QFileSystemWatcher::fileChanged,
            this, &App::onImageChanged);
    
    mimes = new QMimeDatabase();
    
    share = new ShareUtils(this);
    
    images = getImages();
}

QJSValue App::registerType(QQmlEngine* engine, QJSEngine *script) {
    return script->newQObject(new App(engine));
}

void App::registerSingleton(QQmlEngine *qmlEngine) {
    if (instance == nullptr) {
        instance = new App(qmlEngine);
    }
    QQmlContext* rootContext = qmlEngine->rootContext();
    rootContext->setContextProperty("App", instance);
}

void App::onImageChanged(QString path) {
    QFileInfo info(path);
    
    // Add if it's an image type.
    if (info.exists()) {
        QMimeType fileType = mimes->mimeTypeForFile(info);
        qDebug() << "Adding image:" << path << fileType.name();
        
        if (fileType.name().startsWith("image/") &&
                !images.contains("files:///" + path)) {
            images.prepend("files:///" + path);
        }
    }
    else {
        qDebug() << "Removing image:" << path;
        // Remove from images.
        images.removeOne("file:///" + path);
    }
}

void App::loadDb() {
    db.clear();
    
    qDebug() << "DB:" << dbPath;
    
    QFile dbFile(dbPath);
    int entryCount = 0;
    
    if (dbFile.open(QIODevice::ReadOnly)) {
        QByteArray data = dbFile.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        
        entryCount = db.read(doc.object());
        
        dbFile.close();
    }
    
    qDebug() << "Sets:" << db.sets.size();
    qDebug() << "Entries:" << entryCount;
}

void App::saveDb() const {
    QFile dbFile(dbPath);
    
    if (!dbFile.open(QIODevice::WriteOnly)) {
        qWarning() << "Couldn't open save file.";
        qWarning() << dbPath;
        return;
    }
    
    QJsonObject object;
    db.write(object);
    
    QJsonDocument doc(object);
    dbFile.write(doc.toJson());
    
    dbFile.close();
    qDebug() << "DB written.";
}

void App::loadTemplates() {
    templates.clear();
    QDir dir(":templates");
    
    for (QString path : dir.entryList(QDir::Files)) {
        qDebug() << "Template:" << path;
        
        QFile file(dir.absoluteFilePath(path));
        if (!file.open(QIODevice::ReadOnly)) continue;
        
        QByteArray data = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonObject root = doc.object();
        
        EntryTemplate entryTemplate;
        entryTemplate.read(root);
        templates.append(entryTemplate);
        
        file.close();
    }
    
    qDebug() << "Templates:" << templates.size();
}

void getFiles(QFileInfoList &files, const QString path, int depth = 1) {
    QDir dir(path);
    
    files.append(dir.entryInfoList(QDir::Files));
    
    if (depth == 0) return;
    
    for (QString subPath : dir.entryList(QDir::Dirs)) {
        if (subPath.startsWith(".")) continue;
        
        qDebug() << "Diving into: " << path << subPath;
        getFiles(files, dir.absoluteFilePath(subPath), depth - 1);
    }
}

QStringList App::getImages() const {
    QFileInfoList files;
    
    for (QString dirPath : imagesPaths) {
        qDebug() << "Searching for images in:" << dirPath;
        getFiles(files, dirPath);
    }
    
    std::sort(files.begin(), files.end(), [](const QFileInfo &a, const QFileInfo &b) {
        return a.lastModified() > b.lastModified();
    });
    
    QStringList paths;
    
    for (QFileInfo info : files) {
        QMimeType fileType = mimes->mimeTypeForFile(info);
        
        if (info.fileName().startsWith(".")) continue;
        if (!fileType.name().startsWith("image/")) continue;
        
        paths.append("file:///" + info.absoluteFilePath());
    }
    
    paths.removeDuplicates();
    
    return paths;
}

void App::removeFile(QString path) const {
    QFile::remove(path);
}

QList<EntrySet> App::getData() const {
    return db.sets.values();
}

int App::setEntry(const QVariantMap &object) {
    
    Entry entry = Entry::fromObject(object);
    if (!entry.entry_id || !entry.entry_set_id) {
        return -1;
    }
    
    int index = db.setEntry(entry);
    
    if (index >= 0) {
        qDebug() << "Save entry" << entry.entry_id;
        saveDb();
        emit dataChanged();
    }
    else {
        qDebug() << entry.entry_set_id << "This set doesn't exist.";
    }
    return index;
}

int App::removeEntry(int setId, int entryId) {
    
    if (db.sets.contains(setId)) {
        qDebug() << "Remove entry" << entryId << "from set" << setId;
        int index = db.sets.keys().indexOf(setId);
        int count = db.sets[setId].entries.remove(entryId);
        
        if (count < 1) {
            qDebug() << "Entry not in set?";
            return -1;
        }
        else {
            saveDb();
            emit dataChanged();
            return index;
        }
    }
    else {
        qDebug() << setId << "This set doesn't exist.";
        return -1;
    }
}

int App::setSet(const QVariantMap &object) {
    
    EntrySet set = EntrySet::fromObject(object);
    if (!set.set_id) return -1;
    
    int index = db.setSet(set);
    
    qDebug() << "Save set" << set.set_id;
    saveDb();
    emit dataChanged();
    
    return index;
}

int App::removeSet(int setId) {
    int index = db.sets.keys().indexOf(setId);
    
    int count = db.sets.remove(setId);
    if (count < 0) {
        qDebug() << "Set doesn't exist?";
        return -1;
    }
    else {
        saveDb();
        emit dataChanged();
        qDebug() << "Remove set" << setId;
        
        return index;
    }
}

bool App::exportPathExists(const QString &fileName) const {
    if (fileName.isEmpty()) return false;
    
    QString path(csvPath + "/" + fileName);
    if (!path.endsWith(".zip")) {
        path.append(".zip");
    }
    
    return QFile::exists(path);
}

QList<ImageOut> App::getSetImages(const EntrySet &set) const {
    QList<ImageOut> images;
    
    for (Entry entry : set.entries.values()) {
        int num = 1;
        for (QString path : entry.images) {
            QFileInfo info(path);
            
            QString name = QString("%1-%2.%3")
                .arg(entry.voucher)
                .arg(QString::asprintf("%03d", num++))
                .arg(info.suffix());
            
            images.append({ name, path });
        }
    }
    
    return images;
}

QString App::exportSet(const QString &fileName, int setId) {
    if (!db.sets.contains(setId)) {
        qDebug() << setId << "set not found.";
        return "";
    }
    
    const EntrySet set = db.sets[setId];
    
    QFile file(csvPath + "/" + fileName);
    QuaZip zip(&file);
    
    if (!zip.open(QuaZip::mdCreate)) {
        qWarning() << "Could not open zip file" << file.fileName();
        qWarning() << file.errorString();
        return "";
    }
    
    {
        QuaZipFile csv(&zip);
        
        if (!csv.open(QIODevice::WriteOnly, QuaZipNewInfo(set.name + ".csv"))) {
            qWarning() << "Cannot open zip csv for writing" << set.name;
            qWarning() << file.errorString();
            return "";
        }
        
        writeCsv(&csv, set);
        csv.close();
    }
    
    QList<ImageOut> images = getSetImages(set);
    
    for (ImageOut pair : images) {
        QuaZipFile image(&zip);
        
        if (!image.open(QIODevice::WriteOnly, QuaZipNewInfo(pair.name))) {
            qWarning() << "Cannot open zip image for writing" << pair.path;
            qWarning() << file.errorString();
            continue;
        }
        
        writeImage(&image, pair.path);
        image.close();
    }
    
    zip.close();
    
    // No request ID, use JNI mode.
    share->sendFile(file.fileName(), set.name, "application/zip", 0, false);
    
    return file.fileName();
}

static const QRegularExpression FILE_RE("^file:///");

bool App::writeImage(QIODevice *file, const QString &image) const {
    
    QString imagePath(image);
    imagePath.replace(FILE_RE, "");
    
    QFile copy(imagePath);
    
    if (!copy.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot open image" << image;
        qWarning() << copy.errorString();
        return false;
    }
    
    while (!copy.atEnd()) {
        char buf[4096];
        qint64 readLen = copy.read(buf, 4096);
        if (readLen <= 0) break;
        if (file->write(buf, readLen) != readLen) break;
    }
    
    copy.close();
    return true;
}


bool App::writeCsv(QIODevice* file, const EntrySet &set) const {
    
    CsvWriter csv(file);
    csv.write("Voucher");
    csv.write("Date");
    csv.write("Time");
    csv.write("Latitude");
    csv.write("Longitude");
    csv.write("Altitude (m)");
    csv.write("Collector");
    
    QStringList fieldNames = set.getFieldNames();
    
    for (const QString name : fieldNames) {
        csv.write(name);
    }
    
    csv.newRow();
    
    for (const Entry entry : set.entries) {
        QDateTime date = QDateTime::fromMSecsSinceEpoch(entry.timestamp.toLongLong());
        
        csv.write(entry.voucher);
        csv.write(date.date());
        csv.write(date.time());
        csv.write(entry.position.latitude);
        csv.write(entry.position.longitude);
        csv.write(entry.position.altitude);
        csv.write(entry.collector);
        
        QMap<QString, EntryField> fields = entry.getFieldMap(); 
        
        for (const QString name : fieldNames) {
            const EntryField field = fields[name];
            csv.write(field.value);
        }
        
        csv.newRow();
    }
    
    qDebug() << "Written csv file.";
    return true;
}

static const QRegularExpression RE("%\\d*[^\\dd]");

QString App::sprintf(const QString format, int number) {
    
    auto match = RE.globalMatch(format);
    if (match.hasNext()) return "";
    
    QByteArray bytes = format.toUtf8();
    const char* cformat = bytes.data();
    return QString::asprintf(cformat, number);
}
