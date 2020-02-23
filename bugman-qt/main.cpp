#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include "app.h"
#include "entry.h"
#include "androidfilter.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>

void requestAndroidPermissions();
#endif

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    
    QGuiApplication app(argc, argv);
    
#ifdef Q_OS_ANDROID
    requestAndroidPermissions();
#endif
    
    qmlRegisterType<AndroidFilter>("AndroidFilter", 1, 0, "AndroidFilter");
    
    QQmlApplicationEngine engine;
    
    App::registerSingleton(&engine);
    
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    
    engine.load(url);
    
    return app.exec();
}

#ifdef Q_OS_ANDROID

typedef QtAndroid::PermissionResult Permission;

void requestAndroidPermissions() {
    
    const QStringList permissions({
        "android.permission.ACCESS_COARSE_LOCATION",
        "android.permission.ACCESS_FINE_LOCATION",
        "android.permission.READ_EXTERNAL_STORAGE",
        "android.permission.WRITE_EXTERNAL_STORAGE",
        "android.permission.CAMERA",
    });
    
    QHash<QString, Permission> results =
        QtAndroid::requestPermissionsSync(permissions);
    
    for (QString permission : results.keys()) {
        auto status = results[permission];
        
        switch (status) {
        case Permission::Denied: 
            qDebug() << permission << ": Denied";
            break;
            
        case Permission::Granted:
            qDebug() << permission << ": Granted";
            break;
        }
    }
    
//    if (resultHash[permission] == QtAndroid::PermissionResult::Denied) {
//        return false;
//    }
    
//    for (const QString &permission : permissions) {
//        auto result = QtAndroid::checkPermission(permission);
        
//        if (result == QtAndroid::PermissionResult::Denied) {
            
//        }
//    }
}
#endif
