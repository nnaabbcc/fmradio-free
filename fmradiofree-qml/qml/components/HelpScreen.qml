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
import "../../skin-chooser"
import QtQuick 1.1

Item {
    id: container
    height: 854; width: 480
    property string translatedText: qsTr("fm-tr-retro-help-text")

    MouseArea {
        z: -2
        anchors.fill: parent
    }

    Rectangle {
        id: background
        x: 0
        y: 0
        opacity: 0.900
        color: "black"
        radius: 20
        z: -1
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.topMargin: 10
        anchors.fill: parent
        smooth: true


    Image {
        id: backButton
        width: 81
        height: 81
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        smooth: true
        source: mouseArea.pressed ? "close-btn-pressed.png" : "close-btn-normal.png"

        MouseArea {
            id: mouseArea
            z: 1
            anchors.fill: parent
            onClicked: {
                container.opacity = 0
                container.height = 0
            }
        }
    }

    Text {
            id: title
            width: 440
            height: 52
            text: qsTr("fm-tr-retro-app-title") //"FM Radio"
            anchors.top: parent.top
            anchors.topMargin: 10
            color: "#cccccc"
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.bold: true
            font.pixelSize: 45
        }

    Text {
        id: version
        width: 440
        height: 30
        color: "#cccccc"
        text:  qsTr("fm-tr-retro-app-version").replace("%1",tunerModel.getVersion()) // " version 1.0.0"
        anchors.top: title.bottom
        anchors.topMargin: 0
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pixelSize: 22
    }

    Text {
        id: link
        width: 440
        height: 30
        color: "#cccccc"
        text: "
            <html>
                <style>
                    a
                    {
                            font-weight: bold;
                            text-decoration: underline;
                            color: #cccccc;
                    }
                </style>
                <body>
                    <p align='center'> <a align='center' href='http:\/\/fm-radio.mobi/do?action=about&version=1.1.4'>http://fm-radio.mobi<\/a> </p>
                </body>
            </html>"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            verticalAlignment: Text.AlignVCenter
        anchors.top: version.bottom
        anchors.topMargin: 30
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pixelSize: 25

        onLinkActivated: {
            Qt.openUrlExternally(link);
        }
    }

//    Flickable {
//        x: 10
//        y: 97
//        width: 440
//        height: 727
//        clip: true
//        anchors.topMargin: 97
//        anchors.bottomMargin: 10
//        anchors.rightMargin: 10
//        anchors.leftMargin: 10
//        contentHeight: helpText.height
//        contentWidth: helpText.width
//        flickableDirection: Flickable.VerticalFlick
//        anchors.fill: parent

//        Button {
//            id: skinButton
//            width: 400
//            height: 100
//            text: "Change skin"
//            onClicked:
//            {
//                //tunerModel.powerOn(false);
//                tunerModel.changeSkin(1);
//            }
//        }

    LargeButton {
        id: themeBtn
        text: qsTr("fm-tr-retro-switch-theme") //"Switch Theme"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: link.bottom
        anchors.topMargin: 30

        onClicked: {
            skinChooser.opacity = 1;
        }
    }

    LargeButton {
        id: updateBtn
        text: qsTr("fm-tr-retro-rate") //"Rate!"
        icon: "star.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: themeBtn.bottom
        anchors.topMargin: 20
        onClicked: {
            Qt.openUrlExternally("http://store.ovi.com/content/262564")
        }
    }

    LargeButton {
        id: helpBtn
        text: qsTr("fm-tr-retro-help") //"Help"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: updateBtn.bottom
        anchors.topMargin: 20

        onClicked: {
            Qt.openUrlExternally("http://fm-radio.mobi/do?action=help&version=1.1.4")
        }
    }

        Text {
            id: helpText
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            width: 440
            height: 200
            color: "#cccccc"
            text: "<html>
            <style>
            a
            {
                    font: 20px Arial, Verdana, sans-serif;
                    font-weight: bold;
                    color: #cccccc;
                    text-decoration: underline;
            }

            a:hover
            {
                    text-decoration: underline;
            }

            p
            {
                font: 20px/1.5em Verdana;
            }

            <\/style>

            <body>" + translatedText + "</body> </html> "

//            <p>Copyright &copy; 2012 <a href=\"mailto:andy.tolst@gmail.com\">Andrey Kozhanov</a></p>

//            <p>Application backend is based on fmrxd daemon
//            Copyright &copy; 2011 <a href=\"mailto:maemo@javispedro.com\">Javier S. Pedro</a></p>
//            <br>

//            <p>This application includes some parts distributed under GPL license.<br>
//            For more details please refer to <a href='http:\/\/fm-radio.mobi/do?action=about&version=1.1.4'>fm-radio.mobi</a></p>


            anchors.left: parent.left
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignLeft

            font.pointSize: 17
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            textFormat: Text.RichText

            onLinkActivated: {
                Qt.openUrlExternally(link);
            }

        }
//    }

    }

    SkinChooser {
        id: skinChooser
        opacity: 0;

        onClosed: {
            opacity = 0;
        }
    }

}
