// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtCore
import QtQml.Models
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import noteboard.common

HomePage {
    function extractTitle(markdown: string): string {
        const lines = markdown.replace(/\r\n|\r/g, "\n").split("\n").map((str) => str.trim());
        let paragraphLines = [];

        for (const line of lines) {
            // Skip blank lines and non-paragraph blocks
            if (!line || /^([-+*] |\d+\.\s+|>)/.test(line)) {
                // If we already have the title lines, stop processing. Otherwise, ignore.
                if (paragraphLines.length > 0) {
                    break;
                } else {
                    continue;
                }
            }

            // Headings are always a single line.
            if (/^#+\s/.test(line)) {
                paragraphLines = [line.replace(/^#+\s/, "")];
                break;
            }

            paragraphLines.push(line);
        }

        return paragraphLines.join(" ")
            // Remove images
            .replace(/!\[.*?\]\(.*?\)/g, '')
            // Replace links with just the text
            .replace(/\[(.*?)\]\(.*?\)/g, "$1")
            // Remove bold
            .replace(/(\*\*|__)(.*?)\1/g, "$2")
            // Remove italic
            .replace(/(\*|_)(.*?)\1/g, "$2")
            // Remove inline code
            .replace(/`([^`]*)`/g, "$1")
            // Remove HTML tags
            .replace(/<[^>]+>/g, "")
            .trim();
    }

    //footerAddButton.onClicked: noteClicked({ text: "", uuid: Crypto.randomUUID() })
    //headerAddButton.onClicked: noteClicked({ text: "", uuid: Crypto.randomUUID() })

    note: Item {
        id: delegate
        width: GridView.view.cellWidth
        height: GridView.view.cellHeight
        required property QtObject model
        required property int index

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"
            height: parent.height - 10
            width: parent.width - 10

            NoteCard {
                anchors.fill: parent
                title: delegate.model.title

                TapHandler {
                    onTapped: noteClicked(delegate.model)
                }
            }
        }
    }
}
