/*
 *  fmradio-qml - UI for FM radio
 *  Copyright (C) 2012 Andrey Kozhanov <andy.tolst@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

import QtQuick 1.0

Item {
    id: container

    property string text
    property url picture
    signal clicked
    signal longTap
    property bool highlited: false

    height: text.height + 10; width: text.width + 20
    smooth: true

    Image {
        anchors.fill: parent
        fillMode: Image.Stretch
        smooth: true
        source: highlited ? "button_enabled.png" : !mouseArea.pressed ? "button_disabled.png" : "button_pressed.png"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: container.clicked()
        onPressAndHold: container.longTap()
    }

    Text {
        id: text
        anchors.centerIn:parent
        font.pointSize: 25
        font.bold: true
        text: parent.text
    }
}
