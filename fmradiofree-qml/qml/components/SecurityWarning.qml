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

import QtQuick 1.1

Item {
    id: securityContainer
    height: 854; width: 480

    MouseArea {
        z: 3
        anchors.fill: parent
        onClicked: {
            securityContainer.opacity = 0
        }
    }

    Rectangle {
        id: whiteBackgr
        x: 10
        y: 277
        height: 854; width: 480
        opacity: 0.200
        color: "white"
        z: 1
        anchors.fill: parent
    }

    Rectangle {
        id: blackbackground
        x: 0
        y: 0
        opacity: 0.800
        color: "black"
        radius: 20
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: 300; width: 460
        z: 2

        smooth: true

        Text {
                id: text1
                text: qsTr("fm-tr-retro-security-warning") //"Failed to turn on the Radio module. If problem remains, please re-install the package."
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.bottomMargin: 10
                anchors.topMargin: 10
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.pixelSize: 40
            }
    }
}
