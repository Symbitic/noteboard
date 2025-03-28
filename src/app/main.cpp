// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QQuickStyle>
#include <unistd.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName("Remote Whiteboard");
    QGuiApplication::setOrganizationName("N/A");

    QSettings settings;
    const QString style = settings.value("style").toString();
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE") && style.isEmpty()) {
#if defined(Q_OS_MACOS)
        QQuickStyle::setStyle(QString("iOS"));
#elif defined(Q_OS_IOS)
        QQuickStyle::setStyle(QString("iOS"));
#elif defined(Q_OS_WINDOWS)
        QQuickStyle::setStyle(QString("Windows"));
#elif defined(Q_OS_ANDROID)
        QQuickStyle::setStyle(QString("Material"));
#endif
    } else {
        QQuickStyle::setStyle(style);
    }

    if (style.isEmpty()) {
        settings.setValue(QString("style"), QQuickStyle::name());
    }

    QStringList builtInStyles = { QString("Fusion"), QString("Material"), QString("Universal") };
#if defined(Q_OS_MACOS)
    builtInStyles << QString("iOS");
#elif defined(Q_OS_IOS)
    builtInStyles << QString("iOS");
#elif defined(Q_OS_WINDOWS)
    builtInStyles << QString("Windows");
#endif

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QGuiApplication::quit);

    engine.setInitialProperties({ { "builtInStyles", builtInStyles } });
    engine.loadFromModule("RemoteWhiteboard", "Main");
    if (engine.rootObjects().isEmpty()) {
        exit(EXIT_FAILURE);
    }

    return app.exec();
}
