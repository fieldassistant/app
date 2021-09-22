#ifndef PLATFORMSHAREUTILS_H
#define PLATFORMSHAREUTILS_H

#include <QObject>
#include <QDebug>

class PlatformShareUtils : public QObject
{
    Q_OBJECT
signals:
    void shareEditDone(int requestCode);
    void shareFinished(int requestCode);
    void shareNoAppAvailable(int requestCode);
    void shareError(int requestCode, QString message);
    void fileUrlReceived(QString url);
    void fileReceivedAndSaved(QString url);

public:
    PlatformShareUtils(QObject *parent = 0) : QObject(parent){}
    virtual ~PlatformShareUtils() {}
    virtual bool checkMimeTypeView(const QString &mimeType){
        qDebug() << "check view for " << mimeType;
        return true;}
    virtual bool checkMimeTypeEdit(const QString &mimeType){
        qDebug() << "check edit for " << mimeType;
        return true;}
    virtual void share(const QString &text, const QUrl &url){ qDebug() << text << url; }
    virtual void sendFile(const QString &filePath, const QString &title, const QString &mimeType, const int &requestId, const bool &altImpl){
        qDebug() << filePath << " - " << title << "requestId " << requestId << " - " << mimeType << "altImpl? " << altImpl; }
    virtual void viewFile(const QString &filePath, const QString &title, const QString &mimeType, const int &requestId, const bool &altImpl){
        qDebug() << filePath << " - " << title << " requestId: " << requestId << " - " << mimeType << "altImpl? " << altImpl; }
    virtual void editFile(const QString &filePath, const QString &title, const QString &mimeType, const int &requestId, const bool &altImpl){
        qDebug() << filePath << " - " << title << " requestId: " << requestId << " - " << mimeType << "altImpl? " << altImpl; }

    virtual void checkPendingIntents(const QString workingDirPath){
        qDebug() << "checkPendingIntents " << workingDirPath; }
};

#endif // PLATFORMSHAREUTILS_H
