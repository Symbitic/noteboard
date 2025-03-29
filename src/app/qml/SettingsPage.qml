// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtQuick
import QtQuick.Controls
import Noteboard

SettingsView {
    id: root
    property list<string> builtInStyles
    styles: builtInStyles
    themes: ListModel {}

    stylesComboBox.onActivated: (index) => {
        const style = stylesComboBox.textAt(index);
        AppSettings.style = style;
        AppSettings.theme = Constants.Theme.System;
        showStyleTip = true;
        resetThemes();
    }

    themesComboBox.textRole: "name"
    themesComboBox.valueRole: "theme"
    themesComboBox.onActivated: (index) => {
        const theme = themesComboBox.valueAt(index);
        AppSettings.theme = theme;
    }

    // Only show themes available for the current style.
    function resetThemes(theme = 0) {
        themes.clear();
        for (let i=0; i<themesModel.count; i++) {
            if (themesModel.get(i).supported(AppSettings.style)) {
                themes.append(themesModel.get(i));
            }
        }
        currentThemeIndex = theme;
    }

    Component.onCompleted: {
        currentStyleIndex = styles.indexOf(AppSettings.style);
        resetThemes(AppSettings.theme);
    }

    ListModel {
        id: themesModel

        ListElement {
            name: qsTr("System")
            theme: Constants.Theme.System
            supported: () => true
        }
        ListElement {
            name: qsTr("Light")
            theme: Constants.Theme.Light
            supported: (currentStyle) => !["Basic"].includes(currentStyle)
        }
        ListElement {
            name: qsTr("Dark")
            theme: Constants.Theme.Dark
            supported: (currentStyle) => !["Basic"].includes(currentStyle)
        }
    }
}
