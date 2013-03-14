// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: root
    width: 310
    height: 110
    property string text
    property string icon
    signal clicked

    Image {
        id: skinButton
        anchors.fill: parent

        smooth: true
        source: skinArea.pressed ? "settings-button-pressed.png" : "settings-button-normal.png"

        Item {
            id: item1
            height: root.height
            width: btnText.width + btnIcon.width
            anchors.centerIn: parent

            Text {
                id: btnText
                color: "#cccccc"
                text: root.text
                font.pointSize: 18
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }

            Image {
                id: btnIcon
                anchors.verticalCenter: btnText.verticalCenter
                anchors.rightMargin: 10
                anchors.right: btnText.left
                source: root.icon
            }
        }



        MouseArea {
            id: skinArea
            z: 1
            anchors.fill: parent
            onClicked: {
                root.clicked();
            }
        }
    }
}
