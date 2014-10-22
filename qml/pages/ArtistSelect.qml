import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import com.wayfarer.sirensong 1.0

Column {
    id: root

    property Item _currActiveGroup
    property Item _currResultsList

    //Top Level Menu
    Repeater {
        model: queryModel

        Item {
            id: artistItem
            width: parent.width
            height: Theme.itemSizeSmall

            property bool active
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

                    _currResultsList = albumListComponent.createObject(artistItem);
                    _currResultsList.open(artistName);
                    artistItem.active = true;
                    artistItem.height = artistItem.height + 200;
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
                artistItem.height = artistItem.baseHeight;
                _currResultsList.close();
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

        ColumnView {
            id: albumListView
            itemHeight: Theme.itemSizeSmall
            model: albumListQueryModel

            x: -parent.x
            y: Theme.itemSizeSmall
            width: root.width

            delegate: ListItem {
                width: parent.width
                height: Theme.itemSizeSmall
                Row { Label { text: albumTitle } }
                }

            states: State {
                name: "active"
                PropertyChanges {
                    target: albumListView
                    height: albumListView.implicitHeight
                }
            }

            function open(artistName)
            {
                albumListQueryModel.filter(artistName)
                model = albumListQueryModel
                state = "active";
            }

            function close()
            {
                state = "";
                model = emptyModel;
            }

            SparqlListModel {
                id: albumListQueryModel
                connection: SparqlConnection {
                    id: sparqlConnection
                    driver: "QTRACKER_DIRECT"
                }

                query: "SELECT ?albumTitle " + "WHERE { ?album a nmm:MusicAlbum . " +
                       "?album nmm:albumArtist ?albumArtist . " +
                       "?album nmm:albumTitle ?albumTitle . " +
                       "?albumArtist nmm:artistName ?artistName " +
                       "FILTER (?artistName =  '"+ "Amon Amarth" +"') "+
                       "} "

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
}
