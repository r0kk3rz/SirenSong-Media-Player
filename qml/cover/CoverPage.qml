import QtQuick 2.0
import Sailfish.Silica 1.0
import com.wayfarer.sirensong 1.0

CoverBackground {

    Image {
        y: 20
        anchors.horizontalCenter: parent.horizontalCenter
        source: "SirenSong-Media-Player.png"
    }



    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: appTitle
            anchors.horizontalCenter: parent.horizontalCenter
            text: "SirenSong"
            color: Theme.secondaryColor
            anchors.bottomMargin: 20
        }

        Label {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            text: SirenSong.title
            font.pixelSize: Theme.fontSizeSmall
        }
        Label {
            id: artist
            anchors.horizontalCenter: parent.horizontalCenter
            text: SirenSong.artist
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }
    }

    CoverActionList {
        id: coverAction
        enabled: SirenSong.playbackStatus != 0

        CoverAction {
            iconSource: SirenSong.playbackStatus === 1 ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: SirenSong.playbackStatus === 1 ? SirenSong.pause() : SirenSong.play()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: SirenSong.next()
        }
    }
}


