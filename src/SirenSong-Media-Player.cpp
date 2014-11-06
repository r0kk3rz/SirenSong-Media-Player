
#include <QtQuick>
#include <sailfishapp.h>
#include "mediaplayer.h"
#include "mediaplayerdbusadaptor.h"
#include "playlistmodel.h"
#include "mprisinterface.h"
#include <QtDBus>


static QObject *player(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    static MediaPlayer *player = NULL;
    if (!player) {
        player = new MediaPlayer();
        new mediaplayerDbusAdaptor(player);
        new mprisinterface(player);
        QDBusConnection::sessionBus().registerObject(QString("/org/mpris/MediaPlayer2"), player, QDBusConnection::ExportAdaptors);
    }
    return player;
}

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QDBusConnection::sessionBus().registerService("org.mpris.MediaPlayer2.sirensong");

    qmlRegisterSingletonType<MediaPlayer>("com.wayfarer.sirensong", 1, 0, "SirenSong", player);

    qmlRegisterType<PlaylistModel>("com.wayfarer.sirensong", 1, 0, "PlaylistModel");

    view->setSource(SailfishApp::pathTo("qml/SirenSong-Media-Player.qml"));
    view->show();

    return app->exec();
}

