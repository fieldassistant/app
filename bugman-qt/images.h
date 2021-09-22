#ifndef IMAGES_H
#define IMAGES_H

#include <QObject>
#include <QFileInfo>
#include <QDateTime>

class QMimeDatabase;

class Images : public QObject
{
    Q_OBJECT
    
    QStringList paths;
    QMimeDatabase* mimes;
    
    void collectFiles(QFileInfoList &files, const QString &path, int max, int depth) const;
    
public:
    explicit Images(QObject *parent, QStringList paths);
    
    QStringList getImages(int max = 250) const;
    
};

#endif // IMAGES_H
