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
import QtMobility.feedback 1.1

Item {
    id: container

    property string text
    property url picture
    signal clicked
    signal longTap
    property bool highlited: false
    property bool isForward: false
    property bool dimmed: false

    height: text.height + 10; width: text.width + 20
    smooth: true
    function sourceImage()
    {
        if(dimmed)
        {
            return isForward ? "image://theme/icon-m-toolbar-mediacontrol-next-dimmed-white" : "image://theme/icon-m-toolbar-mediacontrol-previous-dimmed-white"
        }
        else
        {
            return isForward ? (highlited || mouseArea.pressed) ? "image://theme/icon-m-toolbar-mediacontrol-next-white-selected" : "image://theme/icon-m-toolbar-mediacontrol-next-white" : (highlited || mouseArea.pressed) ? "image://theme/icon-m-toolbar-mediacontrol-previous-white-selected" : "image://theme/icon-m-toolbar-mediacontrol-previous-white"
        }
    }

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 50
        height: 50
        smooth: true
        source: sourceImage()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: { container.clicked(); }
        onPressAndHold: { container.longTap(); longTapVibro.start(); }
    }

//    HapticsEffect {
//        id: tapVibro
//        attackIntensity: 0.5
//        attackTime: 30
//        intensity: 0.7
//        duration: 50
//        fadeTime: 30
//        fadeIntensity: 0.5
//    }

    HapticsEffect {
        id: longTapVibro
        attackIntensity: 0.3
        attackTime: 100
        intensity: 1.0
        duration: 150
        fadeTime: 100
        fadeIntensity: 0.3
    }
}
