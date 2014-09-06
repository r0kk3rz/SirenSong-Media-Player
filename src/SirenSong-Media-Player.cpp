#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include "mediaplayer.h"
#include "mediaplayerdbusadaptor.h"
#include "playlistmodel.h"
#include <QtDBus>


static QObject *player(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    static MediaPlayer *player = NULL;
    if (!player) {
        player = new MediaPlayer();
        new mediaplayerDbusAdaptor(player);
        QDBusConnection::sessionBus().registerObject(QString("/org/mpris/MediaPlayer2"), player, QDBusConnection::ExportAdaptors);
    }
    return player;
}

int main(int argc, char *argv[])
{

    QDBusConnection::sessionBus().registerService("org.mpris.MediaPlayer2.sirensong");


    qmlRegisterSingletonType<MediaPlayer>("com.wayfarer.sirensong", 1, 0, "SirenSong", player);

    qmlRegisterType<PlaylistModel>("com.wayfarer.sirensong", 1, 0, "PlaylistModel");

    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    return SailfishApp::main(argc, argv);
}

