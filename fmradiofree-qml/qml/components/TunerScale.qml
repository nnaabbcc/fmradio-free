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
    id: tunerWidget
    width: 480
    height: 198

    property real value: 87.5
    property real tuningValue: 87.5
    property real minValue: 87.5
    property real maxValue: 108
    property bool moving: tuner.moving
    property bool powered: false
    function tuneToFreq(val) {
        if(val >= minValue && val <= maxValue) {
            tuneAnimation.stop()
            tuneAnimation.to = (tuner.contentWidth - tuner.width) * (val - minValue) / (maxValue - minValue)
            tuneAnimation.duration = Math.abs(value - val) > 0.3 ? 600 : 50
            tuneAnimation.easing.type = Math.abs(value - val) > 0.3 ? Easing.InOutQuint : Easing.Linear
            tuneAnimation.start()
            value = val;
        }
    }

    onPoweredChanged: {
        if(powered)
        {
            turnedOffCover.opacity = 0;
        }
        else
        {
            turnedOffCover.opacity = 0.6;
        }
    }

    Image {
        id: background
        fillMode: Image.PreserveAspectFit
        smooth: true
        z: -1
        anchors.fill: parent
        source: "scale_background.png"
    }

    Flickable {
        id: tuner
        property real value: 88
        anchors.rightMargin: 27
        anchors.leftMargin: 24
        anchors.bottomMargin: 29
        anchors.topMargin: 28
        smooth: true
        boundsBehavior: Flickable.StopAtBounds

        anchors.fill: parent

        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        flickableDirection: Flickable.HorizontalFlick
        contentWidth: scaleImage.width;
        contentHeight: scaleImage.height;
        clip: true

        Image {
            id: scaleImage
            x: 0
            y: 0
            width: 1400
            height: 140
            z:1
            smooth: true
            sourceSize.height: 140
            sourceSize.width: 1400
            clip: true
            fillMode: Image.TileHorizontally
            source: "radio_scale.jpg"
        }

        Rectangle {
            id: turnedOffCover
            x:0
            y:0
            z:2
            width: scaleImage.width
            height: scaleImage.height
            smooth: true
            color: "black"
            opacity: 0.600

            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }
        }

        onContentXChanged: {
            var tmpVal = minValue + (contentX/(contentWidth - tuner.width)) * (maxValue - minValue)
            if(tmpVal >= minValue && tmpVal <= maxValue)
            {
                tunerWidget.tuningValue = tmpVal.toFixed(1)
            }

            if(moving) {
                tunerWidget.value = tuningValue
            }
        }

        onMovementStarted: {
            tuneAnimation.stop()
        }

        NumberAnimation on contentX { id: tuneAnimation; easing.type: Easing.InOutQuint; duration: 600 }
    }

    Image {
        id: blackCover

        z: 3
        fillMode: Image.TileVertically
        opacity: 1
        smooth: true
        source: "black_cover.png"
        anchors.fill: tuner

        visible: false
    }

    Image {
        id: scalePointer
        sourceSize.height: 198
        sourceSize.width: 480

        anchors.fill: parent

        smooth: true
        z: 2

        fillMode: Image.PreserveAspectFit
        source: "scale_glass_cover.png"
    }

}
