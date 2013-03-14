import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.feedback 1.1

Page {
    id: listPage
    tools: tabTools

    orientationLock: PageOrientation.LockPortrait
    property int currentListIndex: -1
    onCurrentListIndexChanged: {
        stationsListView.currentIndex = currentListIndex;
    }

    Image {
        id: background
        source: "image://theme/meegotouch-video-background"
        anchors.fill: parent
        z: -1
    }
    // #CC09BA - accent color

    Label {
        color: "#C8C8C8"
        visible: stationsListView.count == 0
        text: qsTr("fm-tr-classic-no-stations") //"No stations"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 45
        height: 50
        width: parent.width

        anchors.centerIn: parent
    }

    Component {
        id: listDelegate

        Item {
            id: station

            width: stationsListView.width
            height: 83

            Label {
                id: titleLabel
                height: 30

                color: index == stationsListView.currentIndex ? "#CC09BA" : "white"

                anchors.bottom: subtitleLabel.top
                anchors.bottomMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: frequencyLabel.width + 10
                text: username

                font.weight: Font.Bold
                font.pixelSize: 26
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
            }

            Label {
                id: frequencyLabel
                width: 65
                anchors.bottom: titleLabel.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: 15
                text: freq.toFixed(1)

                font.weight: Font.Light
                font.pixelSize: 22
                color: index == stationsListView.currentIndex ? "#CC09BA" : "white"

                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight
            }

            Label {
                id: subtitleLabel
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10

                anchors.rightMargin: frequencyLabel.width + 10
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.leftMargin: 15

                height: 25
                text: ((rdsname.length > 0 && rdstext.length > 0) ? rdsname + " | " + rdstext : rdsname + rdstext)

                font.weight: Font.Light
                font.pixelSize: 22
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft

                color: index == stationsListView.currentIndex ? "#CC09BA" : "#C8C8C8"
                elide: Text.ElideRight
            }

            Rectangle {
                id: highlight
                color: "white"
                z: -1
                opacity: 0.2
                visible: listItemMouseArea.pressed

                anchors.fill: parent

                anchors.topMargin: 3
                anchors.bottomMargin: 3
            }

            MouseArea {
                id: listItemMouseArea
                anchors.fill: parent
                onClicked: {
                    stationsListView.currentIndex = index;
                }

                onPressAndHold: {
                    tapVibro.start();
                    stationsListView.clickedItem = index;
                    contextMenu.open();
                }
            }
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


    // The actual list
    ListView {
        id: stationsListView
        clip: true
        anchors.fill: parent
        model: stationsModel // stationsModelTemp
        delegate: listDelegate

        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0

        highlightFollowsCurrentItem: true

        header: listHeader
        property int clickedItem: -1

        cacheBuffer: 415
        interactive: count > 0
        onCurrentIndexChanged:
        {
            mainPage.currentListIndex = currentIndex;
            listPage.currentListIndex = currentIndex;
            console.log("Main list item changed " + currentIndex);
        }
    }

    Component {
        id: listHeader
        Item {
            width: stationsListView.width
            height: 75
            Label {
                text: qsTr("fm-tr-classic-station-list") //"Station List"
                font.weight: Font.Light
                font.pixelSize: 32
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                anchors.bottomMargin: 15
                verticalAlignment: Text.AlignVCenter
            }

            BorderImage {
                height: 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: 15
                source: "image://theme/meegotouch-groupheader-inverted-background"
            }
        }
    }

    ListModel {
        id: stationsModelTemp
        ListElement {username: "AAAAA"; rdsname: "rsdss"; freq: 100.9; rdstext: "aaa text text tga asd ads asd aw fsaa asdasd"}
        ListElement {username: "BBBBBBBBBB"; rdsname: "werwe"; freq: 90.9; rdstext: "lonsssg text text tga asd ads asd aw fsaa asdasd"}
        ListElement {username: "AACCCCCCAAA"; rdsname: "rsweewweew"; freq: 87.5; rdstext: "vvv text text tga asd ads asd aw fsaa asdasd"}
        ListElement {username: "DDDDDDDDD"; rdsname: "aaa"; freq: 108.0; rdstext: "hhh text text tga asd ads asd aw fsaa asdasd"}
    }

ToolBarLayout {
    id: tabTools

    ToolIcon { iconId: "toolbar-back"; onClicked: { contextMenu.close(); myMenu.close(); pageStack.pop(); }  }
//    ToolIcon { iconId: "toolbar-edit"; enabled: (stationsListView.currentIndex != -1); onClicked: {
//            addSheet.name = stationsModel.nameByIndex(stationsListView.currentIndex);
//            addSheet.freq = stationsModel.freqByIndex(stationsListView.currentIndex).toFixed(1);
//            addSheet.open();
//        }
//    }
//    ToolIcon { iconId: "toolbar-delete"; onClicked: { stationsModel.deleteStation(stationsListView.currentIndex) }  }
    ToolIcon { iconId: "toolbar-view-menu" ; onClicked: {
            contextMenu.close();

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
        MenuItem { text: qsTr("fm-tr-classic-delete-all") /*"Delete all"*/; onClicked: { stationsModel.deleteAll(); } }
    }
}

Menu {
    id: contextMenu
    smooth: true
    visualParent: pageStack

    MenuLayout {
        MenuItem { text: qsTr("fm-tr-classic-edit") /*"Edit"*/; onClicked: {
                if(stationsListView.clickedItem == currentListIndex)
                {
                    addSheet.useCachedRds = false;
                }
                else
                {
                    addSheet.useCachedRds = true;
                    addSheet.cachedRds = stationsModel.rdsByIndex(stationsListView.clickedItem)
                }

                addSheet.name = stationsModel.nameByIndex(stationsListView.clickedItem);
                addSheet.freq = stationsModel.freqByIndex(stationsListView.clickedItem).toFixed(1);
                addSheet.open();
            }
        }
        MenuItem { text: qsTr("fm-tr-classic-delete") /*"Delete"*/; onClicked: { stationsModel.deleteStation(stationsListView.clickedItem); } }
    }
}

}
