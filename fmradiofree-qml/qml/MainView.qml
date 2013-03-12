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
import "components"

import QtQuick 1.0

Rectangle {

    id: rootWindow
    anchors.fill: parent
    property bool isInPortrait: (width < height)? true: false
    color: "#000000"
    height: 854; width: 480

    Connections {
       target: tunerModel
       onScanCompleted: {
                            tunerScale.tuneToFreq(tunerModel.currentFreq());
                            buttonForward.highlited = false;
                            buttonBackward.highlited = false;
                        }
       onSignalChanged: signalMeter.value = tunerModel.signalLevel()

       onTurnedOff: powerSwitch.isEnabled = false
       onSpeakerStateChanged: speakerButton.isSpeaker = tunerModel.isLoudSpeaker();
    }

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

        tunerScale.tuneToFreq(tunerModel.currentFreq());

        speakerButton.isSpeaker = tunerModel.isLoudSpeaker();

        powerSwitch.isEnabled = tunerModel.isPowered();
    }

    onIsInPortraitChanged: console.log("Orientation portrait " + isInPortrait);

        Rectangle {
            id: rectangle1
            x: 0
            y: 114
            width: 480
            height: 472
            color: "#000000"
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 114
            anchors.top: rootWindow.top

            DigitalTuner {
                id: digitalTuner
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                value: tunerScale.tuningValue
            }

            TunerScale {
                id: tunerScale
                x: 10
                height: 184
                anchors.top: digitalTuner.bottom
                anchors.topMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 7
                anchors.left: parent.left
                anchors.leftMargin: 7
                powered: powerSwitch.isEnabled

                onValueChanged: {
                    if(powerSwitch.isEnabled) {
                        tunerModel.tuneToFreq(value.toFixed(1));
                    }
                }
            }

            SeekButton {
                id: buttonBackward
                x: 10
                width: 139
                height: 63
                text: "<<"
                anchors.top: tunerScale.bottom
                anchors.topMargin: 5
                opacity: 0.700
                anchors.left: parent.left
                anchors.leftMargin: 10
                onClicked: tunerScale.tuneToFreq(tunerScale.value - 0.1)
                onLongTap: { tunerModel.scan(false); highlited = true;}
                isForward: false;
            }

            SeekButton {
                id: buttonForward
                x: 331
                y: 374
                width: 139
                height: 63
                text: ">>"
                anchors.top: tunerScale.bottom
                anchors.topMargin: 5
                opacity: 0.700
                anchors.right: parent.right
                anchors.rightMargin: 10
                onClicked: tunerScale.tuneToFreq(tunerScale.value + 0.1)
                onLongTap: { tunerModel.scan(true); highlited = true;}
                isForward: true;
            }

            AnalogMeter {
                id: signalMeter;
                x: 155
                y: 374
                width: 170
                height: 95
                anchors.horizontalCenterOffset: 0
                anchors.top: parent.top
                anchors.topMargin: 374
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle {
            id: rectangle2
            x: 25
            y: 309
            width: 430
            height: 11
            radius: 2
            visible: true
            anchors.top: rectangle1.bottom
            anchors.topMargin: -297
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#7e7c7c"
                }

                GradientStop {
                    position: 1
                    color: "#000000"
                }
            }
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
        }

        PowerSwitch {
            id: powerSwitch
            x: 375
            y: 10
            width: 85
            height: 85
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10

            onIsEnabledChanged: {
                tunerModel.powerOn(isEnabled);

                if(isEnabled)
                {
                    tunerModel.tuneToFreq(tunerScale.value.toFixed(1))
                }

                signalMeter.powered = isEnabled;
                digitalTuner.powered = isEnabled;
            }
            }

            BorderImage {
                id: border_image1
                x: 10
                y: 618
                width: 460
                height: 226
                smooth: true
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                border.bottom: 10
                border.top: 10
                border.right: 10
                border.left: 10
                source: "components/border.png"

                PathView {
                    id: favButtonsList
                    smooth: true
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0

                    anchors.fill: parent
                    clip: true

                    model: itemModel
                    preferredHighlightBegin: 0;
                    preferredHighlightEnd: 0
                    highlightRangeMode: PathView.StrictlyEnforceRange

                    path: Path {
                        startX: -230; startY: 113
                        PathLine { x: 670; y: 113;}
                    }

                }


                VisualItemModel {
                    id: itemModel
                    Item
                    {
                        id: buttonsSet2
                        width: 440
                        height: 206
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
                                width: 140
                                height: 100
                                text: "---"
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 0
                                anchors.left: parent.left
                                anchors.leftMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(10, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }

                            Button {
                                id: button11
                                x: 175
                                y: 743
                                width: 140
                                height: 100
                                text: "---"
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 0
                                anchors.horizontalCenter: parent.horizontalCenter
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(11, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }

                            Button {
                                id: button12
                                x: 323
                                y: 743
                                width: 140
                                height: 100
                                text: "---"
                                anchors.right: parent.right
                                anchors.rightMargin: 0
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(12, text);}
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
                                width: 140
                                height: 100
                                text: "---"
                                anchors.top: parent.top
                                anchors.topMargin: 0
                                anchors.left: parent.left
                                anchors.leftMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(7, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }

                            Button {
                                id: button8
                                width: 140
                                height: 100
                                text: "---"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                anchors.topMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(8, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }

                            Button {
                                id: button9
                                width: 140
                                height: 100
                                text: "---"
                                anchors.top: parent.top
                                anchors.topMargin: 0
                                anchors.right: parent.right
                                anchors.rightMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(9, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }
                        }

                    }
                    Item
                    {
                        id: buttonsSet1
                        height: 206
                        smooth: true
                        width: 440

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
                                width: 140
                                height: 100
                                text: "---"
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 0
                                anchors.left: parent.left
                                anchors.leftMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(4, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }

                            Button {
                                id: button5
                                x: 175
                                y: 743
                                width: 140
                                height: 100
                                text: "---"
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 0
                                anchors.horizontalCenter: parent.horizontalCenter
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(5, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }

                            Button {
                                id: button6
                                x: 323
                                y: 743
                                width: 140
                                height: 100
                                text: "---"
                                anchors.right: parent.right
                                anchors.rightMargin: 0
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(6, text);}
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
                                width: 140
                                height: 100
                                text: "---"
                                anchors.top: parent.top
                                anchors.topMargin: 0
                                anchors.left: parent.left
                                anchors.leftMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(1, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }

                            Button {
                                id: button2
                                width: 140
                                height: 100
                                text: "---"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                anchors.topMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(2, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }

                            Button {
                                id: button3
                                width: 140
                                height: 100
                                text: "---"
                                anchors.top: parent.top
                                anchors.topMargin: 0
                                anchors.right: parent.right
                                anchors.rightMargin: 0
                                onClicked: tunerScale.tuneToFreq(text)
                                onLongTap: {text = tunerScale.value.toFixed(1); tunerModel.storeStation(3, text);}
                                highlited: powerSwitch.isEnabled && tunerScale.value.toFixed(1) === text
                            }
                        }

                    }

                }
            }

            Rectangle {
                id: rectangle4
                x: 25
                y: 290
                width: 430
                height: 5
                radius: 2
                visible: true
                anchors.bottom: rectangle1.top
                anchors.bottomMargin: -175
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 0
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#7e7c7c"
                    }

                    GradientStop {
                        position: 1
                        color: "#000000"
                    }
                }
            }

            HelpButton {
                id: helpButton
                x: 10
                y: 8
                width: 90
                height: 90
                smooth: true

                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 0

                onClicked: {
                    helpScreen.opacity = 1;
                    helpScreen.height = 854
                }
            }

            SpeakerButton {
                id: speakerButton
                x: 106
                y: 8
                width: 90
                height: 90
                smooth: true

                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 85

                onClicked: {
                    tunerModel.setLoudSpeaker(!tunerModel.isLoudSpeaker());
                }
            }

            Image {
                id: image2
                x: 202
                y: 33
                width: 152
                height: 41
                sourceSize.height: 44
                sourceSize.width: 170
                smooth: true
                anchors.top: parent.top
                anchors.topMargin: 33
                source: "components/title.png"
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 202
                anchors.left: parent.left
            }

            HelpScreen {
                id:helpScreen
                x:0
                y:0
                opacity:0
                anchors.fill: parent
                height: 0

                Behavior on height { NumberAnimation {duration: 500}}
                z: 100
                Behavior on opacity { NumberAnimation {duration: 500}}
            }
}
