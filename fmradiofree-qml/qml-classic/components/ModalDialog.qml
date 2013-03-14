// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root
    width: 854
    height: 480

    //anchors.fill: parent
    property string titleText: "Title"
    property string bodyText: "Some long text text long text text long text text long text text long text text long text text long text text "
    property string buttonText: "OK"
    opacity: 0
    z: 20
    parent: rootWindow

    Behavior on opacity {NumberAnimation {duration: 500}}

    function open()
    {
        opacity = 1
    }

    function close()
    {
        opacity = 0
    }

    Rectangle {
        id: background;
        anchors.fill: parent
        color: "black"
        opacity: 0.8
        z: -1
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            close();
        }
    }

    Item{
        anchors.fill: parent
        rotation: -90

    Item {
        id: content
        anchors.centerIn: parent
        width: parent.height - 60
        height: header.height + 15 + mainText.height + 40 + closeButton.height

        Item {
            id: header
            width: parent.width
            height: title.height +delimeter.height + 10
            Label {
                id: title
                text: root.titleText
                font.pixelSize: 32
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
            }
            BorderImage {
                id: delimeter
                height: 2
                anchors.top: title.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: 15
                source: "image://theme/meegotouch-groupheader-inverted-background"
            }
        }

        Label {
            id: mainText
            text: root.bodyText
            font.pixelSize: 22
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            anchors.top: header.bottom
            anchors.topMargin: 15

            onLinkActivated: {
                    Qt.openUrlExternally(link);
            }
        }

        Button {
            id: closeButton
            text: root.buttonText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: mainText.bottom
            anchors.topMargin: 40

            onClicked: {
                close();
            }
        }
    }
    }

}
