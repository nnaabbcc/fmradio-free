// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: skinChooser
    width: 480
    height: 854
    signal closed
    property int skinId: 0

    Behavior on opacity {NumberAnimation {duration: 500;} }

    Component.onCompleted:
    {
        skinId = tunerModel.currentSkin();
        console.log("Skin chooser loaded, curr skin " + tunerModel.currentSkin());
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.8
    }
    MouseArea {
        z: -1
        anchors.fill: parent
        onClicked: {
            skinChooser.closed();
        }
    }

    Item {
        width: 350
        height: skin1.height + skin2.height + 35
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: skin1
            width: 320
            height: 350
            color: "#00000000"
            radius: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            border.width: 2
            border.color: tunerModel.currentSkin() == 1 ? "lime" : "#919191"
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: fade1
                anchors.fill: parent
                z: 2
                color: "black"
                opacity: 0
                radius: 10
                border.width: 2
                border.color: "black"
//                Behavior on opacity {NumberAnimation {duration: 200}}
            }

            Image {
                smooth: true
                id: skinImage1
                width: 300
                height: 300
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter

                source: "skin_classic.jpg"
                //asynchronous: true
            }

            Image {
                id: acceptImage1
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: skinImage1
                source: "image://theme/icon-l-installing"
                z: 2
                opacity: 0
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    skinId = 1;
                    skin2.border.color = "#919191"
                    skin1.border.color = "lime"
                    skinChooser.opacity = 0
                    if(tunerModel.currentSkin() != 1)
                    {
                        acceptImage1.opacity = 1
                        fade2.opacity = 0.8
                        tunerModel.changeSkin(1);
                    }
                    skinChooser.closed()
                }
            }

            Text {
                id: skin1Text
                color: "#ffffff"
                text: qsTr("fm-tr-skin-chooser-classic") //"Classic"
                font.pixelSize: 30
                anchors.top: skinImage1.bottom
                anchors.topMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }


        Rectangle {
            id: skin2
            width: 320
            height: 350
            color: "#00000000"
            radius: 10
            anchors.top: skin1.bottom
            anchors.topMargin: 15
            border.width: 2
            border.color: tunerModel.currentSkin() == 2 ? "lime" : "#919191"
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: fade2
                anchors.fill: parent
                z: 2
                color: "black"
                opacity: 0
                radius: 10
                border.width: 2
                border.color: "black"

//                Behavior on opacity {NumberAnimation {duration: 200}}
            }

            Image {
                id: skinImage2
                smooth: true
                width: 300
                height: 300
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter

                source: "skin_retro.jpg"
                //asynchronous: true
            }

            Image {
                id: acceptImage2
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: skinImage2
                source: "image://theme/icon-l-installing"
                z: 2
                opacity: 0
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    skinId = 2;
                    skin1.border.color = "#919191"
                    skin2.border.color = "lime"
                    skinChooser.opacity = 0
                    if(tunerModel.currentSkin() != 2)
                    {
                        acceptImage2.opacity = 1
                        fade1.opacity = 0.8
                        tunerModel.changeSkin(2);
                    }
                    skinChooser.closed()
                }
            }

            Text {
                id: skin2Text
                x: 100
                color: "#ffffff"
                text: qsTr("fm-tr-skin-chooser-retro") //"Retro"
                font.pixelSize: 30
                anchors.top: skinImage2.bottom
                anchors.topMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
