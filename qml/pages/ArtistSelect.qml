import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import com.wayfarer.sirensong 1.0

Column {
    id: root

    property Item _currActiveGroup

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
        query: "SELECT ?artistName " + "WHERE { ?album a nmm:MusicAlbum . " +
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
                width: parent.width
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
                        songListItem = songListComponent.createObject(albumItem);
                        albumItem.active = true
                        songListItem.open(albumTitle)
                    }
                    else
                    {
                        albumItem.active = false
                        songListItem.close()
                    }
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

            delegate: ListItem {
                            width: parent.width
                            height: Theme.itemSizeSmall
                            onClicked: SirenSong.play(url)

                            Label { x:90; text: songtitle; anchors.verticalCenter: parent.verticalCenter }
                            }

            function open(albumTitle)
            {
                active = true;
                songListQueryModel.filter(albumTitle)
            }

            function close()
            {
                active = false;
            }

            SparqlListModel {
                id: songListQueryModel
                connection: SparqlConnection {
                    id: sparqlConnection
                    driver: "QTRACKER_DIRECT"
                }

                function filter(filterText)
                {
                    songListQueryModel.query = "SELECT ?songtitle ?url " +
                            "WHERE { ?song a nmm:MusicPiece . " +
                            "?song nie:url ?url . " +
                            "?song nie:title ?songtitle . " +
                            "?song nmm:trackNumber ?tracknumber . "+
                            "?song nmm:musicAlbum ?album . " +
                            "?album nmm:albumArtist ?albumArtist . " +
                            "?album nmm:albumTitle ?albumTitle . " +
                            "?albumArtist nmm:artistName ?artistName " +
                            "FILTER (?albumTitle =  '"+ filterText +"') "+
                            "} "
                }
            }
        }
    }
}
