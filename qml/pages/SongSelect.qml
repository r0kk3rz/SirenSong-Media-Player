import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import com.wayfarer.sirensong 1.0

    AlphaMenu {
        id: alphaMenu
        dataSource: SparqlListModel {
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

