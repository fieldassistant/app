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
    
    QStringList paths;
    
    QFileSystemWatcher* watcher;
    QMimeDatabase* mimes;
    
    int collectFiles(QFileInfoList &files, const QString &path, int max, int depth) const;
    
public:
    explicit Images(QObject *parent, QStringList paths);
    
    void clear();
    QStringList getImages(int max = 100) const;
    
signals:
    void onChanged();
};

#endif // IMAGES_H
