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

import QtMobility.feedback 1.1
import com.nokia.meego 1.0

Item {

    id: rootWindow
    anchors.fill: parent
    property bool isInPortrait: (width < height)? true: false
    //property string stationName
    property bool isActive: false
    height: 854; width: 480

    states: [
        State {
            name: "fullsize-visible"
            when: platformWindow.viewMode == WindowState.Fullsize && platformWindow.visible
            StateChangeScript {
                script: {
                    isActive = true
                    tunerModel.setActive(true);
                }
            }
        },
        State {
            name: "thumbnail-or-invisible"
            when: platformWindow.viewMode == WindowState.Thumbnail || !platformWindow.visible
            StateChangeScript {
                script: {
                    isActive = false
                    tunerModel.setActive(false);
                }
            }
        }
    ]

    Connections {
       target: tunerModel
       onScanCompleted: {
                            tunerScale.tuneToFreq(tunerModel.currentFreq());
                            buttonForward.highlited = false;
                            buttonBackward.highlited = false;
                        }
       onSignalChanged: signalMeter.value = tunerModel.signalLevel() * 2

       onTurnedOff: powerSwitch.isEnabled = false
       onTurnedOn: powerSwitch.isEnabled = true
       onSpeakerStateChanged: {
           speakerButton.isSpeaker = tunerModel.isLoudSpeaker();
           if(!tunerModel.isLoudSpeaker())
           {
            headsetDialog.opacity = 0;
           }
           }
       onScanBkwStarted: buttonBackward.highlited = true;
       onScanFwdStarted: buttonForward.highlited = true;

       onRdsChanged: {
           rdsContainer.rdsRadioText = tunerModel.getRdsText();
           rdsContainer.stationNameText = tunerModel.getStationName();
           rdsContainer.ptyInfoText = tunerModel.getPtyInfo();
           }

       onSecurityFailed: {
           powerSwitch.isEnabled = false;
           securityDialog.z = 120;
           securityDialog.opacity = 1;
       }
    }

    Timer {
        id: sliderCloseTimer
        interval: 1500
        repeat: false

        onTriggered:
        {
            openCloseAnimation.start();
        }
    }

    SequentialAnimation {
        id: openCloseAnimation
        NumberAnimation {duration: 400; easing.type: Easing.InOutCubic; target: draggableContainer; property: "y"; to: 490 + 50}
        PauseAnimation { duration: 100 }
        NumberAnimation {duration: 400; easing.type: Easing.InOutCubic; target: draggableContainer; property: "y"; to: 490}
    }

    Component.onCompleted:
    {
        tunerScale.tuneToFreq(tunerModel.currentFreq());

        speakerButton.isSpeaker = tunerModel.isLoudSpeaker();

        powerSwitch.isEnabled = tunerModel.isPowered();

        if(tunerModel.isLoudSpeaker() && tunerModel.isFirstTime())
        {
            headsetDialog.opacity = 1;
        }

        sliderCloseTimer.start();
        console.log("Loaded vintage skin ");
    }

    Image {
        anchors.fill: parent
        source: "components/background.jpg"
        smooth: true
    }
        Item {
            id: rectangle1
            x: 0
            y: 114
            width: 480
            height: 472
            //color: "#000000"
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 94
            anchors.top: rootWindow.top


            DigitalTuner {
                id: digitalTuner
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
                value: tunerScale.tuningValue
            }

            TunerScale {
                id: tunerScale
                x: 10
                //height: 184
                anchors.top: digitalTuner.bottom
                anchors.topMargin: 7
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                powered: powerSwitch.isEnabled

                onValueChanged: {
                    if(powerSwitch.isEnabled) {
                        tunerModel.tuneToFreq(value.toFixed(1));
                    }
                }
            }

            RdsInfo {
                id: rdsContainer
                width: 480
                height: 153
                anchors.top: tunerScale.bottom
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                isEnabled: powerSwitch.isEnabled && rootWindow.isActive && draggableContainer.isOpened
                isPowered: powerSwitch.isEnabled
            }
        }

        PowerSwitch {
            id: powerSwitch
            x: 375
            y: 10
            width: 85
            height: 85
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: title.verticalCenter

            onIsEnabledChanged: {
                console.log("powered-" + isEnabled);
                tunerModel.powerOn(isEnabled);

                if(isEnabled && tunerModel.currentFreq() != 0)
                {
                    tunerModel.tuneToFreq(tunerScale.value.toFixed(1))
                }

                signalMeter.powered = isEnabled;
                digitalTuner.powered = isEnabled;
            }
            }

        Item {
            id: draggableContainer
            width: 480
            height: 365
            anchors.horizontalCenter: parent.horizontalCenter
            x: 10
            y: dragMouseArea.drag.minimumY
            property bool isOpened: false

            Behavior on y { NumberAnimation {id:draggableContainerAnimation; easing.type: Easing.OutCubic; duration: 200} }

            onIsOpenedChanged:
            {
                    tapVibro.start();
            }

            MouseArea {
                id: dragMouseArea
                z: -1
                anchors.fill: parent
                drag.target: draggableContainer
                drag.axis: Drag.YAxis
                drag.minimumY: 490
                drag.maximumY: 490 + buttonsContainer.height + 113
                onReleased:
                {
                    if(draggableContainer.y > dragMouseArea.drag.minimumY + (dragMouseArea.drag.maximumY - dragMouseArea.drag.minimumY - 113)/2)
                    {
                        draggableContainer.y = dragMouseArea.drag.maximumY - 110;
                        draggableContainer.isOpened = true
                    }
                    else
                    {
                        draggableContainer.y = dragMouseArea.drag.minimumY;
                        draggableContainer.isOpened = false
                    }
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
            }

            Image {
                id: buttBackgr
                fillMode: Image.PreserveAspectFit
                source: "components/panel_background.png"
                anchors.topMargin: 0
                z: -1
                anchors.fill: parent
            }

            Item {
                id: vuMeterPanel
                width: parent.width
                height: 168
                anchors.horizontalCenterOffset: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter

                SeekButton {
                    id: buttonBackward
                    y: 457
                    width: 97
                    height: 85
                    text: "<<"
                    anchors.verticalCenterOffset: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 32
                    anchors.verticalCenter: signalMeter.verticalCenter
                    opacity: 1
                    onClicked: {
                        if(draggableContainer.isOpened)
                        {
                            tunerModel.prevStation();
                        }
                        else
                        {
                            tunerScale.tuneToFreq(tunerScale.value - 0.1)
                        }
                    }
                    onLongTap: {
                        if(powerSwitch.isEnabled)
                        {
                            tunerModel.scan(false); highlited = true;
                        }
                    }
                    isForward: false;
                }

                SeekButton {
                    id: buttonForward
                    x: 331
                    y: 468
                    width: 97
                    height: 85
                    text: ">>"
                    anchors.verticalCenterOffset: 8
                    anchors.right: parent.right
                    anchors.rightMargin: 32
                    anchors.verticalCenter: signalMeter.verticalCenter
                    opacity: 1
                    onClicked: {
                        if(draggableContainer.isOpened)
                        {
                            tunerModel.nextStation();
                        }
                        else
                        {
                            tunerScale.tuneToFreq(tunerScale.value + 0.1)
                        }
                    }
                    onLongTap: {
                        if(powerSwitch.isEnabled)
                        {
                            tunerModel.scan(true); highlited = true;
                        }
                    }
                    isForward: true;
                }

                AnalogMeter {
                    id: signalMeter;
                    width: 169
                    height: 168
                    anchors.horizontalCenterOffset: 0
                    anchors.top: parent.top
                    anchors.topMargin: 22
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }


            ButtonsContainer {
                id: buttonsContainer
                width: 460
                height: 173
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
        }

//            ListView {
//                id: panelsList
//                model: panelsItemModel
//                width: 460
//                height: 333
//                x: 10
//                y: 511

//                clip: true
//                snapMode: ListView.SnapOneItem
//                highlightRangeMode: ListView.StrictlyEnforceRange
//                boundsBehavior: Flickable.StopAtBounds
//                currentIndex: 1

//                onCurrentIndexChanged:
//                {
//                    tapVibro.start();
//                }

//                HapticsEffect {
//                    id: tapVibro
//                    attackIntensity: 0.5
//                    attackTime: 30
//                    intensity: 0.7
//                    duration: 50
//                    fadeTime: 30
//                    fadeIntensity: 0.5
//                }
//            }

//            VisualItemModel {
//                id: panelsItemModel
//                Item {
//                    width: 460
//                    height: 173
////                    Rectangle {
////                        id: rdsBackgr
////                        width: 460
////                        height: 173
////                        color: "#89bcf5"
////                        opacity: 0.500
////                        z: -1
////                    }

//                }
//            }

            HelpButton {
                id: helpButton
                y: 8
                width: 58
                height: 57
                anchors.verticalCenterOffset: 0
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: title.verticalCenter
                smooth: true


                onClicked: {
                    helpScreen.opacity = 1;
                    helpScreen.height = 854
                }
            }

            SpeakerButton {
                id: speakerButton
                y: 8
                width: 55
                height: 55
                anchors.verticalCenterOffset: -2
                anchors.left: helpButton.right
                anchors.leftMargin: 18
                anchors.verticalCenter: title.verticalCenter
                smooth: true


                onClicked: {
                    tunerModel.setLoudSpeaker(!tunerModel.isLoudSpeaker());
                }
            }

            Image {
                id: title
                x: 192
                width: 97
                height: 89
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.height: 89
                sourceSize.width: 97
                smooth: true
                source: "components/title.png"
                fillMode: Image.PreserveAspectFit
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

            HeadsetDialog {
                id: headsetDialog;
                opacity: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Behavior on opacity { NumberAnimation {duration: 500}}
            }

            SecurityWarning {
                id: securityDialog;
                opacity: 0
                anchors.fill: parent
                Behavior on opacity { NumberAnimation {duration: 500}}
                z: 120
            }
}
