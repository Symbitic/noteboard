// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef ITEM_H
#define ITEM_H

#include <QString>
#include <QObject>
#include <QtQml/qqml.h>

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

signals:
    void textChanged(QString);

private:
    QString m_text;
};

#endif
