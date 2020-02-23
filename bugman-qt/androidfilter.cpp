#include "androidfilter.h"

QVideoFrame AndroidFilterRunnable::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags) {
    Q_UNUSED(surfaceFormat);
    Q_UNUSED(flags);
    
#ifdef Q_OS_ANDROID
    // Stays in GPU Memory --> FAST
    GLuint textureId = input->handle().toUInt();
    
    return QVideoFrame(new TextureBuffer(textureId), input->size(), input->pixelFormat());
    
    /*
    // Maps to CPU Memory --> SLOW
    if (input->map(QAbstractVideoBuffer::ReadOnly)) {
        input->unmap();
    }
    */

    return *input;
#else
    return *input;
#endif
}

QVideoFilterRunnable *AndroidFilter::createFilterRunnable() {
    return new AndroidFilterRunnable;
}
