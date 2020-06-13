#ifndef IMAGES_H
#define IMAGES_H

#include <QObject>
#include <QFileInfo>
#include <QDateTime>

class QFileSystemWatcher;
class QMimeDatabase;

class Images : public QObject
{
    Q_OBJECT
    
    QStringList images;
    
    QFileSystemWatcher* watcher;
    QMimeDatabase* mimes;
    
    int collectFiles(QFileInfoList &files, const QString &path, int depth = 1);
    
    void fileChanged(QString path);
    void directoryChanged(QString path);
    
public:
    explicit Images(QObject *parent, QStringList paths);
    
    QStringList getImages() const;
    
signals:
    void onChanged();
};

#endif // IMAGES_H
