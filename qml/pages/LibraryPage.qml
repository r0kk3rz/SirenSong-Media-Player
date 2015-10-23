import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sirensong 1.0

Page {
    id: libraryPage
    property bool playerMenuEnabled: false

    property Component songSelectComponent: Qt.createComponent("SongSelect.qml", Component.Asynchronous)
    property Component artistSelectComponent: Qt.createComponent("ArtistSelect.qml", Component.Asynchronous)
    property int defaultLibraryMenu: settings.value("defaultLibraryMenu")

    property string launchArgs: Qt.resolvedUrl(Qt.application.arguments[1]);
    property bool once: false;

    allowedOrientations: Orientation.All

    onLaunchArgsChanged:
    {
        if(once == false)
        {
            if(launchArgs != "")
            {
                console.log("QML: Open URL: " + launchArgs);
                launchTimer.start();
            }
            once = true;
        }
    }

    Timer {
        id: launchTimer
        running: false
        onTriggered: SirenSong.play(launchArgs);
        triggeredOnStart: false
        interval: 500
        repeat: false
    }

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
