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
            property string selectedArtist

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
                    artistItem.selectedArtist = artistName;

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
                artistItem.selectedArtist = "";
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

        TieredMenu {
            width: root.width
            subListComponent: songListComponent
            activeParentItem: root._currActiveAlbum
            menuListQueryModel: SparqlListModel {
                id: albumListQueryModel
                connection: SparqlConnection {
                    driver: "QTRACKER_DIRECT"
                }

                function filter(filterText)
                {
                    albumListQueryModel.query = "SELECT ?menuText " + "WHERE { ?album a nmm:MusicAlbum . " +
                            "?album nmm:albumArtist ?albumArtist . " +
                            "?album nmm:albumTitle ?menuText. " +
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

            delegate: SongItem {
                width: parent.width
                id: songList
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
                            "?song nmm:performer ?aName . "+
                            "?aName nmm:artistName ?artist "+
                            "FILTER (?albumTitle =  '"+ filterText +"' &&
                                    ?artist = '"+ _currActiveGroup.selectedArtist +"') "+
                            "} " +
                            "GROUP BY ?song ORDER BY ASC(?tracknumber)"
                }
            }
        }
    }
}
