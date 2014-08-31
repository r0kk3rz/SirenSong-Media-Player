import QtQuick 2.0
import com.wayfarer.sirensong 1.0
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent

        Column {
            width:parent.width

            Label {
                text: SirenSong.title;
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: SirenSong.artist;
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Slider {
                id: progressSlider
                value: Math.floor(SirenSong.position / 1000)
                minimumValue: 0
                maximumValue: Math.floor(SirenSong.duration / 1000)
                enabled: false
                width: parent.width
                handleVisible: true
            }

        Row {
            width: parent.width

            IconButton {
                id: previous
                icon.source: "image://theme/icon-m-previous"
                onClicked: SirenSong.previous()
                width: parent.width / 4
                anchors.verticalCenter: parent.verticalCenter
            }

            IconButton {
                id: stop
                icon.source: "image://theme/icon-l-clear"
                onClicked: SirenSong.stop()
                width: parent.width / 4
                anchors.verticalCenter: parent.verticalCenter
            }

            IconButton {
                id: play
                icon.source: SirenSong.playbackStatus === 1 ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                onClicked: SirenSong.playbackStatus === 1 ? SirenSong.pause() : SirenSong.play()
                width: parent.width / 4
                anchors.verticalCenter: parent.verticalCenter
            }

            IconButton {
                id: next
                icon.source: "image://theme/icon-m-next"
                onClicked: SirenSong.next()
                width: parent.width / 4
                anchors.verticalCenter: parent.verticalCenter
            }
        }

    }
}
}
