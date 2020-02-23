# Created by and for Qt Creator This file was created for editing the project sources only.
# You may attempt to use it for building too, by modifying this file here.

TEMPLATE = lib
QT -= gui

QMAKE_CFLAGS += \
    -Wno-implicit-fallthrough \
    -Wno-implicit-function-declaration

TARGET = zlib

HEADERS = \
   $$PWD/zlib/crc32.h \
   $$PWD/zlib/deflate.h \
   $$PWD/zlib/gzguts.h \
   $$PWD/zlib/inffast.h \
   $$PWD/zlib/inffixed.h \
   $$PWD/zlib/inflate.h \
   $$PWD/zlib/inftrees.h \
   $$PWD/zlib/trees.h \
   $$PWD/zlib/zlib.h \
   $$PWD/zlib/zutil.h \
   $$PWD/zlib/zconf.h


SOURCES = \
   $$PWD/zlib/adler32.c \
   $$PWD/zlib/compress.c \
   $$PWD/zlib/crc32.c \
   $$PWD/zlib/deflate.c \
   $$PWD/zlib/gzclose.c \
   $$PWD/zlib/gzlib.c \
   $$PWD/zlib/gzread.c \
   $$PWD/zlib/gzwrite.c \
   $$PWD/zlib/infback.c \
   $$PWD/zlib/inffast.c \
   $$PWD/zlib/inflate.c \
   $$PWD/zlib/inftrees.c \
   $$PWD/zlib/trees.c \
   $$PWD/zlib/uncompr.c \
   $$PWD/zlib/zutil.c

INCLUDEPATH = \
    $$PWD/zlib
    
#DEFINES = 

