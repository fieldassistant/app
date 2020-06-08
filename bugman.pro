TEMPLATE = subdirs

SUBDIRS += \
    zlib \
    quazip \
    bugman-qt

zlib.file = zlib.pro

quazip.file = quazip.pro
quazip.depends = zlib

bugman-qt.file = bugman-qt/bugman.pro
bugman-qt.depends = quazip
