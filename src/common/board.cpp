// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "board.h"
#include <QPainter>
#include <QFont>

Board::Board(QObject *parent) : QObject(parent), m_items() { }

Board::~Board()
{
    qDeleteAll(m_items);
}

QQmlListProperty<BoardItem> Board::items()
{
    return { this, &m_items };
}

QImage Board::renderToImage(qreal width, qreal height)
{
    QImage image(width, height, QImage::Format_ARGB32);
    image.fill(Qt::transparent);

    QPainter painter(&image);
    QFont font("Arial", 20, QFont::Bold);
    painter.setFont(font);
    painter.setPen(Qt::black);

    QString text = "TODO";
    QFontMetrics metrics(font);
    const int textWidth = metrics.horizontalAdvance(text);
    const int textHeight = metrics.height();
    const int x = (width - textWidth) / 2;
    const int y = (height + textHeight) / 2 - metrics.descent();

    painter.drawText(x, y, text);

    return image;
}
