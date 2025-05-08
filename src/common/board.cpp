// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "board.h"
#include <QPainter>
#include <QFile>
#include <QFont>
#include <QRegularExpression>
#include <QTextDocument>
#include <QTextDocumentFragment>
#include <QTextBlock>
#include <QtCore/qloggingcategory.h>

Q_LOGGING_CATEGORY(boardLog, "noteboard.common.board")

const char *DEFAULT_CONTENT = R"(# TODO List

## Watch and sort videos

## WebComponents Framework

- Make basic website
- GitHub Workflow to enforce conventional commits

## Sign up

## Qt Devcontainer Feature

)";

Board::Board(QObject *parent) : QObject(parent), m_title()
{
    connect(&m_notesModel, &BoardNotesModel::dataChanged, [&]() { emit loaded(); });
}

Board::~Board() { }

QString Board::error() const
{
    return m_error;
}

QString Board::title() const
{
    return m_title;
}

void Board::setTitle(const QString &title)
{
    if (m_title != title) {
        m_title = title;
        emit titleChanged();
    }
}

bool Board::loadFromFile(const QUrl &filepath)
{
    if (!filepath.isLocalFile()) {
        qCWarning(boardLog) << "File \"" << filepath.toString() << "\" is not a local file";
        return false;
    }

    QFile file(filepath.toLocalFile());

    if (!file.exists()) {
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            qCCritical(boardLog) << "Unable to create file " << file.fileName();
            return false;
        } else if (file.write(DEFAULT_CONTENT) == -1) {
            qCCritical(boardLog) << "File error:" << file.errorString();
            return false;
        }
        file.close();
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qCWarning(boardLog) << "Unable to open file:" << file.errorString();
        return false;
    }

    QByteArray data = file.readAll();
    QTextDocument doc;
    QString title;
    doc.setMarkdown(data);

    QTextBlock block = doc.firstBlock();
    QString noteText;
    int sectionHeadingLevel = 0;

    // Handle an (optional) Level 1 header as title.
    if (block.isValid() && block.blockFormat().headingLevel() == 1) {
        title = doc.firstBlock().text();
        block = block.next();
    }

    QList<Note> notes;
    QRegularExpression titleRegex("^#+\\s([^\\n]+)\\n+(.+)",
                                  QRegularExpression::MultilineOption
                                          | QRegularExpression::DotMatchesEverythingOption);

    while (block.isValid()) {
        QTextCursor cursor(block);
        cursor.select(QTextCursor::BlockUnderCursor);
        const QString blockText = cursor.selection().toMarkdown();
        const int headingLevel = block.blockFormat().headingLevel();

        if (sectionHeadingLevel == 0 && headingLevel > 0) {
            sectionHeadingLevel = headingLevel;
        }
        if (headingLevel == sectionHeadingLevel) {
            if (noteText.size() > 0) {
                if (QRegularExpressionMatch match = titleRegex.match(noteText); match.hasMatch()) {
                    notes << Note(match.captured(1).trimmed(), match.captured(2).trimmed());
                } else {
                    notes << Note(noteText.trimmed());
                }
                noteText = QString("");
            }
        }
        noteText += blockText;
        block = block.next();
    }

    if (noteText.size() > 0) {
        if (QRegularExpressionMatch match = titleRegex.match(noteText); match.hasMatch()) {
            notes << Note(match.captured(1).trimmed(), match.captured(2).trimmed());
        } else {
            notes << Note(noteText.trimmed());
        }
        noteText = QString("");
    }

    m_notesModel.addNotes(notes);
    emit loaded();

    return true;
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

QAbstractListModel *Board::notesModel()
{
    return &m_notesModel;
}
