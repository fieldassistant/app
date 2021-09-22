#ifndef APPDATA_H
#define APPDATA_H

#include <QObject>
#include <QFile>
#include <QFileInfo>
#include "entry.h"

class QQmlEngine;
class QJSValue;
class QJSEngine;
class ShareUtils;
class Images;

typedef struct {
    QString name;
    QString path;
} ImageOut;

class App : public QObject {
    Q_OBJECT
    
    Q_PROPERTY(QStringList images READ getImages NOTIFY imagesChanged)
    Q_PROPERTY(QList<EntrySet> sets READ getData NOTIFY dataChanged)
    Q_PROPERTY(QList<EntryTemplate> templates MEMBER templates CONSTANT)
    Q_PROPERTY(QString cameraPath MEMBER cameraPath CONSTANT)
    
    
    QString appPath;
    QStringList imagesPaths;
    QString cameraPath;
    QString csvPath;
    QString dbPath;
    
    Images* images;
    ShareUtils* share;
    EntryDatabase db;
    QList<EntryTemplate> templates;
    
    void loadDb();
    void saveDb() const;
    void loadTemplates();
    
    bool writeCsv(QIODevice *file, const EntrySet &set) const;
    
    bool writeImage(QIODevice *file, const QString &image) const;
    
    QList<ImageOut> getSetImages(const EntrySet &set) const;
    
public:
    explicit App(QObject *parent = nullptr);
    
    static QJSValue registerType(QQmlEngine* engine, QJSEngine *script);
    
    static void registerSingleton(QQmlEngine* engine);
    
    QStringList getImages() const;
    
    Q_INVOKABLE void refreshImages();
    
    QList<EntrySet> getData() const;
    
    Q_INVOKABLE void removeFile(QString path) const;
    
    Q_INVOKABLE int setEntry(const QVariantMap &entry);
    
    Q_INVOKABLE int removeEntry(int setId, int entryId);
    
    Q_INVOKABLE int setSet(const QVariantMap &set);
    
    Q_INVOKABLE int removeSet(int setId);
    
    Q_INVOKABLE QString exportSet(const QString &fileName, int setId);
    
    Q_INVOKABLE bool exportPathExists(const QString &fileName) const;
    
    inline Q_INVOKABLE int nextSetId() const {
        return db.nextSetId();
    }
    
    inline Q_INVOKABLE int nextEntryId() const {
        return db.nextEntryId();
    }
    
    static Q_INVOKABLE QString sprintf(const QString format, int number);
    
signals:
    void dataChanged();
    void imagesChanged();
};

#endif // APPDATA_H
