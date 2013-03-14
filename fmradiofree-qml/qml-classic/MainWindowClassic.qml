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
import com.nokia.meego 1.0
import "components"

PageStackWindow {
    id: rootWindow
    showStatusBar : false
    initialPage: MainPage { id: mainPage }

    Component.onCompleted: {
        screen.allowedOrientations = Screen.Portrait;
        theme.inverted = true;
    }

    StationListPage { id: stationListPage}

    Sheet {
        id: addSheet
        property string freq
        property string name
        property string cachedRds
        property bool useCachedRds: false

        onStatusChanged: {
            if(status == DialogStatus.Open)
            {
                nameTextEdit.forceActiveFocus();
            }
        }

        onNameChanged: {
            nameTextEdit.text = name;
        }

        onFreqChanged: {
            freqLabel.text = freq + " FM";
        }

        acceptButtonText: qsTr("fm-tr-classic-save") //"Save"
        rejectButtonText: qsTr("fm-tr-classic-cancel") //"Cancel"

        content: Item {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10

            Label {
                id: freqLabel
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.left: parent.left
                anchors.right: parent.right
                text: ""
                font.pixelSize: 40
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: nameLabel
                anchors.top: freqLabel.bottom
                anchors.topMargin: 12
                anchors.left: parent.left
                anchors.right: parent.right
				font.pixelSize: 24
                text: qsTr("fm-tr-classic-station-name") //"Station name:"
            }

            TextField {
                id: nameTextEdit
                 placeholderText: ""
                 maximumLength: 40
                 anchors.top: nameLabel.bottom
                 anchors.topMargin: 10
                 anchors.left: parent.left
                 anchors.right: parent.right
                 text: ""
            }

            MagicLabel {
                id: rdsTooltip
                anchors.top: nameTextEdit.bottom
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.right: parent.right
                text: ""
                newText: (addSheet.useCachedRds ? addSheet.cachedRds : mainPage.globalRDSName)
                font.pixelSize: 45
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked:  {
                        if(rdsTooltip.text.length > 0)
                        {
                            nameTextEdit.text = rdsTooltip.text;
                        }
                        nameTextEdit.forceActiveFocus();
                    }
                }
            }

        }
        onAccepted: {
            if(freq >=87.5 && freq <=108)
            {
                stationsModel.addNewStation(freq, nameTextEdit.text);
                var ind = stationsModel.indexByFreq(freq);
                if(ind !== -1)
                {
                    mainPage.currentListIndex = ind;
                }
            }
        }
        onRejected: {}
    }

    Sheet {
        id: saveAsSheet
        property string name
        property string duration: "00:00"

        onStatusChanged: {
            if(status == DialogStatus.Open)
            {
                fnameTextEdit.forceActiveFocus();
            }
        }

        onNameChanged: {
            fnameTextEdit.text = name;
        }

        acceptButtonText: qsTr("fm-tr-classic-save") //"Save"
        rejectButtonText: qsTr("fm-tr-classic-cancel") //"Cancel"

        content: Item {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10

            Label {
                id: titleLabel
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.left: parent.left
                anchors.right: parent.right
                font.pixelSize: 32
                //font.weight: Font.Bold
                text: qsTr("fm-tr-classic-record-file-title") //"Save new recording"
            }

            Label {
                id: fnameLabel
                anchors.top: titleLabel.bottom
                anchors.topMargin: 16
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5
                font.pixelSize: 24
                color: "#adb2ad"
                text: qsTr("fm-tr-classic-file-name") //"File name:"
            }

            TextField {
                id: fnameTextEdit
                 placeholderText: ""
                 maximumLength: 40
                 anchors.top: fnameLabel.bottom
                 anchors.topMargin: 10
                 anchors.left: parent.left
                 anchors.right: parent.right
                 text: ""
            }

            Label {
                id: durationLabel
                anchors.top: fnameTextEdit.bottom
                anchors.topMargin: 24
                anchors.left: parent.left
                anchors.right: parent.right
                font.pixelSize: 24
                color: "#adb2ad"
                text: qsTr("fm-tr-classic-file-duration") + " " + saveAsSheet.duration //"Duration:"
            }

            Switch {
                id: openFileCheck
                checked: true
                anchors.top: durationLabel.bottom
                anchors.topMargin: 16
                anchors.right: parent.right
            }

            Label {
                id: openFileLabel
                anchors.verticalCenter: openFileCheck.verticalCenter
                anchors.left: parent.left
                anchors.right: openFileCheck.left
                anchors.rightMargin: 16
                font.pixelSize: 26
                font.weight: Font.Black
                text: qsTr("fm-tr-classic-file-open-player") //"Play automatically"
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: openFileDescLabel
                anchors.top: openFileLabel.bottom
                anchors.topMargin: 12
                anchors.left: parent.left
                anchors.right: openFileCheck.left
                font.pixelSize: 24
                color: "#adb2ad"

                text: qsTr("fm-tr-classic-file-open-player-description") //"Start file playback immediatelly after it is saved"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

        }
        onAccepted: {
            tunerModel.moveFile(fnameTextEdit.text, openFileCheck.checked);
            name = ""
        }
        onRejected: { name = "" }
    }

}
