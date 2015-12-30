import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0
import harbour.sirensong 1.0
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
        listDelegate: SongItem {
            width: parent.width
            id: songList
        }
    }

