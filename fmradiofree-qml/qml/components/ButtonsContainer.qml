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
    Component.onCompleted:
    {
        button1.text = tunerModel.getStation(1) === 0 ? "---" : tunerModel.getStation(1).toFixed(1);
        button2.text = tunerModel.getStation(2) === 0 ? "---" : tunerModel.getStation(2).toFixed(1);
        button3.text = tunerModel.getStation(3) === 0 ? "---" : tunerModel.getStation(3).toFixed(1);
        button4.text = tunerModel.getStation(4) === 0 ? "---" : tunerModel.getStation(4).toFixed(1);
        button5.text = tunerModel.getStation(5) === 0 ? "---" : tunerModel.getStation(5).toFixed(1);
        button6.text = tunerModel.getStation(6) === 0 ? "---" : tunerModel.getStation(6).toFixed(1);

        button7.text = tunerModel.getStation(7) === 0 ? "---" : tunerModel.getStation(7).toFixed(1);
        button8.text = tunerModel.getStation(8) === 0 ? "---" : tunerModel.getStation(8).toFixed(1);
        button9.text = tunerModel.getStation(9) === 0 ? "---" : tunerModel.getStation(9).toFixed(1);
        button10.text = tunerModel.getStation(10) === 0 ? "---" : tunerModel.getStation(10).toFixed(1);
        button11.text = tunerModel.getStation(11) === 0 ? "---" : tunerModel.getStation(11).toFixed(1);
        button12.text = tunerModel.getStation(12) === 0 ? "---" : tunerModel.getStation(12).toFixed(1);
    }

    id: buttonsContainer
    width: 460
    height: 173
    smooth: true
    anchors.right: parent.right
//    anchors.rightMargin: 10
    anchors.left: parent.left
//    anchors.leftMargin: 10
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0

    PathView {
        id: favButtonsList
        x: 0
        y: 0
        width: 460
        height: 178
        smooth: true
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0

        anchors.fill: parent
        clip: true

        model: itemModel
        preferredHighlightBegin: 0;
        preferredHighlightEnd: 0
        highlightRangeMode: PathView.StrictlyEnforceRange

        path: Path {
            startX: -260; startY: 80
            PathLine { x: 720; y: 80;}
        }

    }


    VisualItemModel {
        id: itemModel
        Item
        {
            id: buttonsSet2
            width: 465
            height: 150
            smooth: true

            Item {
                id: buttonsRowRight2
                y: 118
                height: 100
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                Button {
                    id: button10
                    x: 21
                    y: 743
                    width: 142
                    height: 66
                    text: "---"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(10);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(10, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }

                Button {
                    id: button11
                    x: 175
                    y: 743
                    width: 142
                    height: 66
                    text: "---"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(11);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(11, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }

                Button {
                    id: button12
                    x: 323
                    y: 743
                    width: 142
                    height: 66
                    text: "---"
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(12);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(12, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }
            }

            Item {
                id: buttonsRowLeft2
                height: 100
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0

                Button {
                    id: button7
                    width: 142
                    height: 66
                    text: "---"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(7);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(7, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }

                Button {
                    id: button8
                    width: 142
                    height: 66
                    text: "---"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(8);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(8, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }

                Button {
                    id: button9
                    width: 142
                    height: 66
                    text: "---"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(9);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(9, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }
            }

        }
        Item
        {
            id: buttonsSet1
            height: 150
            smooth: true
            width: 465

            Item {
                id: buttonsRowRight
                y: 0
                width: 440

                height: 100
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                Button {
                    id: button4
                    width: 142
                    height: 66
                    text: "---"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(4);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(4, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }

                Button {
                    id: button5
                    x: 175
                    y: 743
                    width: 142
                    height: 66
                    text: "---"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(5);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(5, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }

                Button {
                    id: button6
                    x: 323
                    y: 743
                    width: 142
                    height: 66
                    text: "---"
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(6);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(6, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }
            }

            Item {
                id: buttonsRowLeft

                height: 100
                width: 440
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top

                Button {
                    id: button1
                    width: 142
                    height: 66
                    text: "---"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(1);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(1, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }

                Button {
                    id: button2
                    width: 142
                    height: 66
                    text: "---"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(2);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(2, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }

                Button {
                    id: button3
                    width: 142
                    height: 66
                    text: "---"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    onClicked: { tunerScale.tuneToFreq(text); tunerModel.setActiveStationNum(3);}
                    onLongTap: {text == tunerScale.value.toFixed(1) ? text = "---" : text = tunerScale.value.toFixed(1); tunerModel.storeStation(3, text);}
                    highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                }
            }

        }
    }
}
