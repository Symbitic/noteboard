// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef REMOTEWHITEBOARD_ITEM_H
#define REMOTEWHITEBOARD_ITEM_H

#include <QString>
#include <QObject>
#include <QtQml/qqml.h>

namespace RemoteWhiteboard {

class Item : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged REQUIRED)
    QML_ELEMENT

public:
    Item(const QString &text, QObject *parent = nullptr);
    Item(QObject *parent = nullptr);

    QString text() const;
    void setText(const QString &text);

    // QDateTime QDateTime::currentDateTimeUtc()

signals:
    void textChanged(QString);

private:
    QString m_text;
};

} // namespace RemoteWhiteboard

#endif
