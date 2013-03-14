// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root
    width: 854
    height: 480

    //anchors.fill: parent
    property string titleText: qsTr("fm-tr-classic-app-title") //"FM Radio"
    property string versionText: qsTr("fm-tr-classic-app-version").replace("%1",tunerModel.getVersion()) //"version 1.0.0"
    property string localizedText: qsTr("fm-tr-classic-about-text")
    property string bodyText:
        "<html>
        <style>
        a
        {
                font-weight: bold;
                color: #FFFFFF;
                text-decoration: underline;
        }

        </style>
        <body>" + localizedText + "</body> </html>"

//        <p align='left'>Copyright &copy; 2012 <a href=\"mailto:andy.tolst@gmail.com\">Andrey Kozhanov</a></p>

//        <p align='left'>Application backend is based on fmrxd daemon
//        Copyright &copy; 2011 <a href=\"mailto:maemo@javispedro.com\">Javier S. Pedro</a></p>

//        <p align='left'>This application includes some parts distributed under GPL license.<br>
//        For more details refer to <a href='http:\/\/fm-radio.mobi/do?action=about&version=1.1.4'>fm-radio.mobi</a></p>


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
        height: header.height + 15 + mainText.height + 40 + closeButton.height + versionText.height + 15 + rateButton.height + 20

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
            id: versionText
            text: root.versionText
            font.pixelSize: 22
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            anchors.top: header.bottom
            anchors.topMargin: 15

            onLinkActivated: {
                    Qt.openUrlExternally(link);
            }
        }

        Label {
            id: hiddenText
            text: qsTr("fm-tr-classic-rate")
            visible: false
            font.pixelSize: rateButton.font.pixelSize
            font.weight: rateButton.font.weight
            font.capitalization: rateButton.font.capitalization
        }

        Button {
            id: rateButton
            iconSource: "star.png"
            text: qsTr("fm-tr-classic-rate") //"Rate!"
            width: 150 + hiddenText.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: versionText.bottom
            anchors.topMargin: 20

            onClicked: {
                Qt.openUrlExternally("http://store.ovi.com/content/262564")
            }
        }

        Label {
            id: mainText
            text: root.bodyText
            font.pixelSize: 22
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            anchors.top: rateButton.bottom
            anchors.topMargin: 40

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
