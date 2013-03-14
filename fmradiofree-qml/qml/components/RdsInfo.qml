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
    id: rdsContainer
    width: 480
    height: 153
    smooth: true
    property string stationNameText
    property string ptyInfoText
    property string rdsRadioText
    property string rdsSubText
    property bool isEnabled: false
    property bool isPowered: false

    onIsEnabledChanged:
    {
        if(isEnabled)
        {
            rdsSubText = "";
            cursorTimer.start();
            if(rdsRadioText.length > 0)
            {
                textTimer.start();
            }
        }
        else
        {
            textTimer.stop();
            cursorTimer.stop();
        }
    }

    onRdsRadioTextChanged:
    {
        rdsSubText = "";

        if(isEnabled)
        {
            textTimer.start();
        }
    }

    Component.onCompleted:
    {
        if(isEnabled)
        {
            cursorTimer.start();

            if(rdsRadioText.length > 0)
            {
                textTimer.start();
            }
        }
    }

    Item {
        id: item1
        smooth: true
        anchors.fill: parent

        Image {
            id: background
            anchors.fill: parent
            source: "rds-screen-bg.png"
            z: -1
        }

        Rectangle {
            id: turnedOffCover

            anchors.fill: parent
            anchors.leftMargin: 23
            anchors.rightMargin: 25
            anchors.topMargin: 26
            anchors.bottomMargin: 28

            z:1

            smooth: true
            color: "black"
            radius: 3
            opacity: isPowered ? 0 : 0.600

            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }
        }

        Image {
            id: glass
            anchors.fill: parent
            source: "rds-screen-glass.png"
            z: 2
        }

        Timer {
            id: textTimer
            interval: 50
            repeat: true

            onTriggered:
            {
                if(rdsSubText == rdsRadioText)
                {
                    stop();
                }
                else
                {
                    rdsSubText = rdsRadioText.substring(0, rdsSubText.length + 1);
                }
            }
        }

        Timer {
            id: cursorTimer
            interval: 1000
            repeat: true

            onTriggered: rdsText.cursorDisplayed = !rdsText.cursorDisplayed
        }

        Image {
            anchors.top: parent.top
            anchors.topMargin: 38
            anchors.left: parent.left
            anchors.leftMargin: 32
            source: "rds-logo.png"
            opacity: isPowered ? 1 :0

            Behavior on opacity {NumberAnimation {duration: 500} }
        }

        FontLoader { id: pixelFont; source: "Smirnof.ttf" }

        Text {
            id: stationName
            width: 174
            height: 25
            color: "#ffcc66"
            text: stationNameText.length > 0 ? stationNameText : "Loading..."
            verticalAlignment: Text.AlignVCenter
            font.family: pixelFont.name
            anchors.left: parent.left
            anchors.leftMargin: 78
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            anchors.top: parent.top
            anchors.topMargin: 40
            font.pixelSize: 25
            opacity: isPowered ? 1 :0
            Behavior on opacity {NumberAnimation {duration: 500} }
        }

        Text {
            id: ptyInfo
            x: 248
            y: 29
            width: 202
            height: 25
            color: "#ffcc66"
            font.family: pixelFont.name
            text: ptyInfoText
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.verticalCenterOffset: -2
            anchors.verticalCenter: stationName.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 16
            opacity: isPowered ? 1 :0
            Behavior on opacity {NumberAnimation {duration: 500} }
        }

        Text {
            id: rdsText
            property bool cursorDisplayed: true
            x: 5
            y: 79
            width: 450
            height: 55
            color: "#ffcc66"
            text: "<html>" + rdsSubText + ((cursorDisplayed && rdsSubText.length < 64) ? "&#9608;" : "") + "</html>"
            style: Text.Normal
            font.family: "Courier New"
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WrapAnywhere
            anchors.right: parent.right
            anchors.rightMargin: 31
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 29
            font.pixelSize: 22
            anchors.leftMargin: 32
            anchors.left: parent.left
            opacity: isPowered ? 1 :0
            Behavior on opacity {NumberAnimation {duration: 500} }
        }
    }
}
