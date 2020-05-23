TEMPLATE = lib
CONFIG += qt warn_on
QT -= gui

# The ABI version.
!win32:VERSION = 1.0.0

greaterThan(QT_MAJOR_VERSION, 4) {
    DEFINES += QT_DEPRECATED_WARNINGS
    # disable all the Qt APIs deprecated before Qt 6.0.0
#    DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000
}

# This one handles dllimport/dllexport directives.
DEFINES += QUAZIP_BUILD
DEFINES += QT_NO_CAST_FROM_ASCII
DEFINES += QT_NO_CAST_TO_ASCII

# You'll need to define this one manually if using a build system other
# than qmake or using QuaZIP sources directly in your project.
# CONFIG(staticlib): DEFINES += QUAZIP_STATIC

# Input
include(quazip/quazip/quazip.pri)

unix {
    headers.path = $$PREFIX/include/quazip
    headers.files = $$HEADERS
    
    INSTALLS += headers
}
unix!android {
    LIBS += $$OUT_PWD/libzlib.so
}
android {
    LIBS += $$OUT_PWD/libzlib_$${QT_ARCH}.so
}
macos {
    LIBS += $$OUT_PWD/libzlib.dylib
}
ios {
    LIBS += $$OUT_PWD/libzlib.a
}
win32 {
    headers.path = $$PREFIX/include/quazip
    headers.files = $$HEADERS
    
    INSTALLS += headers
    LIBS += $$OUT_PWD/zlib.dll
    
    # workaround for qdatetime.h macro bug
    DEFINES += NOMINMAX
}

