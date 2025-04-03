// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef COMMON_BOARDITEM_H
#define COMMON_BOARDITEM_H

#include <QString>
#include <QObject>
#include <QDateTime>
#include <QtQml/qqml.h>

class BoardItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY dataChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY dataChanged)
    Q_PROPERTY(QDateTime createdDate READ createdDate NOTIFY dataChanged)
    Q_PROPERTY(QDateTime modifiedDate READ modifiedDate NOTIFY dataChanged)
    QML_ELEMENT

public:
    explicit BoardItem(QObject *parent = nullptr);
    BoardItem(const BoardItem &other);

    QString id() const;
    QString text() const;
    QDateTime createdDate() const;
    QDateTime modifiedDate() const;

    void setText(const QString &text);

signals:
    void dataChanged();

private:
    QString m_uuid;
    QString m_text;
    QDateTime m_createdDate;
    QDateTime m_modifiedDate;
};

Q_DECLARE_METATYPE(BoardItem)

#endif
