// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "board.h"

Board::Board(QObject *parent) : QObject(parent), m_items() { }

Board::~Board()
{
    qDeleteAll(m_items);
}

QQmlListProperty<BoardItem> Board::items()
{
    return { this, &m_items };
}
