
#include <QtQuick>
#include <sailfishapp.h>
#include "mediaplayer.h"
#include "mediaplayerdbusadaptor.h"
#include "playlistmodel.h"
#include "mprisinterface.h"
#include "settings.h"
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
    QStringList serviceList = QDBusConnection::sessionBus().interface()->registeredServiceNames().value();

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    if(serviceList.contains("org.mpris.MediaPlayer2.sirensong"))
    {
        qDebug() << "found existing process";

        if(app->arguments().count() > 1)
        {
            QUrl loadMedia = QUrl(app->arguments().at(1));

            if(loadMedia.isValid())
            {
                qDebug() << "Sending Open Uri to existing processs";
                qDebug() << "Open" << app->arguments().at(1);

                QDBusMessage m = QDBusMessage::createMethodCall("org.mpris.MediaPlayer2.sirensong",
                        "/org/mpris/MediaPlayer2",
                        "org.mpris.MediaPlayer2.Player",
                         "OpenUri");
                m << app->arguments().at(1);
                QDBusConnection::sessionBus().send(m);
            }
        }

        exit(0);
    }

    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QCoreApplication::setApplicationName("SirenSong");
    QCoreApplication::setOrganizationName("Wayfarer");

    QDBusConnection::sessionBus().registerService("org.mpris.MediaPlayer2.sirensong");

    qmlRegisterSingletonType<MediaPlayer>("harbour.sirensong", 1, 0, "SirenSong", player);

    qmlRegisterType<PlaylistModel>("harbour.sirensong", 1, 0, "PlaylistModel");

    Settings settings;

    view->rootContext()->setContextProperty("settings", &settings);

    view->setSource(SailfishApp::pathTo("qml/harbour-sirensong.qml"));
    view->show();

    return app->exec();
}

