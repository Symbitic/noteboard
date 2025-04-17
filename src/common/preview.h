// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef COMMON_PREVIEW_H
#define COMMON_PREVIEW_H

#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtQml/qqml.h>
#include <QtQml/qqmllist.h>
#include <QtQuick/QQuickPaintedItem>
#include <QImage>
#include <QUrl>

#include "board.h"

class BoardPreview : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(Board *board READ board WRITE setBoard NOTIFY boardChanged)
    QML_ELEMENT

public:
    explicit BoardPreview(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;

    Board *board() const;
    void setBoard(Board *board);

Q_SIGNALS:
    void boardChanged();

private:
    Board *m_board;
};

#endif
