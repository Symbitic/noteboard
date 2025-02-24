// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef TODO_H
#define TODO_H

#include <QString>

//! [0]
class TODO : public QObject
{
    Q_OBJECT

public:
    TODO(const QString &text, QObject *parent = nullptr);

private:
    QString m_text;
};

#endif
