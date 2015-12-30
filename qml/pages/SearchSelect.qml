import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0

    Column {
        id: searchPage
        property bool keepSearchFieldFocus: true
        property string activeView: "list"
        property string searchString
        onSearchStringChanged: songListQueryModel.filter()

        SearchField {
                    id: searchField
                    width: parent.width

                    Binding {
                        target: searchPage
                        property: "searchString"
                        value: searchField.text.toLowerCase().trim()
                    }
                }


        Repeater
        {
            id: searchResults

            model: SparqlListModel {
                id: songListQueryModel
                query: ""
                connection: SparqlConnection {
                    id: sparqlConnection
                    driver: "QTRACKER_DIRECT"
                }

                function filter()
                {
                    songListQueryModel.query = "SELECT ?title ?artist ?url ?length ?filename " +
                            "WHERE { ?song a nmm:MusicPiece . " +
                            "?song nie:url ?url . " +
                            "OPTIONAL { ?song nie:title ?title } " +
                            "?song nfo:duration ?length . " +
                            "?song nfo:fileName ?filename . " +
                            "?song nmm:performer ?aName . "+
                            "?aName nmm:artistName ?artist . "+
                            "FILTER( regex(STR(?title), '"+searchString+ "', 'i')"+
                            "|| regex(STR(?artist), '"+searchString+"', 'i') )"+
                            "} LIMIT 50"
                }
            }

            delegate: SongItem { }
        }
    }
