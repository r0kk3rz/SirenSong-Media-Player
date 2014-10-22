import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import com.wayfarer.sirensong 1.0
import "functions.js" as UIFunctions

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

            Row {
                spacing: 20
                x: 10

                Label {
                    text: UIFunctions.durationString(length)
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

