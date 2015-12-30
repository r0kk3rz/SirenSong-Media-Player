import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
        property QtObject menuListQueryModel
        property Component subListComponent
        property Item activeParentItem
        property Item activeSubItem

        id: menuListView
        height: (menuListQueryModel.count * Theme.itemSizeSmall) + submenuHeight

        x: -parent.x
        y: Theme.itemSizeSmall

        property int submenuHeight: (activeSubItem != null) && (activeSubItem.active == true) ? activeSubItem.implicitHeight : 0

        //Empty List
        ListModel {
            id: emptyModel
        }

        Repeater {
            id: menuRepeater
            model: menuListQueryModel

            Item {
            id: menuItem
            height: Theme.itemSizeSmall + ((activeSubItem != null) && (active == true) ? activeSubItem.implicitHeight : 0)
            width: menuListView.width
            property bool active: false

            ListItem {
            width: parent.width
            height: Theme.itemSizeSmall
            onClicked: activate(parent)
            Label { x:60; text: menuText; anchors.verticalCenter: parent.verticalCenter }
            }

            function activate(selectedItem)
            {
                if(!menuItem.active)
                {
                    if(activeParentItem != null)
                    {
                        deactivate(activeParentItem)
                    }

                    activeSubItem = subListComponent.createObject(selectedItem);
                    menuItem.active = true
                    activeSubItem.open(menuText)

                    activeParentItem = selectedItem
                }
                else
                {
                    deactivate(menuItem)
                }
            }

            function deactivate(albumItem)
            {
                albumItem.active = false;

                if(menuListView.activeSubItem.active == true)
                    menuListView.activeSubItem.close();
            }
        }
        }

        function open(artistName)
        {
            menuListQueryModel.filter(artistName)
            menuRepeater.model = menuListQueryModel
            state = "active";
        }

        function close()
        {

            state = "";
            menuRepeater.model = emptyModel;
        }
    }
