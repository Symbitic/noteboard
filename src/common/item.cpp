// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "item.h"

using namespace RemoteWhiteboard;

Item::Item(const QString &text, QObject *parent) : QObject(parent), m_text(text) { }

Item::Item(QObject *parent) : QObject(parent), m_text() { }

QString Item::text() const
{
    return m_text;
}

void Item::setText(const QString &text)
{
    if (m_text == text) {
        return;
    }
    m_text = text;
    emit textChanged(text);
}
