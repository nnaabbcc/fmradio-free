import "components"
import "../skin-chooser"

import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: mainPage
    width: 480
    height: 854
    tools: buttonTools
    orientationLock: PageOrientation.LockPortrait
    anchors.topMargin: 20
//    anchors.margins: rootWindow.pageMargin
    property bool isSpeaker: false
    property string globalRDSName
    property string globalRDSText
    property int currentListIndex: -1
    property bool scanning: false
    property bool skipScanCancel: false

    onCurrentListIndexChanged: {
        if(mainPage.currentListIndex === -1)
        {
            smallStationsListView.hideDetails = true;
        }
        else
        {
            if(smallStationsListView.currentIndex === mainPage.currentListIndex && tunerScale.value!==smallStationsListView.currentItem.currentFreq)
            {
                tunerScale.tuneToFreq(smallStationsListView.currentItem.currentFreq);
            }
            smallStationsListView.currentIndex = mainPage.currentListIndex;
            smallStationsListView.hideDetails = false;
        }
    }

    states: [
        State {
            name: "fullsize-visible"
            when: platformWindow.viewMode == WindowState.Fullsize && platformWindow.visible
            StateChangeScript {
                script: {
                    tunerModel.setActive(true);
                }
            }
        },
        State {
            name: "thumbnail-or-invisible"
            when: platformWindow.viewMode == WindowState.Thumbnail || !platformWindow.visible
            StateChangeScript {
                script: {
                    tunerModel.setActive(false);
                }
            }
        }
    ]

    Connections {
       target: tunerModel
       onScanCompleted: {
           if(!scanning)
           {
               scanButton.stopManualScan();
               if(smallStationsListView.count > 0)
               {
                   scanButton.opacity = 0;
               }
               smallStationsListView.opacity = 1;
           }
           else
           {
               flashingLabel.blink();
           }

           tunerScale.tuneToFreq(tunerModel.currentFreq());
           buttonForward.highlited = false;
           buttonBackward.highlited = false;

           var tmp = stationsModel.indexByFreq(tunerModel.currentFreq());
           if(tmp === -1)
           {
               smallStationsListView.hideDetails = true;
           }
           else
           {
               smallStationsListView.hideDetails = false;
               smallStationsListView.currentIndex = tmp;
           }
       }

       onFullScanCompleted: {
           scanning = false;

           scanButton.stopAnimation();
           smallStationsListView.opacity = 1;
           if(smallStationsListView.count > 0)
           {
               scanButton.opacity = 0;
               smallStationsListView.currentIndex = 0;
           }

           if(!skipScanCancel)
           {
               pageStack.push(stationListPage);
           }

           skipScanCancel = false;
       }

       onTurnedOff: powerButton.isEnabled = false
       onTurnedOn: powerButton.isEnabled = true
       onSpeakerStateChanged: {
           isSpeaker = tunerModel.isLoudSpeaker();
           if(!tunerModel.isLoudSpeaker())
           {
               headsetDialog.close();
           }
           }
       onScanBkwStarted: {smallStationsListView.opacity = 0; scanButton.opacity = 1; scanButton.startManualScan(); buttonBackward.highlited = true;}
       onScanFwdStarted: {smallStationsListView.opacity = 0; scanButton.opacity = 1;scanButton.startManualScan(); buttonForward.highlited = true;}

       onRdsChanged: {
           ptyLabel.newText = tunerModel.getPtyInfo();
           globalRDSText = tunerModel.getRdsText();
           globalRDSName = tunerModel.getStationName();
           }

       onSecurityFailed: {
           powerButton.isEnabled = false;
           securityWarning.open();
       }

       onRecordingStopped: {
           powerButton.isEnabled = false;
           saveAsSheet.name = smallStationsListView.hideDetails ? qsTr("fm-tr-classic-station").replace("%1", tunerScale.value.toFixed(1)) : smallStationsListView.currentItem.name;
           saveAsSheet.open();
           recordButton.stopRecord();
       }
    }

    Component.onCompleted:
    {
        tunerScale.tuneToFreq(tunerModel.currentFreq());

        var tmp = stationsModel.indexByFreq(tunerModel.currentFreq());
        if(tmp === -1)
        {
            smallStationsListView.hideDetails = true;
        }
        else
        {
            smallStationsListView.hideDetails = false;
            smallStationsListView.currentIndex = tmp;
        }



//        speakerButton.isSpeaker = tunerModel.isLoudSpeaker();

        powerButton.isEnabled = tunerModel.isPowered();

        if(tunerModel.isLoudSpeaker() && tunerModel.isFirstTime())
        {
            headsetDialog.open();
        }
    }


    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-list"; opacity: enabled ? 1 : 0.6; enabled: !scanning && !recordButton.isRecording; onClicked: { myMenu.close(); pageStack.push(stationListPage) }  }
        ToolIcon {
            iconId: "toolbar-add";
            opacity: enabled ? 1 : 0.6;
            enabled: !scanning && !recordButton.isRecording;
            onClicked: {
                        myMenu.close();
                        addSheet.useCachedRds = false;
                        addSheet.name = (globalRDSName.length > 0 ? globalRDSName : (qsTr("fm-tr-classic-station").replace("%1", tunerScale.value.toFixed(1)) /*"Station -  FM"*/));
                        addSheet.freq = tunerScale.value.toFixed(1);
                        addSheet.open();
                        }
        }

        RecordButton {
            id: recordButton
            width: 100
            height: 75
            visible: false;

            isEnabled: powerButton.isEnabled && !scanning && !tunerModel.usbConnected;

            onClicked: {
                if(isRecording)
                {
                    saveAsSheet.duration = recordButton.elapsedString
                    stopRecord();
                    tunerModel.stopRecording();
                }
                else
                {
                    startRecord();
                    tunerModel.startRecording();
                }
            }
        }

        ToolIcon { iconId: isSpeaker ? "toolbar-headphones" : "toolbar-volume" ; opacity: enabled ? 1 : 0.6; enabled: !scanning && !recordButton.isRecording; onClicked: { myMenu.close(); tunerModel.setLoudSpeaker(!tunerModel.isLoudSpeaker()); } }
        ToolIcon { iconId: "toolbar-view-menu" ; opacity: enabled ? 1 : 0.6; enabled: !scanning && !recordButton.isRecording; onClicked: {
                if(myMenu.status == DialogStatus.Open)
                {
                    myMenu.close();
                }
                else
                {
                    myMenu.open();
                }
            }
        }
    }

    Menu {
        id: myMenu
        smooth: true
        visualParent: pageStack

        MenuLayout {
            MenuItem { text: qsTr("fm-tr-classic-scan") /*"Scan"*/; enabled: !scanning;
                onClicked: {
                    scanning = true;
                    smallStationsListView.opacity = 0;

                    tunerModel.fullScan();
                    scanButton.opacity = 1;
                    scanButton.startAnimation();
                }
            }
            MenuItem { text: qsTr("fm-tr-classic-themes") /*"Themes"*/; enabled: !scanning; onClicked: { skinChooser.opacity = 1; /*pageStack.toolbar.visible = false;*/ buttonTools.visible = false; rootWindow.pageStack.toolBar.visible = false;} }
            MenuItem { text: qsTr("fm-tr-classic-help") /*"Help"*/; enabled: !scanning; onClicked: { Qt.openUrlExternally("http://fm-radio.mobi/do?action=help&version=1.1.4") } }
            MenuItem { text: qsTr("fm-tr-classic-about") /*"About"*/; enabled: !scanning; onClicked: { aboutDialog.open(); } }
        }
    }

    ModalDialog {
        id: headsetDialog
        buttonText: "OK"
        titleText: qsTr("fm-tr-classic-connect-headset-title") //"Connect headset"
        bodyText: qsTr("fm-tr-classic-connect-headset-text") //"Please connect headset for better reception quality."
    }

    AboutDialog {
        id: aboutDialog
        parent: rootWindow
    }

    ModalDialog {
        id: securityWarning
        buttonText: "OK"
        titleText: ""
        bodyText: qsTr("fm-tr-classic-security-warning") //"Failed to turn on the Radio module. If problem remains, please re-install the package."
    }

    SkinChooser {
        id: skinChooser;
        anchors.fill: parent
        x:0
        y:0
        z: 1
        opacity: 0;

        onClosed:
        {
            skinChooser.opacity = 0;
            if(skinId != 2)
            {
                rootWindow.pageStack.toolBar.visible = true;
            }
            buttonTools.visible = true;
        }
    }

    Label {
        id: frequencyLabel
        height: 100
        //color: "#ffffff"
        text: tunerScale.tuningValue.toFixed(1)
        font.family: "Nokia Sans"
        smooth: true
        anchors.top: parent.top
        anchors.topMargin: 30
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

//        font.weight: Font.Light
        font.pixelSize: 120

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

    }

    Label {
        id: frequencyLabelMirror
        height: 100
        //color: "#ffffff"
        text: tunerScale.tuningValue.toFixed(1)
        anchors.top: frequencyLabel.bottom
        anchors.topMargin: 69
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        opacity: 0.300
        z: -1
        smooth: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: "Nokia Sans"
//        font.weight: Font.Light
        font.pixelSize: 120


        transform: [
            Scale { origin.x: 0; origin.y: 0; xScale: 1; yScale: 0.7},
            Rotation { origin.x: 0; origin.y: 0; axis { x: 1; y: 0; z: 0 } angle: 180 }
        ]
    }

    Image {
        id: mirrorCover
        anchors.top: frequencyLabel.bottom
        anchors.topMargin: -34

        source: "components/black_cover_mirror.png"

        //asynchronous: true;

    }

    MagicLabel {
        id: ptyLabel
        height: 30
        color: "#C8C8C8"
        font.pixelSize: 25
        newText: ""
        horizontalAlignment: Text.AlignHCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: frequencyLabel.bottom
        anchors.topMargin: 47

        visible: !scanning
    }

    Label {
        id: flashingLabel
        anchors.fill: ptyLabel
        text: qsTr("fm-tr-classic-found") //"Found"
        horizontalAlignment: Text.AlignHCenter
        color: "#C8C8C8"
        font.pixelSize: 25
        opacity: 0

        SequentialAnimation {
            id: flashAnimation
            NumberAnimation {target: flashingLabel; property: "opacity"; to: 1; duration: 200 }
            NumberAnimation {target: flashingLabel; property: "opacity"; to: 0; duration: 200 }
        }

        function blink() {
            flashAnimation.stop();
            flashAnimation.start();
        }
    }

    TunerScale {
        id: tunerScale
        anchors.top: ptyLabel.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        powered: !recordButton.isRecording; // powerButton.isEnabled

        onValueChanged: {
            if(powerButton.isEnabled) {
                tunerModel.tuneToFreq(value.toFixed(1));
            }

            if(!moving)
            {
                var tmp = stationsModel.indexByFreq(value.toFixed(1));
                if(tmp === -1)
                {
                    smallStationsListView.hideDetails = true;
                }
                else
                {
                    smallStationsListView.hideDetails = false;
                    smallStationsListView.currentIndex = tmp;
                }
            }
        }

        onMovingChanged: {
            if(!moving)
            {
                var tmp = stationsModel.indexByFreq(value.toFixed(1));
                if(tmp === -1)
                {
                    smallStationsListView.hideDetails = true;
                }
                else
                {
                    smallStationsListView.hideDetails = false;
                    smallStationsListView.currentIndex = tmp;
                }
            }
        }
    }


    // The actual list
    ListView {
        id: smallStationsListView
        height: 140
        width: parent.width
        clip: true
        anchors.top: tunerScale.bottom
        anchors.topMargin: 50

        model: stationsModel
        delegate: stationListDelegate
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightFollowsCurrentItem: true
        highlightRangeMode: ListView.StrictlyEnforceRange

        highlightMoveDuration: 500

        cacheBuffer: 480;

        interactive: !recordButton.isRecording

        property bool hideDetails: false

        onHideDetailsChanged: {
            if(hideDetails)
            {
                stationListPage.currentListIndex = -1;
            }
            else
            {
                stationListPage.currentListIndex = currentIndex;
            }
        }

        onCurrentIndexChanged: {
            if(currentIndex!=-1)
            {
                console.log("curr index changed" + currentIndex + " " + currentItem.currentFreq + "_" + tunerScale.value)
                if(tunerScale.value!=currentItem.currentFreq)
                {
                    tunerScale.tuneToFreq(currentItem.currentFreq);
                }

                if(hideDetails)
                {
                    hideDetails = false;
                }
            }
            stationListPage.currentListIndex = currentIndex;
            mainPage.currentListIndex = currentIndex;

            tunerModel.setActiveStationNum(currentIndex);
        }

        onCountChanged: {
            if(count == 0)
            {
                scanButton.opacity = 1
            }
        }

        Behavior on opacity {NumberAnimation {duration: 300} }
    }

    Component {
        id: stationListDelegate

        Item {
            width: 480
            height: userNameLabel.height + rdsNameLabel.height + rdsTextLabel.height
            property double currentFreq: freq
            property bool hide: false
            property string name: username
            Label {
                id: userNameLabel
                height: 50
                text: username
                elide: Text.ElideRight
                x: 0
                y: 0
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.weight: Font.Bold
                font.pixelSize: 40

                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                opacity: smallStationsListView.hideDetails ? 0 : 1

                Behavior on opacity {NumberAnimation {duration: 300} }

            }

            MagicLabel {
                id: rdsNameLabel
                height: 30
                newText: smallStationsListView.hideDetails ? globalRDSName : rdsname
                anchors.top: userNameLabel.bottom
                anchors.topMargin: 0
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.weight: Font.Light
                font.pixelSize: 32

                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

            }

            MagicLabel {
                id: rdsTextLabel
                height: 60
                color: "#C8C8C8"
                newText: smallStationsListView.hideDetails ? globalRDSText : rdstext
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.top: rdsNameLabel.bottom
                anchors.topMargin: 0
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.weight: Font.Light
                font.pixelSize: 22

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
        }
    }


    Item {
        id: rdsContainer
        height: 170
        width: parent.width
        clip: true
        anchors.top: tunerScale.bottom
        anchors.topMargin: 30
        opacity: (smallStationsListView.count == 0 || smallStationsListView.opacity == 0) ? 1 : 0;

        Behavior on opacity {NumberAnimation {duration: 300} }

        ScanButton {
            id: scanButton
            height: 100
            enabled: !recordButton.isRecording

            anchors.top: parent.top
            anchors.topMargin: -10

            anchors.horizontalCenter: parent.horizontalCenter;

            onClicked:
            {
                if(!scanning && !manualScan)
                {
                    tunerModel.fullScan();
                    startAnimation();
                    scanning = true;
                }
            }

            Behavior on opacity {NumberAnimation {duration: 200} }
            z: 1
        }

        MagicLabel {
            id: globalrdsNameLabel
            height: 30
            newText: globalRDSName
            anchors.top: parent.top
            anchors.topMargin: 80
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font.weight: Font.Light
            font.pixelSize: 32

            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        MagicLabel {
            id: globalrdsTextLabel
            height: 60
            color: "#C8C8C8"
            newText: globalRDSText
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            anchors.top: globalrdsNameLabel.bottom
            anchors.topMargin: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font.weight: Font.Light
            font.pixelSize: 22

            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
        }
    }

    PowerButton {
        id: powerButton
        width: 100
        height: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 135
        isDimmed: recordButton.isRecording
        onIsEnabledChanged: {
            if(scanning && !isEnabled)
            {
                skipScanCancel = true;
            }

            tunerModel.powerOn(isEnabled);

            if(isEnabled)
            {
                tunerModel.tuneToFreq(tunerScale.value.toFixed(1))
            }
        }
    }

    SequentialAnimation {
        id: shakeAnimation;
        NumberAnimation { id: sakeInAnimation; target: smallStationsListView; property: "contentX"; duration: 200; easing.type: Easing.OutQuad;}
        NumberAnimation { id: sakeOutAnimation; target: smallStationsListView; property: "contentX"; duration: 200; easing.type: Easing.InQuad;}
    }

    SeekButton {
        id: buttonBackward
        y: 463
        width: 100
        height: 100
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 135
        isForward: false
        dimmed: (scanning || !powerButton.isEnabled || recordButton.isRecording)
        enabled: !dimmed
        onClicked: {
            if(smallStationsListView.hideDetails)
            {
                var ind = stationsModel.nearestIndex(tunerScale.value, false)
                console.log("Nearest index for freq " + tunerScale.value + " " + ind)
                if(ind != -1)
                {
                    if(ind == smallStationsListView.currentIndex)
                    {
                        tunerScale.tuneToFreq(stationsModel.freqByIndex(ind));
                    }
                    else
                    {
                        smallStationsListView.currentIndex = ind;
                    }
                }
            }
            else
            {
                if(smallStationsListView.currentIndex > 0)
                {
                    smallStationsListView.currentIndex = smallStationsListView.currentIndex - 1
                }
                else
                {
                    sakeInAnimation.to = smallStationsListView.contentX - 100
                    sakeOutAnimation.to = smallStationsListView.contentX
                    shakeAnimation.start();
                }
            }
        }
        onLongTap: { tunerModel.scan(false); highlited = true;}
    }

    SeekButton {
        id: buttonForward
        width: 100
        height: 100
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 135
        isForward: true
        dimmed: (scanning || !powerButton.isEnabled || recordButton.isRecording)
        onClicked: {

            if(smallStationsListView.hideDetails)
            {
                var ind = stationsModel.nearestIndex(tunerScale.value, true)
                console.log("Nearest index for freq " + tunerScale.value + " " + ind)
                if(ind != -1)
                {
                    if(ind == smallStationsListView.currentIndex)
                    {
                        tunerScale.tuneToFreq(stationsModel.freqByIndex(ind));
                    }
                    else
                    {
                        smallStationsListView.currentIndex = ind;
                    }
                }
            }
            else
            {
                if(smallStationsListView.currentIndex < smallStationsListView.count - 1)
                {
                    smallStationsListView.currentIndex = smallStationsListView.currentIndex + 1
                }
                else
                {
                    sakeInAnimation.to = smallStationsListView.contentX + 100
                    sakeOutAnimation.to = smallStationsListView.contentX
                    shakeAnimation.start();

                }
            }
        }
        enabled: !dimmed
        onLongTap: { tunerModel.scan(true); highlited = true;}
    }

}
