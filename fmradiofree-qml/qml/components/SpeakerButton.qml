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
    property bool isSpeaker: false

    signal clicked

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            container.clicked();
        }
    }

    Image {
        id: image
        smooth: true
        anchors.fill:parent
        source: mouseArea.pressed ? isSpeaker ? "speaker_button_highlited.png" : "speaker_button_headset_highlited.png" : isSpeaker ? "speaker_button.png" : "speaker_button_headset.png"
    }
}
