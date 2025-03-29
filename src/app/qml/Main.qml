// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Controls.Material
import QtQuick.Layouts

ApplicationWindow {
    id: root
    title: qsTr("Noteboard")
    width: 360
    height: 800
    minimumHeight: 600
    minimumWidth: 270
    visible: true

    background: Rectangle {
        color: palette.base
    }

    header: ToolBar {
        id: toolbar

        background: Rectangle {
            color: palette.base
        }

        Item {
            anchors.fill: parent

            Label {
                id: label
                text: qsTr("Noteboard")
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 0
            }

            ToolButton {
                id: drawerButton
                action: drawerAction
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    property list<string> builtInStyles

    function navigate(view: int, source: string) {
        if (view === Constants.currentView) {
            return;
        }

        // Map of page names to properties to pass
        const propertiesMap = {
            [Constants.View.Settings]: {
                "builtInStyles": root.builtInStyles
            }
        };
        const properties = propertiesMap[view] || {};

        switch (view) {
            case Constants.View.Back:
                stackView.pop();
                break;
            default:
                Constants.currentView = view;
                stackView.pushItem(source, properties);
                break;
        }
    }

    Universal.theme: Constants.isDarkMode ? Universal.Dark : Universal.Light
    Material.theme: Constants.isDarkMode ? Material.Dark : Material.Light

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: navigate(Constants.View.Back)
    }

    Action {
        id: drawerAction
        icon.name: "drawer"
        icon.source: "qrc:/qt/qml/Noteboard/icons/drawer.svg"
        icon.color: palette.buttonText
        onTriggered: drawer.open()
    }

    Action {
        shortcut: StandardKey.Quit
        onTriggered: close()
    }

    ListModel {
        id: menuItems

        ListElement {
            title: qsTr("Notes")
            page: Constants.View.Home
            source: "qrc:/qt/qml/Noteboard/qml/HomePageContainer.qml"
            iconName: "sticky"
        }
        ListElement {
            title: qsTr("Services")
            page: Constants.View.Services
            source: "qrc:/qt/qml/Noteboard/qml/ServicesPage.qml"
            iconName: "services"
        }
        ListElement {
            title: qsTr("Settings")
            page: Constants.View.Settings
            source: "qrc:/qt/qml/Noteboard/qml/SettingsPage.qml"
            iconName: "settings"
        }
        ListElement {
            title: qsTr("Colors")
            page: Constants.View.Colors
            source: "qrc:/qt/qml/Noteboard/qml/ColorsPage.ui.qml"
            iconName: "settings"
        }
        ListElement {
            title: qsTr("About")
            page: Constants.View.About
            source: "qrc:/qt/qml/Noteboard/qml/AboutPageContainer.qml"
            iconName: "info"
        }
    }

    Drawer {
        id: drawer

        width: root.width * 0.66
        height: root.height

        ListView {
            id: listView

            focus: true
            currentIndex: -1
            anchors.fill: parent
            model: menuItems

            delegate: ItemDelegate {
                id: delegateItem
                width: ListView.view.width
                text: title
                highlighted: ListView.isCurrentItem

                required property int index
                required property int page
                required property var model
                required property string title
                required property string source

                onClicked: {
                    listView.currentIndex = index
                    navigate(page, source)
                    drawer.close()
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    SideBar {
        id: sideMenu

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        height: parent.height
        rightPadding: 5

        menuOptions: menuItems
        currentPage: Constants.currentView
        onItemClicked: (page, source) => navigate(page, source)
    }

    StackView {
        id: stackView
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        initialItem: HomePageContainer {}
    }

    StateGroup {
        states: [
            State {
                name: "desktopLayout"
                when: Constants.layout === Constants.Layout.Desktop

                PropertyChanges {
                    target: drawerButton
                    visible: false
                }
                PropertyChanges {
                    target: toolbar
                    height: 56
                }
                PropertyChanges {
                    target: sideMenu
                    visible: true
                    anchors.topMargin: 63
                }
                AnchorChanges {
                    target: stackView
                    anchors.left: sideMenu.right
                }
            },
            State {
                name: "mobileLayout"
                when: Constants.layout === Constants.Layout.Mobile

                PropertyChanges {
                    target: sideMenu
                    visible: false
                }
                PropertyChanges {
                    target: drawerButton
                    visible: true
                }
                PropertyChanges {
                    target: toolbar
                    height: 39
                }
                AnchorChanges {
                    target: stackView
                    anchors.left: parent.left
                }
            }
        ]
    }

    Component.onCompleted: Constants.init(root)
}
