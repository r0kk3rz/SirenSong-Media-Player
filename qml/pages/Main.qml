import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import com.wayfarer.sirensong 1.0
import Sailfish.Media 1.0
import org.nemomobile.policy 1.0

Page {
    id: libraryPage
    property bool playerMenuEnabled: false

    Connections {
        target: SirenSong
        onPlaybackStatusChanged: {

            if (SirenSong.playbackStatus === 1) {
                if (libraryPage.playerMenuEnabled == false) {
                    pageStack.pushAttached(Qt.resolvedUrl("PlayerPage.qml"))
                    pageStack.navigateForward(PageStackAction.Animated)
                    libraryPage.playerMenuEnabled = true
                }
            }

            if (SirenSong.playbackStatus === 0) {
                if (libraryPage.playerMenuEnabled == true) {
                    pageStack.popAttached(libraryPage, PageStackAction.Animated)
                    libraryPage.playerMenuEnabled = false
                }
            }
        }
    }

    MediaKey {
        enabled: true
        key: Qt.Key_MediaTogglePlayPause
        onPressed: SirenSong.playbackStatus === 1 ? SirenSong.pause() : SirenSong.play()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaPlay
        onPressed: SirenSong.play()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaPause
        onPressed: SirenSong.pause()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaStop
        onPressed: SirenSong.stop()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaNext
        onPressed: SirenSong.next()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaPrevious
        onPressed: SirenSong.previous()
    }

    Permissions {
        enabled: true
        applicationClass: "player"

        Resource {
            id: keysResource
            type: Resource.HeadsetButtons
            optional: true
        }
    }

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

    SilicaFlickable {
        width: parent.width
        height: parent.height

        VerticalScrollDecorator {}
        contentHeight: Math.max(1, alphaMenu.height)

        Column {
            width: parent.width

            PageHeader {
                title: qsTr("Song Library")
            }

            AlphaMenu {
                id: alphaMenu
                dataSource: queryModel
                width: parent.width
                listDelegate: ListItem {
                    width: parent.width
                    id: songList

                    menu: ContextMenu {
                        MenuItem {
                            text: "Add to Play Queue"
                            onClicked: SirenSong.addToPlaylist(url)
                        }
                    }

                    onClicked: {
                        SirenSong.play(url)
                        if (libraryPage.forwardNavigation) {
                            pageStack.navigateForward(PageStackAction.Animated)
                        }
                    }

                    function durationString(length) {
                        var iMinutes = Math.floor(length / 60)
                        var iSeconds = (length % 60)

                        if (iMinutes.toString().length == 1)
                            iMinutes = ("0" + iMinutes)

                        if (iSeconds.toString().length == 1)
                            iSeconds = ("0" + iSeconds)

                        return iMinutes + ":" + iSeconds
                    }

                    Row {
                        spacing: 20
                        x: 10

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
    }
}
