import QtQuick 1.1
//import QtMobility.feedback 1.1
import com.nokia.meego 1.0

Item {
    id: container
    width: 100
    height: 50

    signal clicked
    property bool isRecording: false
    property bool isEnabled: false
    property int elapsed: 0
    property string elapsedString: timeLabel.text
    function startRecord() {
        elapsed = 0
        isRecording = true
        flashTimer.start()
    }

    opacity: isEnabled ? 1 : 0.4

    Behavior on opacity {NumberAnimation {duration: 200}}

    function stopRecord() {
        isRecording = false
        flashTimer.stop()
        image.opacity = 1;
    }

    MouseArea {
        id: mouseArea
        z: 1
        enabled: container.isEnabled
        anchors.fill: parent
        onClicked: {
            container.clicked();
        }
    }
    // "icon-m-camera-ongoing-recording"

    Timer {
        id: flashTimer
        interval: 500
        repeat: true

        property bool odd: false

        onTriggered:
        {
            image.opacity = (image.opacity == 1) ? 0.3 : 1;
            odd = !odd
            if(odd)
            {
                elapsed = elapsed + 1;
            }
        }
    }

    Image {
        id: image
        smooth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: isRecording ? 19 : 23;
        width: 30
        height: 30
        source: "record-btn.png"
        Behavior on opacity { NumberAnimation { duration: 200 } }
        Behavior on anchors.topMargin {NumberAnimation {duration: 200}}
    }

    Label {
        id: timeLabel
        text: getTime()
        verticalAlignment: Text.AlignBottom
        font.pixelSize: 16
        //font.weight: Font.Light
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        function getTime()
        {
            var minutes = Math.floor(elapsed/60);
            var seconds = elapsed - minutes*60;
            return "" + ((minutes < 10) ? "0" + minutes : minutes) + ":" + ((seconds < 10) ? "0" + seconds : seconds);
        }

        opacity: isRecording ? 1 : 0;
        Behavior on opacity {NumberAnimation {duration: 200}}
    }
}
