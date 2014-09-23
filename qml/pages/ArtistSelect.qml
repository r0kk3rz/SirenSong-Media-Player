import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import com.wayfarer.sirensong 1.0

Column {

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

                Label { x: 30; text: artistName; anchors.verticalCenter: parent.verticalCenter }
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
            model: emptyModel

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
}
