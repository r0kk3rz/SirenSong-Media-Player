import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import harbour.sirensong 1.0
import "functions.js" as UIFunctions

Column {
    id: root

    property Item _currActiveGroup
    property Item _currActiveAlbum

    //Top Level Menu
    Repeater {
        model: queryModel

        Item {
            id: artistItem
            width: parent.width
            height: Theme.itemSizeSmall + ((groupResultsList != null) && (active == true) ? groupResultsList.height : 0)

            property bool active
            property Item groupResultsList
            property alias pressed: mouseArea.pressed
            property alias containsMouse: mouseArea.containsMouse
            property bool highlighted: pressed && containsMouse || artistItem.active
            property int baseHeight: Theme.itemSizeSmall

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: activate(artistItem)

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: Theme.highlightBackgroundColor
                    opacity: highlighted ? 0.1 : 0.3
                }

                Item{
                    height: Theme.itemSizeSmall
                    x:30
                    Label { text: artistName; anchors.verticalCenter: parent.verticalCenter }
                }
          }

            function activate(artistItem)
            {
                if(!artistItem.active)
                {
                    if(root._currActiveGroup != null)
                    {
                        deactivate(root._currActiveGroup);
                    }

                    groupResultsList = albumListComponent.createObject(artistItem);
                    groupResultsList.open(artistName);
                    artistItem.active = true;

                    root._currActiveGroup = artistItem;
                }
                else
                {
                    deactivate(artistItem)
                }
            }

            function deactivate(artistItem)
            {
                artistItem.active = false;
                artistItem.groupResultsList.close();
            }
        }
    }

    //Empty List
    ListModel {
        id: emptyModel
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
        query: "SELECT ?artistName ?albumArtist " +
               "WHERE { ?album a nmm:MusicAlbum . " +
               "?album nmm:albumArtist ?albumArtist . " +
               "?albumArtist nmm:artistName ?artistName " +
               "} GROUP BY ?artistName ORDER BY ASC(?artistName) "
    }

    Component {
        id: albumListComponent

        Column {
            id: albumListView
            height: (albumListQueryModel.count * Theme.itemSizeSmall) + submenuHeight

            x: -parent.x
            y: Theme.itemSizeSmall
            width: root.width

            property Item songListItem
            property int submenuHeight: (songListItem != null) && (songListItem.active == true) ? songListItem.implicitHeight : 0

            Repeater {
                id: albumRepeater
                model: albumListQueryModel

                Item {
                id: albumItem
                height: Theme.itemSizeSmall + ((songListItem != null) && (active == true) ? songListItem.implicitHeight : 0)
                width: albumListView.width
                property bool active: false

                ListItem {
                width: parent.width
                height: Theme.itemSizeSmall
                onClicked: activate(parent)
                Label { x:60; text: albumTitle; anchors.verticalCenter: parent.verticalCenter }
                }

                function activate(albumItem)
                {
                    if(!albumItem.active)
                    {
                        if(root._currActiveAlbum != null)
                        {
                            deactivate(root._currActiveAlbum)
                        }

                        songListItem = songListComponent.createObject(albumItem);
                        albumItem.active = true
                        songListItem.open(albumTitle)

                        root._currActiveAlbum = albumItem
                    }
                    else
                    {
                        deactivate(albumItem)
                    }
                }

                function deactivate(albumItem)
                {
                    albumItem.active = false;

                    if(albumListView.songListItem.active == true)
                        albumListView.songListItem.close();
                }
            }
            }

            function open(artistName)
            {
                albumListQueryModel.filter(artistName)
                albumRepeater.model = albumListQueryModel
                state = "active";
            }

            function close()
            {
                state = "";
                albumRepeater.model = emptyModel;
            }

            SparqlListModel {
                id: albumListQueryModel
                connection: SparqlConnection {
                    id: sparqlConnection
                    driver: "QTRACKER_DIRECT"
                }

                function filter(filterText)
                {
                    albumListQueryModel.query = "SELECT ?albumTitle " + "WHERE { ?album a nmm:MusicAlbum . " +
                            "?album nmm:albumArtist ?albumArtist . " +
                            "?album nmm:albumTitle ?albumTitle . " +
                            "?albumArtist nmm:artistName ?artistName " +
                            "FILTER (?artistName =  '"+ filterText +"') "+
                            "} "

                    albumListQueryModel.reload()
                }
            }
        }
    }

    Component {
        id: songListComponent

        ColumnView {
            id: songListView
            itemHeight: Theme.itemSizeSmall
            model: songListQueryModel
            x: -parent.x
            y: Theme.itemSizeSmall
            width: root.width

            property bool active: false

            Behavior on implicitHeight
            {
                NumberAnimation { duration: 200 }
            }

            delegate: ListItem {
                width: parent.width
                id: songList

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

            function open(albumTitle)
            {
                active = true;
                songListQueryModel.filter(albumTitle)
                songListView.model = songListQueryModel
            }

            function close()
            {
                songListView.model = emptyModel
                active = false;
            }

            //Empty List
            ListModel {
                id: emptyModel
            }

            SparqlListModel {
                id: songListQueryModel
                query: ""
                connection: SparqlConnection {
                    id: sparqlConnection
                    driver: "QTRACKER_DIRECT"
                }

                function filter(filterText)
                {
                    songListQueryModel.query = "SELECT ?title ?artist ?url ?length ?filename " +
                            "WHERE { ?song a nmm:MusicPiece . " +
                            "?song nie:url ?url . " +
                            "OPTIONAL { ?song nie:title ?title } " +
                            "?song nfo:duration ?length . " +
                            "?song nfo:fileName ?filename . " +
                            "?song nmm:trackNumber ?tracknumber . "+
                            "?song nmm:musicAlbum ?album . " +
                            "?album nmm:albumArtist ?albumArtist . " +
                            "?album nmm:albumTitle ?albumTitle . " +
                            "?albumArtist nmm:artistName ?artist " +
                            "FILTER (?albumTitle =  '"+ filterText +"') "+
                            "} " +
                            "ORDER BY ASC(?tracknumber)"
                }
            }
        }
    }
}
