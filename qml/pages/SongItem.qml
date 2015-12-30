import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sirensong 1.0
import "functions.js" as UIFunctions

ListItem {
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Add to Play Queue")
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
                            text: title != null ? title : filename
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.primaryColor
                        }
                        Label {
                            text: artist != null ? artist : qsTr("Unknown Artist")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.secondaryColor
                        }
                    }
                }
            }
