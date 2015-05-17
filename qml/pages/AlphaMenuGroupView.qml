import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0

Grid {
    id: root

    property int requiredProperty
    property Component delegate
    property int heightAnimationEasing: Easing.InOutQuad

    property real rowWidth: width / columns
    property real rowHeight: rowWidth
    property int rows: Math.ceil(groupModel.count / columns)

    property Item _currActiveGroup
    property Item _currentResultsList
    property Item _alternateResultsList

    property SparqlListModel dataModel

    signal activated(real viewSectionY, real newListHeight, real newViewHeight, real heightAnimationDuration)
    signal deactivated(real heightAnimationDuration)

    columns: Math.floor(width / Theme.itemSizeMedium)

    function _groupAtIndex(index) {
        return groupsRepeater.itemAt(index)
    }

    function _lastIndexInRow(index) {
        var lastIndexInRow = ((Math.floor(index / columns) + 1) * root.columns) - 1
        var maxIndex = groupsRepeater.count - 1
        return lastIndexInRow > maxIndex ? maxIndex : lastIndexInRow
    }

    function _getNextResultsList(parent) {
        if (_currentResultsList === null) {
            _currentResultsList = groupResultsListComponent.createObject(parent)
        } else if (_currentResultsList.parent === parent) {
            return _currentResultsList
        }

        if (_currentResultsList.active
                || (_alternateResultsList !== null
                    && _alternateResultsList.parent === parent)) {
            if (_alternateResultsList === null) {
                _alternateResultsList = _currentResultsList
                _currentResultsList = groupResultsListComponent.createObject(
                            parent)
            } else {
                var item = _alternateResultsList
                _alternateResultsList = _currentResultsList
                _currentResultsList = item
            }
        }

        if (_currentResultsList.parent !== null
                && _currentResultsList.parent !== parent)
            _currentResultsList.parent.groupResultsList = null
        _currentResultsList.parent = parent
        parent.groupResultsList = _currentResultsList
        return _currentResultsList
    }

    function _listForIndex(index) {
        var lastItemInRow = _groupAtIndex(_lastIndexInRow(index))
        if (_currentResultsList.parent === lastItemInRow)
            return _currentResultsList
        else if (_alternateResultsList.parent === lastItemInRow)
            return _alternateResultsList
        return null
    }

    function _openGroupList(name, index) {
        var list = _getNextResultsList(_groupAtIndex(_lastIndexInRow(index)))
        list.groupIndex = index

        list.open(name, index)
        return list.heightAnimationDuration
    }

    function _closeGroupList(index) {
        var list = _listForIndex(index)
        if (list) {
            list.close()
        }
    }

    function _groupListHeight(index) {
        var list = _listForIndex(index)

        if (list) {
            return list.implicitHeight
        }
        return 0
    }

    function _groupListOpenAnimationDuration(index, listCount) {
        var maxListItemsOnScreen = screen.height / Theme.itemSizeSmall
        if (listCount < maxListItemsOnScreen) {
            var minDuration = 150
            var maxDuration = 1500
            return minDuration + ((maxDuration - minDuration) * (listCount / maxListItemsOnScreen))
        }
        // use default animation duration
        return 1500
    }

    function _activate(group) {
        if ((_currentResultsList && _currentResultsList.animating)
                || (_alternateResultsList && _alternateResultsList.animating)) {
            // Wait til the previous animation completes before activating another
            return
        }
        if (group.active) {
            var list = _listForIndex(group.groupIndex)
            if (list) {
                deactivated(list.heightAnimationDuration)
            }
            _currActiveGroup = null
        } else if (group.hasEntries) {

            var heightAnimationDuration = _openGroupList(group.name,
                                                         group.groupIndex)
            if (_alternateResultsList !== null
                    && _alternateResultsList.active) {
                // the currently open list must close at the same rate as the new open list
                _alternateResultsList.heightAnimationDuration = heightAnimationDuration
            }
            _currActiveGroup = group

            var listHeight = _groupListHeight(group.groupIndex)

            activated((Math.floor(
                           group.groupIndex / columns) + 1) * group.baseHeight,
                      listHeight, (group.baseHeight * rows) + listHeight,
                      heightAnimationDuration)
        }
    }

    function _deactivate(group) {
        if (!group.active) {
            if ((_currActiveGroup == null) || Math.floor(
                        _currActiveGroup.groupIndex / columns) !== Math.floor(
                        group.groupIndex / columns)) {
                _closeGroupList(group.groupIndex)
            }
        }
    }

    onColumnsChanged: {
        if (_currActiveGroup !== null) {
            var oldLastItem = _currentResultsList.parent
            var newLastItem = _groupAtIndex(_lastIndexInRow(
                                                _currActiveGroup.groupIndex))
            if (oldLastItem !== newLastItem) {
                _currentResultsList.parent = newLastItem
                newLastItem.groupResultsList = _currentResultsList
                if (oldLastItem !== null)
                    oldLastItem.groupResultsList = null
            }
        }
    }

    //Empty List
    ListModel {
        id: emptyModel
    }

    //List to iterate over and build out top menu
    ListModel {
        id: groupModel

        ListElement { name: "A"; filter: "A"; entryCount: 0 }
        ListElement { name: "B"; filter: "B"; entryCount: 0 }
        ListElement { name: "C"; filter: "C"; entryCount: 0 }
        ListElement { name: "D"; filter: "D"; entryCount: 0 }
        ListElement { name: "E"; filter: "E"; entryCount: 0 }
        ListElement { name: "F"; filter: "F"; entryCount: 0 }
        ListElement { name: "G"; filter: "G"; entryCount: 0 }
        ListElement { name: "H"; filter: "H"; entryCount: 0 }
        ListElement { name: "I"; filter: "I"; entryCount: 0 }
        ListElement { name: "J"; filter: "J"; entryCount: 0 }
        ListElement { name: "K"; filter: "K"; entryCount: 0 }
        ListElement { name: "L"; filter: "L"; entryCount: 0 }
        ListElement { name: "M"; filter: "M"; entryCount: 0 }
        ListElement { name: "N"; filter: "N"; entryCount: 0 }
        ListElement { name: "O"; filter: "O"; entryCount: 0 }
        ListElement { name: "P"; filter: "P"; entryCount: 0 }
        ListElement { name: "Q"; filter: "Q"; entryCount: 0 }
        ListElement { name: "R"; filter: "R"; entryCount: 0 }
        ListElement { name: "S"; filter: "S"; entryCount: 0 }
        ListElement { name: "T"; filter: "T"; entryCount: 0 }
        ListElement { name: "U"; filter: "U"; entryCount: 0 }
        ListElement { name: "V"; filter: "V"; entryCount: 0 }
        ListElement { name: "W"; filter: "W"; entryCount: 0 }
        ListElement { name: "X"; filter: "X"; entryCount: 0 }
        ListElement { name: "Y"; filter: "Y"; entryCount: 0 }
        ListElement { name: "Z"; filter: "Z"; entryCount: 0 }
        ListElement { name: "#"; filter: "[^a-z]"; entryCount: 0 }

        function countItems()
        {
                for(var j=0; (groupModel.count - 1 ) >= j; j++)
                {
                    var filter = groupModel.get(j).filter

                    var result
                    result = sparqlConnection.ask("ASK { "+
                                                  "?song a nmm:MusicPiece . "+
                                                  "?song nie:title ?title "+
                                                  "FILTER regex(?title, '^"+filter+ "', 'i') "+
                                          "} ")

                    if(result === true)
                    {
                        groupModel.setProperty(j, "entryCount", groupModel.get(j).entryCount + 1 )
                    }
                }
        }

        Component.onCompleted: {
            countItems();
        }
    }

    Repeater {
        id: groupsRepeater
        model: groupModel

        AlphaMenuGroup {
            id: groupDelegate

            width: root.rowWidth
            baseHeight: root.rowHeight
            height: baseHeight + (groupResultsList !== null ? groupResultsList.height : 0)
            active: root._currActiveGroup === groupDelegate && hasEntries

            name: model.name
            groupIndex: model.index
            hasEntries: model.entryCount > 0

            onClicked: _activate(groupDelegate)
            onActiveChanged: _deactivate(groupDelegate)
        }
    }

    Component {
        id: groupResultsListComponent

        ColumnView {
            id: resultsView

            property real groupIndex
            property real heightAnimationDuration
            property bool animating: heightAnimation.running

            property bool active: height > 0
            onActiveChanged: {
                if (!active) {
                    model = emptyModel
                }
            }

            function open(name, index) {
                queryFilterModel.filterPattern = ''
                queryFilterModel.filterPattern = groupModel.get(index).filter
                queryFilterModel.filter()
                model = queryFilterModel

                heightAnimationDuration = root._groupListOpenAnimationDuration(
                            groupIndex, model.count)
                state = "active"
            }

            function close() {
                state = ""
            }

            itemHeight: Theme.itemSizeSmall

            model: emptyModel
            delegate: root.delegate
            cacheBuffer: itemHeight * 10

            SparqlListModel {
                        id: queryFilterModel
                        property string filterPattern
                        // create a new SparqlConnection for the queryModel

                        connection: SparqlConnection { driver:"QTRACKER_DIRECT" }

                        function filter()
                        {
                            queryFilterModel.query = "SELECT ?title ?artist ?length ?url ?filename "+
                                    "WHERE { ?song a nmm:MusicPiece . "+
                                    "OPTIONAL { ?song nie:title ?title } "+
                                    "OPTIONAL {?song nfo:duration ?length } "+
                                    "?song nie:url ?url ." +
                                    "?song nfo:fileName ?filename . " +
                                    "OPTIONAL { "+
                                    "?song nmm:performer ?aName . "+
                                    "?aName nmm:artistName ?artist . "+
                                    "} "+
                                    "?song nie:mimeType ?mime " +
                                    "FILTER ( ?mime != 'audio/x-mpegurl') " +
                                    "FILTER regex(?title, '^"+ queryFilterModel.filterPattern +"', 'i') "+
                                    "} " +
                                    "ORDER BY ASC(?title)"

                            queryFilterModel.reload()

                        }

                        }

            width: root.width
            height: 0
            x: -parent.x
            y: parent.baseHeight

            states: State {
                name: "active"
                PropertyChanges {
                    target: resultsView
                    height: resultsView.implicitHeight
                }
            }

            // use this instead of a Transition to animate the height because we need to trigger
            // this if open() is called when already active, and animating the height in a
            // standalone animation like fadeInAnimation will reset the height binding
            Behavior on height {
                enabled: !resultsView.menuOpen
                NumberAnimation {
                    id: heightAnimation
                    duration: resultsView.heightAnimationDuration
                    easing.type: root.heightAnimationEasing
                }
            }

            Rectangle {
                anchors.fill: parent
                z: parent.z - 1
                color: Theme.highlightBackgroundColor
                opacity: 0.1
            }
        }
    }
}
