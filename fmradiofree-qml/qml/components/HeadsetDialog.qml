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
    id: container
    height: 854; width: 480

    MouseArea {
        z: 1
        anchors.fill: parent
        onClicked: {
            container.opacity = 0
            container.height = 0
        }
    }

    Rectangle {
        x: 10
        y: 277
        height: 854; width: 480
        opacity: 0.200
        color: "white"
        z: -2
        anchors.fill: parent
    }

    Rectangle {
        id: background
        x: 0
        y: 0
        opacity: 0.800
        color: "black"
        radius: 20
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: 300; width: 460
        z: -1

        smooth: true

        Text {
                id: text1
                text: qsTr("fm-tr-retro-connect-headset") // "Please connect headset for better reception quality."
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
