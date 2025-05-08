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
#include <QtGui/QImage>

class Board : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QAbstractListModel *notesModel READ notesModel NOTIFY loaded)
    QML_ELEMENT

public:
    explicit Board(QObject *parent = nullptr);
    ~Board();

    QString error() const;

    QString title() const;
    void setTitle(const QString &title);

    QAbstractListModel *notesModel();

    Q_INVOKABLE bool loadFromFile(const QUrl &filepath);

    Q_INVOKABLE QImage renderToImage(qreal width, qreal height);

signals:
    void errorChanged();
    void loaded();
    void titleChanged();

private:
    QString m_error;
    QString m_title;
    BoardNotesModel m_notesModel;
};

#endif
