// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Noteboard.Services

Column {
    id: root

    property alias menuOptions: repeater.model
    property int currentPage
    property list<ServiceBase> services: []
    signal itemClicked(int item, string source, variant params)

    leftPadding: 5
    spacing: 5

    Repeater {
        id: repeater
        model: menuOptions

        delegate: ItemDelegate {
            id: columnItem

            required property string title
            required property string iconName
            required property string source
            required property int page

            readonly property bool active: currentPage === columnItem.page
            readonly property color backgroundColor: palette.highlight

            width: column.width
            height: column.height
            onClicked: itemClicked(page, source, undefined)

            background: Rectangle {
                color: active ? backgroundColor : "transparent"
                anchors.fill: parent
                radius: 12
                opacity: 0.1
            }

            Component.onCompleted: {
                iconButton.clicked.connect(columnItem.clicked);
                arrowIcon.clicked.connect(columnItem.clicked);
            }

            Column {
                id: column
                padding: 0

                Item {
                    id: menuItem

                    width: 290
                    height: 60

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 31
                        anchors.rightMargin: 13
                        spacing: 24

                        Item {
                            Layout.preferredWidth: 34
                            Layout.preferredHeight: 34
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                            ToolButton {
                                id: iconButton
                                icon.source: `qrc:/qt/qml/Noteboard/icons/${columnItem.iconName}.svg`
                                icon.width: 34
                                icon.height: 34
                                icon.color: palette.buttonText
                                padding: 0
                                down: true
                                background: Rectangle {
                                    color: "transparent"
                                }
                            }
                        }

                        Label {
                            id: label
                            text: title
                            color: "yellow"
                            font.pixelSize: 18
                            font.weight: 600
                            Layout.fillWidth: true
                        }

                        ToolButton {
                            id: arrowIcon

                            icon.source: columnItem.active
                                ? Qt.resolvedUrl("../icons/arrow-down.svg")
                                : Qt.resolvedUrl("../icons/arrow.svg")
                            icon.width: 25
                            icon.height: 25
                            icon.color: "white"
                            padding: 0
                            flat: true
                            down: true
                            background: Rectangle {
                                color: "transparent"
                            }
                            visible: columnItem.page === Constants.View.Services
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        }
                    }
                }

                ListView {
                    id: subpagesView
                    model: (columnItem.page === Constants.View.Services) ? root.services : []
                    width: parent.width
                    height: contentHeight
                    visible: columnItem.active && model.length > 0
                    delegate: ItemDelegate {
                        id: delegate
                        width: subpagesView.width
                        height: 44
                        required property QtObject model
                        readonly property string name: model.modelData.name
                        readonly property url iconUrl: model.modelData.iconUrl
                        readonly property url pageUrl: model.modelData.pageUrl
                        onClicked: root.itemClicked(columnItem.page, delegate.pageUrl, {
                            service: model.modelData
                        })

                        RowLayout {
                            width: 190
                            spacing: 6
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            Button {
                                icon.source: delegate.iconUrl
                                icon.color: "white"
                                icon.height: 30
                                icon.width: 30
                                background: Item {}
                                onClicked: delegate.clicked()
                            }

                            Label {
                                text: delegate.name
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }
}