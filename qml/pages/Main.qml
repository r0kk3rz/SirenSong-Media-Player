import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import com.wayfarer.sirensong 1.0

Page {

    SparqlListModel {
        id: queryModel
        property string filterProperty: 'title'

        // create a new SparqlConnection for the queryModel
        connection: SparqlConnection {
            id: sparqlConnection
            driver: "QTRACKER_DIRECT"
        }

        // This is the query for the model
        query: "SELECT ?title ?artist ?length ?album " + "WHERE { ?song a nmm:MusicPiece . "
               + "?song nie:title ?title . " + "?song nfo:duration ?length . "
               + "?song nie:url ?url ." + "?song nmm:performer ?aName . "
               + "?aName nmm:artistName ?artist . " + "?song nmm:musicAlbum ?malbum . "
               + "?malbum nmm:albumTitle ?album " + "} " + "LIMIT 100"
    }

    MediaPlayer {
        id: player
        onPositionChanged: console.log("position: " + position)
        onDurationChanged: console.log("duration: " + duration)
    }

    QMediaPlayer {
        id: qPlayer
    }

    Drawer {
        id: playerMenu
        anchors.fill: parent
        dock: Dock.Bottom
        open: player.playbackStatus >=1 ? true : false

        foreground: SilicaFlickable {
            width: parent ? parent.width : Screen.width
            height: parent ? parent.height : Screen.height
            VerticalScrollDecorator {
            }
            contentHeight: Math.max(1, alphaMenu.height)

            AlphaMenu {
                id: alphaMenu
                dataSource: queryModel
                listDelegate: BackgroundItem {
                    width: parent.width
                    id: songList
                    onClicked: player.play(url)

                    function durationString(length)
                    {
                        var iMinutes = Math.floor(length / 60)
                        var iSeconds = (length % 60)

                        if(iMinutes.toString().length == 1)
                            iMinutes = ("0" + iMinutes)

                        if(iSeconds.toString().length == 1)
                            iSeconds = ("0" + iSeconds)

                        return iMinutes + ":" + iSeconds
                    }

                    Row {
                        spacing: 20

                        Label {
                            text: durationString(length)
                            height: Theme.itemSizeHuge
                            font.pixelSize: Theme.fontSizeExtraLarge
                            color: Theme.secondaryColor
                        }

                        Column {
                            Label {
                                text: title
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.primaryColor
                            }
                            Label {
                                text: artist
                                font.pixelSize: Theme.fontSizeExtraSmall
                                color: Theme.secondaryColor
                            }
                        }
                    }
                }
            }
        }


        backgroundSize: 250
        background: SilicaListView {
            anchors.fill: parent

                Column {
                    width:parent.width


                    Label {
                        text: " "
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Label {
                        text: " "
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: Theme.secondaryColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Slider {
                        id: progressSlider
                        value: player.position
                        minimumValue: 0
                        maximumValue: player.duration
                        enabled: false
                        width: parent.width
                        handleVisible: true
                    }

                Row {
                    width: parent.width

                    IconButton {
                        id: previous
                        icon.source: "image://theme/icon-m-previous"
                        onClicked: player.previous()
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    IconButton {
                        id: pause
                        icon.source: "image://theme/icon-l-clear"
                        onClicked: player.stop()
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    IconButton {
                        id: play
                        icon.source: player.playbackStatus === 1 ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                        onClicked: player.playbackStatus === 1 ? player.pause() : player.play()
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    IconButton {
                        id: next
                        icon.source: "image://theme/icon-m-next"
                        onClicked: player.next()
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
