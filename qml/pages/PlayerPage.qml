import QtQuick 2.0
import com.wayfarer.sirensong 1.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page {
    Drawer {

        open: true
        anchors.fill: parent
        dock: Dock.Bottom

        foreground: SilicaListView {
            id: playlistView
            anchors.fill: parent
            highlightFollowsCurrentItem: true;
            header: PageHeader { title: qsTr("Play Queue") }
            currentIndex: playlistView.model.currentIndex

            VerticalScrollDecorator {}

            PullDownMenu {

               MenuItem {
                 text:SirenSong.loopStatus ? "Repeat: On" : "Repeat: Off"
                 onClicked: SirenSong.toggleLoop()
               }

                MenuItem {
                    text: "Clear Play Queue"
                    onClicked: SirenSong.clearPlaylist()
                }
            }

            model: SirenSong.playlistModel

            delegate: ListItem {
                id: playlistItem
                width: parent.width
                focus: index == playlistView.model.currentIndex ? true : false

                function durationString(length) {
                    var iMinutes = Math.floor(length / 60)
                    var iSeconds = (length % 60)

                    if (iMinutes.toString().length == 1)
                        iMinutes = ("0" + iMinutes)

                    if (iSeconds.toString().length == 1)
                        iSeconds = ("0" + iSeconds)

                    return iMinutes + ":" + iSeconds
                }

                onClicked: SirenSong.playIndex(index)

                Row {
                    spacing: 20
                    x: 10

                    Label {
                        text: durationString(duration)
                        height: Theme.itemSizeHuge
                        font.pixelSize: Theme.fontSizeExtraLarge
                        color: playlistItem.focus ? Theme.highlightColor : Theme.secondaryColor
                    }

                    Column {
                        Label {
                            text: title
                            font.pixelSize: Theme.fontSizeMedium
                            color: playlistItem.focus ? Theme.highlightColor : Theme.primaryColor
                        }
                        Label {
                            text: artist
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: playlistItem.focus ? Theme.highlightColor : Theme.secondaryColor
                        }
                    }
                }
            }
        }

        backgroundSize: 300

        background: SilicaFlickable {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: Theme.highlightBackgroundColor
                opacity: 0.3
            }

            Column {
                width: parent.width
                y: 20

                Label {
                    text: SirenSong.title
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    text: SirenSong.artist
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
                        width: parent.width / 3
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    //IconButton {
                    //    id: stop
                    //    icon.source: "image://theme/icon-l-clear"
                    //    onClicked: SirenSong.stop()
                    //    width: parent.width / 4
                    //    anchors.verticalCenter: parent.verticalCenter
                    //}

                    IconButton {
                        id: play
                        icon.source: SirenSong.playbackStatus === 1 ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                        onClicked: SirenSong.playbackStatus === 1 ? SirenSong.pause(
                                                                        ) : SirenSong.play()
                        width: parent.width / 3
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    IconButton {
                        id: next
                        icon.source: "image://theme/icon-m-next"
                        onClicked: SirenSong.next()
                        width: parent.width / 3
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
