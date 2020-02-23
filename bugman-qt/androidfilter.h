#ifndef ANDROIDFILTER_H
#define ANDROIDFILTER_H

// From: https://bugreports.qt.io/browse/QTBUG-48567
// https://bugreports.qt.io/secure/ViewProfile.jspa?name=gri

#include <QAbstractVideoFilter>
#include <QOpenGLContext>

class AndroidFilter : public QAbstractVideoFilter {
    Q_OBJECT

public:
    explicit AndroidFilter(QObject *parent = 0)
        : QAbstractVideoFilter(parent) {}
    
    QVideoFilterRunnable *createFilterRunnable() override;
};


class AndroidFilterRunnable : public QVideoFilterRunnable {
public:
    AndroidFilterRunnable() {}
    
    QVideoFrame run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags) override;
};


class TextureBuffer : public QAbstractVideoBuffer {
public:
    TextureBuffer(uint id)
        : QAbstractVideoBuffer(GLTextureHandle), 
          m_id(id) {}
    
    MapMode mapMode() const {
        return NotMapped;
    }
    
    uchar *map(MapMode, int *, int *) {
        return 0;
    }
    
    void unmap() {}
    
    QVariant handle() const {
        return QVariant::fromValue<GLuint>(m_id);
    }

private:
    GLuint m_id;
};


#endif // ANDROIDFILTER_H
