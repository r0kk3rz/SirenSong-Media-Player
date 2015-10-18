#include "mediaplayerdbusadaptor.h"

mediaplayerDbusAdaptor::mediaplayerDbusAdaptor(MediaPlayer * mediaplayer) : QDBusAbstractAdaptor(mediaplayer), mp(mediaplayer)
{
    playingStatus = "Playing";
    pausedStatus = "Paused";
    stoppedStatus = "Stopped";

    loopNoneStatus = "None";
    loopPlaylistStatus = "Playlist";

    normalPlaybackRate = 1.0;

    canTrue = true;
    canFalse = false;
    dVolume = 1.0;
    asMetadata = QVariantMap();

    QObject::connect(mp, &MediaPlayer::playbackStatusChanged, this, &mediaplayerDbusAdaptor::playbackStatusChanged);
    QObject::connect(mp, &MediaPlayer::currentIndexChanged, this, &mediaplayerDbusAdaptor::metaDataChanged);

    dbusVolume = new QDBusInterface("com.Meego.MainVolume2", "/com/meego/mainvolume2", "com.Meego.MainVolume2" );

}

void mediaplayerDbusAdaptor::Play()
{
    mp->play();
}

void mediaplayerDbusAdaptor::Stop()
{
    mp->stop();
}

void mediaplayerDbusAdaptor::Pause()
{
    mp->pause();
}

void mediaplayerDbusAdaptor::Next()
{
    mp->next();
}

void mediaplayerDbusAdaptor::Previous()
{
    mp->previous();
}

void mediaplayerDbusAdaptor::OpenUri(QString uri)
{
    mp->play(uri);
}

void mediaplayerDbusAdaptor::PlayPause()
{
    if(mp->playbackStatus() == 1)
    {
        mp->pause();
    }
    else
    {
        mp->play();
    }
}

void mediaplayerDbusAdaptor::Seek(qint64 offset)
{
    Q_UNUSED(offset);
}

void mediaplayerDbusAdaptor::SetPosition(QString trackId, qint64 position)
{
    Q_UNUSED(trackId);
    Q_UNUSED(position);
}

const QString &mediaplayerDbusAdaptor::PlaybackStatus()
{
    switch(mp->playbackStatus())
    {
        case 0:
            return stoppedStatus;
        case 1:
            return playingStatus;
        case 2:
            return pausedStatus;
        default:
            return stoppedStatus;
    }
}

const QString &mediaplayerDbusAdaptor::LoopStatus()
{
    if(mp->loopStatus() == true)
    {
        return loopPlaylistStatus;
    }
    else
    {
        return loopNoneStatus;
    }
}

const QVariantMap &mediaplayerDbusAdaptor::Metadata()
{
    asMetadata = QVariantMap();
    asMetadata.insert("mpris:trackid", QString("/org/mpris/MediaPlayer2/Track/%1").arg(mp->currentIndex()));
    asMetadata.insert("mpris:length", mp->duration());
    asMetadata.insert("xesam:albumArtist", mp->artist());
    asMetadata.insert("xesam:artist", mp->artist());
    asMetadata.insert("xesam:title", mp->title());

    return asMetadata;
}

const double &mediaplayerDbusAdaptor::Rate()
{
    return normalPlaybackRate;
}

const qint64 &mediaplayerDbusAdaptor::Position()
{
    return mp->position();
}

const double &mediaplayerDbusAdaptor::MinimumRate()
{
    return normalPlaybackRate;
}

const double &mediaplayerDbusAdaptor::MaximumRate()
{
    return normalPlaybackRate;
}

const double &mediaplayerDbusAdaptor::Volume()
{
   QDBusReply<uint32_t> reply = dbusVolume->call("CurrentStep");

   if(reply.isValid())
   {
       dVolume = reply.value();
   }

    return dVolume;
}

const bool &mediaplayerDbusAdaptor::CanGoNext()
{
    return canTrue;
}

const bool &mediaplayerDbusAdaptor::CanGoPrevious()
{
    return canTrue;
}

const bool &mediaplayerDbusAdaptor::CanPlay()
{
    return canTrue;
}

const bool &mediaplayerDbusAdaptor::CanPause()
{
    return canTrue;
}

const bool &mediaplayerDbusAdaptor::CanSeek()
{
    return canFalse;
}

const bool &mediaplayerDbusAdaptor::CanControl()
{
    return canTrue;
}

void mediaplayerDbusAdaptor::playbackStatusChanged()
{
    QDBusMessage signal = QDBusMessage::createSignal("/org/mpris/MediaPlayer2","org.freedesktop.DBus.Properties","PropertiesChanged" );
    signal << "org.mpris.MediaPlayer2.Player";
    QVariantMap changedProps;
    changedProps.insert("PlaybackStatus", PlaybackStatus());
    signal << changedProps;
    signal << QStringList();
    QDBusConnection::sessionBus().send(signal);
}

void mediaplayerDbusAdaptor::metaDataChanged()
{
   QDBusMessage signal = QDBusMessage::createSignal("/org/mpris/MediaPlayer2","org.freedesktop.DBus.Properties","PropertiesChanged" );
   signal << "org.mpris.MediaPlayer2.Player";
   QVariantMap changedProps;
   changedProps.insert("Metadata", Metadata());
   signal << changedProps;
   signal << QStringList();
   QDBusConnection::sessionBus().send(signal);
}
