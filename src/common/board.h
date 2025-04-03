// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef COMMON_BOARD_H
#define COMMON_BOARD_H

#include "item.h"

#include <QtCore/qlist.h>
#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtQml/qqml.h>
#include <QtQml/qqmllist.h>

class Board : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<BoardItem> items READ items NOTIFY itemsChanged)
    QML_ELEMENT

public:
    explicit Board(QObject *parent = nullptr);
    ~Board();

    QQmlListProperty<BoardItem> items();

signals:
    void itemsChanged();

private:
    QList<BoardItem *> m_items;
};

#endif
