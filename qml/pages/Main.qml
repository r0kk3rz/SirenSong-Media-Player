import QtQuick 2.0
import Sailfish.Silica 1.0
import com.wayfarer.sirensong 1.0
import Sailfish.Media 1.0
import org.nemomobile.policy 1.0


Page {
    id: libraryPage
    property bool playerMenuEnabled: false

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

        property real _newContentY: 0
        property real _contentYBeforeGroupOpen: -1

        VerticalScrollDecorator {}
        contentHeight: Math.max(1, (browser.height + header.height))

        onFlickStarted: _contentYBeforeGroupOpen = -1

        // pull down for different library menus
        PullDownMenu {
            MenuItem {
                text: "Search"
                onClicked: browser.source = "SearchSelect.qml"
            }
            MenuItem {
                text: "Sort by Artist"
                onClicked: browser.source = "ArtistSelect.qml"
            }
            MenuItem {
                text: "Sort by Song"
                onClicked: browser.source = "SongSelect.qml"
            }
        }

        NumberAnimation {
            id: contentYAnimation
            target: root
            property: "contentY"
            to: parent._newContentY
        }

        function _animateContentY(newValue, duration, easing) {
            _newContentY = newValue
            console.log("animating: " +_newContentY)
            contentYAnimation.duration = duration
            contentYAnimation.easing.type = easing
            contentYAnimation.start()
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
                source: "SongSelect.qml"
            }
        }
    }
}
