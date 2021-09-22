QT += quick svg multimedia

android {
    QT += androidextras
}

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    app.cpp \
    csvwriter.cpp \
    entry.cpp \
    images.cpp \
    main.cpp \
    share/shareutils.cpp

RESOURCES += qml.qrc \
    icons.qrc \
    templates.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    app.h \
    csvwriter.h \
    entry.h \
    images.h \
    share/platformshareutils.h \
    share/shareutils.h

DISTFILES += \
    README.md \
    templates/bugman.json \
    templates/rocks.json

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

INCLUDEPATH += $$PWD/../quazip/quazip

win32 {
    LIBS += $$OUT_PWD/../zlib/zlib.dll
    LIBS += $$OUT_PWD/../quazip/quazip.dll

    quazip.path = $$OUT_PWD/../quazip/quazip.dll
    zlib.path = $$OUT_PWD/../zlib/zlib.dll
    INSTALLS += quazip zlib
}
unix:!android {
    LIBS += -L"$$OUT_PWD/../zlib" -lzlib
    LIBS += -L"$$OUT_PWD/../quazip" -lquazip

    quazip.path = $$OUT_PWD/../quazip/libquazip.so
    zlib.path = $$OUT_PWD/../zlib/libzlib.so
    INSTALLS += quazip zlib
}
android {
    SOURCES += share/androidshareutils.cpp
    HEADERS += share/androidshareutils.h
    
    DISTFILES += \
        android/AndroidManifest.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew \
        android/gradlew.bat \
        android/res/values/libs.xml \
        android/res/xml/filepaths.xml \
        android/src/org/ekkescorner/utils/QShareUtils.java \
        android/src/org/ekkescorner/utils/QSharePathResolver.java

    LIBS += $$OUT_PWD/../zlib/libzlib_$${QT_ARCH}.so
    LIBS += $$OUT_PWD/../quazip/libquazip_$${QT_ARCH}.so

    quazip.path = $$OUT_PWD/../quazip/libquazip_$${QT_ARCH}.so
    zlib.path = $$OUT_PWD/../zlib/libzlib_$${QT_ARCH}.so
    INSTALLS += quazip zlib
}
macos {
    LIBS += $$OUT_PWD/../zlib/libzlib.dylib
    LIBS += $$OUT_PWD/../quazip/libquazip.dylib
    
    quazip.path = $$OUT_PWD/../quazip/libquazip.dylib
    zlib.path = $$OUT_PWD/../zlib/libzlib.dylib
    INSTALLS += quazip zlib
}
ios {
    HEADERS += \
        share/docviewcontroller.h \
        share/iosshareutils.h

    SOURCES += \
        ios/src/iosshareutils.mm \
        ios/src/docviewcontroller.mm

    LIBS += $$OUT_PWD/../zlib/libzlib.a
    LIBS += $$OUT_PWD/../quazip/libquazip.a

    DISTFILES += \
        ios/Info.plist \
        ios/src/docviewcontroller.mm \
        ios/src/iosshareutils.mm

    QMAKE_INFO_PLIST = ios/Info.plist
    QMAKE_IOS_DEPLOYMENT_TARGET = 11.0
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1,2
    QMAKE_BUNDLE = bugman
    QMAKE_TARGET_BUNDLE_PREFIX = com.gwillz

    disable_warning.name = GCC_WARN_64_TO_32_BIT_CONVERSION
    disable_warning.value = NO

    QMAKE_MAC_XCODE_SETTINGS += disable_warning

    MY_BUNDLE_ID.name = PRODUCT_BUNDLE_INDENTIFIER
    MY_BUNDLE_ID.value = com.gwillz.bugman
    QMAKE_MAC_XCODE_SETTINGS += MY_BUNDLE_ID

    XCODEBUILD_FLAGS += -allowProvisioningUpdates
}
