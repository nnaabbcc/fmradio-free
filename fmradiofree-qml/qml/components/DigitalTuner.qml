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
    id: item1
    property double value
    property bool powered: false

//    width: image100.width * 5;
//    height: image100.height;
    width: 480;
    height: 210;

    Image {
        id: background;
        anchors.fill: parent
        source: "nixie_background.png"
    }

    NixieTubeDigit {
        id: image100
        anchors.left: parent.left
        anchors.leftMargin: 30
        //anchors.top : parent.top
        anchors.verticalCenter: parent.verticalCenter
        value: (parent.value/100)%10 - 0.5
        isEmpty: value === 0
        powered: parent.powered
    }

    NixieTubeDigit {
        id: image10
        anchors.left: image100.right
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        value: (parent.value/10)%10 - 0.5
        powered: parent.powered
    }

    NixieTubeDigit {
        id: image1
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: image10.right
        value: parent.value%10 - 0.5
        powered: parent.powered
    }

    NixieTubeDigit {
        id: imageDot
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: image1.right
        isDot: true
        powered: parent.powered
    }

    NixieTubeDigit {
        id: imageDec
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: imageDot.right
        value: (parent.value.toFixed(1)*10)%10
        powered: parent.powered
    }
}
