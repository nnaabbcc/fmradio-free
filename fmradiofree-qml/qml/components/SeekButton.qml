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

    height: text.height + 10; width: text.width + 20
    smooth: true

    Image {
        anchors.fill: parent
        smooth: true
        source: isForward ? (highlited || mouseArea.pressed) ? "seek_button_right_pressed.png" : "seek_button_right.png" : (highlited || mouseArea.pressed) ? "seek_button_left_pressed.png" : "seek_button_left.png"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: { container.clicked(); tapVibro.start(); }
        onPressAndHold: { container.longTap(); longTapVibro.start(); }
    }

    HapticsEffect {
        id: tapVibro
        attackIntensity: 0.5
        attackTime: 30
        intensity: 0.7
        duration: 50
        fadeTime: 30
        fadeIntensity: 0.5
    }

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
