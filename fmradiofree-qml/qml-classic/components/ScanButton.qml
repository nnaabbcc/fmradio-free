// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: scanButton
    height: 60
    width: scanText.width + scanImage.width + 10
    enabled: true
    property bool manualScan: false

    signal clicked
    function startAnimation()
    {
        rotationAnimation.start();
        scanText.text = qsTr("fm-tr-classic-scanning") //"Scanning..."
    }

    function stopAnimation()
    {
        rotationAnimation.stop();
        stopScanAnimation.start();
    }

    function startManualScan()
    {
        manualScan = true
        rotationAnimation.start();
        scanText.text = qsTr("fm-tr-classic-searching") //"Searching..."
    }

    function stopManualScan()
    {
        manualScan = false
        rotationAnimation.stop();
        stopScanAnimation.start();
    }

    SequentialAnimation {
        id: stopScanAnimation
        PauseAnimation { duration: 300 }
        PropertyAction { target: scanText; property: "text"; value: qsTr("fm-tr-classic-scan") /*"Scan" */ }
    }

    Label {
        id: scanText
        font.weight: Font.Bold
        font.pixelSize: 40
        text: qsTr("fm-tr-classic-scan")
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }

    Image
    {
        id: scanImage
        width: 40
        height: 40
        anchors.right: scanText.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        source: "image://theme/icon-m-toolbar-refresh-white"
        smooth: true;

        RotationAnimation on rotation {
            id: rotationAnimation
            running: false
            loops: Animation.Infinite
            duration: 1000
            from: 360
            to: 0
        }
    }

    MouseArea {
        id: mousearea1
        anchors.fill: parent
        anchors.topMargin: -20
        anchors.bottomMargin: -20
        enabled: scanButton.enabled
        onClicked:
        {
            scanButton.clicked();
        }
    }
}
