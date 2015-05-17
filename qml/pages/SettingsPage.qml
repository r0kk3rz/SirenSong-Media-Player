import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sirensong 1.0


Dialog {

    onAccepted: {
        settings.setValue("playMode", playMode.currentIndex)
        settings.setValue("defaultLibraryMenu", defaultLibraryMenu.currentIndex)

        console.log(settings.value("playMode"))
        console.log(settings.value("defaultLibraryMenu"))

        SirenSong.playbackMode = settings.value("playMode");
    }

        VerticalScrollDecorator {}

        Column{
            width: parent.width

            DialogHeader {
                id: header
                acceptText: qsTr("Save")
            }

            ComboBox {
                id: playMode
                label: qsTr("Play Mode")

                currentIndex: settings.value("playMode")

                menu: ContextMenu {
                    MenuItem { text: qsTr("Auto Queue") }
                    MenuItem { text: qsTr("Repeat") }
                    MenuItem { text: qsTr("Shuffle") }
                }

            }

            ComboBox {
                id: defaultLibraryMenu
                label: qsTr("Default Library Menu")

                currentIndex: settings.value("defaultLibraryMenu")

                menu: ContextMenu {
                    MenuItem { text: qsTr("Sort by Song") }
                    MenuItem { text: qsTr("Sort by Artist") }
                }
            }
            /*

            TextField {
                id: musicDirectory
                width: parent.width
                text: qsTr("/")
                label: qsTr("Music Directory")
            }
            */
        }

}
