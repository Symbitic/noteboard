// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Universal
import QtQuick.Layouts
import noteboard.common

ApplicationWindow {
    id: root
    title: qsTr("Noteboard")
    width: 360
    height: 800
    minimumHeight: 600
    minimumWidth: 270
    visible: true
    header: toolbar
    background: Rectangle {
        color: palette.alternateBase
    }

    property string lastSource: ""
    property list<string> builtInStyles
    // Map of page names to properties to pass to stackView.
    // This was the most delarative method since QML doesn't have key-value objects.
    readonly property variant propertiesMap: ({
        [Constants.View.Settings]: {
            builtInStyles: builtInStyles
        }
    })

    function navigate(view: int, source: string) {
        if (view === Constants.currentView && source === root.lastSource) {
            return;
        }

        const properties = root.propertiesMap[view] || {};

        switch (view) {
            case Constants.View.Back:
                stackView.pop();
                break;
            default:
                Constants.currentView = view;
                root.lastSource = source;
                stackView.pushItem(source, properties);
                break;
        }
    }

    Material.theme: Constants.isDarkMode ? Material.Dark : Material.Light
    Universal.theme: Constants.isDarkMode ? Universal.Dark : Universal.Light

    Board {
        id: board
    }

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: navigate(Constants.View.Back)
    }

    Action {
        id: backAction
        enabled: stackView.depth > 1
        icon.name: stackView.depth > 1 ? "back" : ""
        icon.source: stackView.depth > 1 ? "../icons/back.svg" : ""
        icon.color: palette.buttonText
        onTriggered: {
            if (stackView.depth > 1) {
                stackView.pop()
                listView.currentIndex = -1
            }
        }
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
            subpages: []
        }
        ListElement {
            title: qsTr("Services")
            page: Constants.View.Services
            source: "qrc:/qt/qml/Noteboard/qml/ServicesPageContainer.qml"
            iconName: "services"
            subpages: [
                ListElement {
                    title: qsTr("Samsung Frame")
                    source: "services/SamsungFrame.qml"
                    iconName: "services/SamsungFrame"
                }
            ]
        }
        ListElement {
            title: qsTr("Settings")
            page: Constants.View.Settings
            source: "qrc:/qt/qml/Noteboard/qml/SettingsPageContainer.qml"
            iconName: "settings"
            subpages: []
        }
        ListElement {
            title: qsTr("About")
            page: Constants.View.About
            source: "qrc:/qt/qml/Noteboard/qml/AboutPageContainer.qml"
            iconName: "info"
            subpages: []
        }
    }

    ToolBar {
        id: toolbar
        height: label.implicitHeight + 20

        background: Rectangle {
            color: palette.alternateBase
        }

        Item {
            anchors.fill: parent

            ToolButton {
                id: backButton
                action: backAction
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                id: label
                text: qsTr("Noteboard")
                color: palette.text
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pixelSize: 20
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
                name: "desktop"
                when: Constants.layout === Constants.Layout.Desktop

                PropertyChanges {
                    target: backButton
                    visible: false
                }
                PropertyChanges {
                    target: drawerButton
                    visible: false
                }
                PropertyChanges {
                    target: sideMenu
                    visible: true
                }
                AnchorChanges {
                    target: stackView
                    anchors.left: sideMenu.right
                }
            },
            State {
                name: "mobile"
                when: Constants.layout === Constants.Layout.Mobile

                PropertyChanges {
                    target: sideMenu
                    visible: false
                }
                PropertyChanges {
                    target: backButton
                    visible: true
                }
                PropertyChanges {
                    target: drawerButton
                    visible: true
                }
                AnchorChanges {
                    target: stackView
                    anchors.left: parent.left
                }
            }
        ]
    }

    Connections {
        target: stackView.currentItem
        ignoreUnknownSignals: true

        function onServiceClicked(service: string, title: string) {
            stackView.pushItem(Qt.resolvedUrl("services/%1.qml".arg(service)))
        }
    }

    Component.onCompleted: {
        Constants.init(root)
        navigate(Constants.View.Services, "qrc:/qt/qml/Noteboard/qml/ServicesPageContainer.qml")
    }
}
