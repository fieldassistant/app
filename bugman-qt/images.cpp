#include "images.h"
#include <QFileSystemWatcher>
#include <QMimeDatabase>
#include <QDebug>
#include <QDir>
#include <QDateTime>

Images::Images(QObject *parent, QStringList paths) : QObject(parent) {
    watcher = new QFileSystemWatcher(this);
    mimes = new QMimeDatabase();
    
    connect(watcher, &QFileSystemWatcher::directoryChanged,
            this, &Images::directoryChanged);
    
    connect(watcher, &QFileSystemWatcher::fileChanged,
            this, &Images::fileChanged);
    
    QFileInfoList files;
    
    for (QString dirPath : paths) {
        qDebug() << "Searching for images in:" << dirPath;
        collectFiles(files, dirPath);
    }
    
    std::sort(files.begin(), files.end(),
            [](const QFileInfo &a, const QFileInfo &b) {
        return a.lastModified() > b.lastModified();
    });
    
    for (QFileInfo file : files) {
        images.append(file.absoluteFilePath());
    }
    
    watcher->addPaths(paths);
}

int Images::collectFiles(QFileInfoList &files, const QString &path, int depth) {
    QDir dir(path);
    int size = 0;
    
    for (QFileInfo file : dir.entryInfoList(QDir::Files)) {
        QMimeType fileType = mimes->mimeTypeForFile(file);
        
        if (file.fileName().startsWith(".")) continue;
        if (!fileType.name().startsWith("image/")) continue;
        
        QString filePath = file.absoluteFilePath();
        
        if (images.contains(filePath)) continue;
        
        qDebug() << "Image:" << filePath;
        files.append(file);
        watcher->addPath(filePath);
        size += 1;
    }
    
    if (depth == 0) return size;
    
    for (QString subPath : dir.entryList(QDir::Dirs)) {
        if (subPath.startsWith(".")) continue;
        QString subDir = dir.absoluteFilePath(subPath);
        qDebug() << "Diving into:" << subDir;
        
        size += collectFiles(files, subDir, depth - 1);
        watcher->addPath(subDir);
    }
    
    return size;
}

void Images::directoryChanged(QString path) {
    QFileInfoList files;
    collectFiles(files, path, 0);
    
    for (QFileInfo file : files) {
        images.prepend(file.absoluteFilePath());
    }
    
    if (files.size() != 0) {
        qDebug() << "image added" << path;
        emit onChanged();
    }
}

void Images::fileChanged(QString path) {
    if (!QFile::exists(path)) {
        qDebug() << "image removed" << path;
        images.removeOne(path);
        emit onChanged();
    }
}

QStringList Images::getImages() const {
    return images;
}
