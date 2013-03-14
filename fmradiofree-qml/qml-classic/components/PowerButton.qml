import QtQuick 1.1
//import QtMobility.feedback 1.1

Item {
    id: container
    width: 50
    height: 50

    signal clicked
    property bool isEnabled: false
    property bool isDimmed: false

    opacity: isDimmed ? 0.7 : 1

    Behavior on opacity {NumberAnimation {duration: 200} }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !isDimmed
        onClicked: {
            container.clicked();
            isEnabled = !isEnabled;
            //tapVibro.start();
        }
    }

    Image {
        id: image
        smooth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 50
        height: 50
        source: isEnabled || mouseArea.pressed ? "image://theme/icon-s-music-video-pause-accent" : "image://theme/icon-s-music-video-play-accent"
    }

//    HapticsEffect {
//        id: tapVibro
//        attackIntensity: 0.5
//        attackTime: 30
//        intensity: 0.7
//        duration: 50
//        fadeTime: 30
//        fadeIntensity: 0.5
//    }
}
