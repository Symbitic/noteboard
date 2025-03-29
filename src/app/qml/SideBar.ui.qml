/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

Column {
    id: root

    property alias menuOptions: repeater.model
    property int currentPage
    signal itemClicked(int item, source: string)

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

            background: Rectangle {
                color: active ? backgroundColor : "transparent"
                anchors.fill: parent
                radius: 12
                opacity: 0.1
            }

            Column {
                id: column
                padding: 0

                Item {
                    id: menuItem

                    width: 290
                    height: 60
                    visible: true

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
                                icon.source: `qrc:/qt/qml/Noteboard/icons/${columnItem.iconName}.svg`
                                icon.width: 34
                                icon.height: 34
                                icon.color: palette.buttonText
                                padding: 0
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
                    }
                }
            }

            onClicked: {
                itemClicked(columnItem.page, columnItem.source)
            }
        }
    }
}