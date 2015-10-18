import QtQuick 2.0
import Sailfish.Silica 1.0

ApplicationWindow {
    id: appWindow
    cover: Qt.resolvedUrl("qml/cover/CoverPage.qml")
    initialPage: Qt.resolvedUrl("LibraryPage.qml")
    allowedOrientations: Orientation.All
}
