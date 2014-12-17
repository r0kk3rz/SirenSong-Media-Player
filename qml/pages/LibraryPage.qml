import QtQuick 2.0
import Sailfish.Silica 1.0
import com.wayfarer.sirensong 1.0
import Sailfish.Media 1.0
import org.nemomobile.policy 1.0

Page {
    id: libraryPage
    property bool playerMenuEnabled: false

    property Component songSelectComponent: Qt.createComponent("SongSelect.qml", Component.Asynchronous)
    property Component artistSelectComponent: Qt.createComponent("ArtistSelect.qml", Component.Asynchronous)
    property int defaultLibraryMenu: settings.value("defaultLibraryMenu")

    Connections {
        target: SirenSong
        onPlaybackStatusChanged: {

            if (SirenSong.playbackStatus === 1) {
                if (libraryPage.playerMenuEnabled == false) {
                    pageStack.pushAttached(Qt.resolvedUrl("PlayerPage.qml"))
                    pageStack.navigateForward(PageStackAction.Animated)
                    libraryPage.playerMenuEnabled = true
                }
            }

            if (SirenSong.playbackStatus === 0) {
                if (libraryPage.playerMenuEnabled == true) {
                    pageStack.popAttached(libraryPage, PageStackAction.Animated)
                    libraryPage.playerMenuEnabled = false
                }
            }
        }
    }

    MediaKey {
        enabled: true
        key: Qt.Key_MediaTogglePlayPause
        onPressed: SirenSong.playbackStatus === 1 ? SirenSong.pause() : SirenSong.play()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaPlay
        onPressed: SirenSong.play()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaPause
        onPressed: SirenSong.pause()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaStop
        onPressed: SirenSong.stop()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaNext
        onPressed: SirenSong.next()
    }
    MediaKey {
        enabled: true
        key: Qt.Key_MediaPrevious
        onPressed: SirenSong.previous()
    }

    Permissions {
        enabled: true
        applicationClass: "player"

        Resource {
            id: keysResource
            type: Resource.HeadsetButtons
            optional: true
        }
    }

    SilicaFlickable {
        id: root
        width: parent.width
        height: parent.height

        VerticalScrollDecorator {}
        contentHeight: Math.max(1, (browser.height + header.height))


        // pull down for different library menus
        PullDownMenu {
            /*
            MenuItem {
                text: qsTr("Search")
                onClicked: browser.source = "SearchSelect.qml"
            } */

            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                text: qsTr("Sort by Artist")
                onClicked: browser.sourceComponent = artistSelectComponent
            }

            MenuItem {
                text: qsTr("Sort by Song")
                onClicked: browser.sourceComponent = songSelectComponent
            }
        }


        Column {
            id: mainColumn
            width: parent.width

            PageHeader {
                id: header
                title: qsTr("Library")
            }

            Loader {
                id: browser
                width: parent.width
                asynchronous: true
                sourceComponent: defaultLibraryMenu == 0? songSelectComponent : artistSelectComponent
                visible: status == Loader.Ready
            }
        }
    }
}
