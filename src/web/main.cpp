// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include <QCommandLineParser>
#include <QLibraryInfo>
#include <QCoreApplication>

#ifndef PORT
#  define PORT 49425
#endif

using namespace Qt::StringLiterals;

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName(u"Remote Whiteboard httpd"_s);

    QCoreApplication app(argc, argv);

    QCommandLineParser parser;
    parser.addOptions({
            { "port", QCoreApplication::translate("main", "The port the server listens on."),
              "port" },
    });
    parser.addHelpOption();
    parser.process(app);

    return app.exec();
}
