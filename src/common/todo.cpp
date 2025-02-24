// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "todo.h"

TODO::TODO(const QString &text, QObject *parent)
    : QObject(parent)
    , m_text(text)
{}
