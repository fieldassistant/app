#include "images.h"
#include <QMimeDatabase>
#include <QDebug>
#include <QDir>
#include <QDateTime>

Images::Images(QObject *parent, QStringList paths) : QObject(parent) {
    mimes = new QMimeDatabase();
    this->paths = paths;
}


void Images::collectFiles(QFileInfoList &files, const QString &path, int max, int depth) const {
    QDir dir(path);
    
    for (QFileInfo file : dir.entryInfoList(QDir::Files)) {
        if (files.size() == max) break;
        
        QMimeType fileType = mimes->mimeTypeForFile(file);
        
        if (file.fileName().startsWith(".")) continue;
        if (!fileType.name().startsWith("image/")) continue;
        
        QString filePath = file.absoluteFilePath();
        
        files.append(file);
        qDebug() << "Image (" << files.size() << "):" << filePath;
    }
    
    if (files.size() == max) return;
    if (depth == 0) return;
    
    for (QString subPath : dir.entryList(QDir::Dirs)) {
        if (subPath.startsWith(".")) continue;
        QString subDir = dir.absoluteFilePath(subPath);
        qDebug() << "Diving into:" << subDir;
        
        collectFiles(files, subDir, max, depth - 1);
    }
}



QStringList Images::getImages(int max) const {
    
    QFileInfoList files;
    QStringList images;
    
    for (QString dirPath : paths) {
        qDebug() << "Searching for images in:" << dirPath;
        collectFiles(files, dirPath, max, 1);
    }
    
    std::sort(files.begin(), files.end(),
            [](const QFileInfo &a, const QFileInfo &b) {
        return a.lastModified() > b.lastModified();
    });
    
    for (QFileInfo file : files) {
        images.append(file.absoluteFilePath());
    }
    
    return images;
}
