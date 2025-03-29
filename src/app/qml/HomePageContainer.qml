// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtCore
import QtQml.Models
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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

    ListModel {
        id: notesList

        ListElement {
            uuid: "1"
            text: "Watch and sort video collection"
        }
        ListElement {
            uuid: "2"
            text: "**WebComponents Framework**\n\n- Make basic website\n- GitHub Workflow to enforce conventional commits\n"
        }
        ListElement {
            uuid: "3"
            text: "Sign up for Benefits"
        }
        ListElement {
            uuid: "4"
            text: "Qt Devcontainer Feature"
        }
    }
    Component.onCompleted: {
        for (let i=0; i<notesList.count; i++) {
            notesList.setProperty(i, "createdDate", new Date())
        }
    }

    property url notesFolder: `${StandardPaths.writableLocation(StandardPaths.DocumentsLocation)}/Notes`

    model: notesList
    note: Rectangle {
        required property string text
        readonly property string title: extractTitle(text)

        color: palette.midlight
        radius: 10
        Layout.fillWidth: true
        Layout.preferredHeight: 40

        Label {
            anchors.centerIn: parent
            text: parent.title
            color: palette.text
        }
    }
}
