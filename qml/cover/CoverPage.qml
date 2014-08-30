import QtQuick 2.0
import Sailfish.Silica 1.0
import com.wayfarer.sirensong 1.0

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: "SirenSong"
    }

    CoverActionList {
        id: coverAction

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


