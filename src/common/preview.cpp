// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "preview.h"
#include <QPainter>

BoardPreview::BoardPreview(QQuickItem *parent) : QQuickPaintedItem(parent), m_board(nullptr) { }

Board *BoardPreview::board() const
{
    return m_board;
}

void BoardPreview::setBoard(Board *board)
{
    if (m_board != board) {
        m_board = board;
        emit boardChanged();
    }
}

void BoardPreview::paint(QPainter *painter)
{
    painter->drawImage(0, 0, m_board->renderToImage(width(), height()));
}
