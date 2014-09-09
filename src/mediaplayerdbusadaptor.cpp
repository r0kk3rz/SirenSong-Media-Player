#include "mediaplayerdbusadaptor.h"

mediaplayerDbusAdaptor::mediaplayerDbusAdaptor(MediaPlayer * mediaplayer) : QDBusAbstractAdaptor(mediaplayer), mp(mediaplayer)
{
    playingStatus = "Playing";
    pausedStatus = "Paused";
    stoppedStatus = "Stopped";
    normalPlaybackRate = 1.0;
    canTrue = true;
    canFalse = false;
    dVolume = 1.0;
    asMetadata = QVariantMap();


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

/*
void mediaplayerDbusAdaptor::notifyPropertyChanged( const QString& interface, const QString& propertyName )
{
    QDBusMessage signal = QDBusMessage::createSignal(mprisObjectPath,freedesktopPath,"PropertiesChanged" );
    signal << interface;
    QVariantMap changedProps;
    changedProps.insert(propertyName, property(propertyName.toLatin1()));
    signal << changedProps;
    signal << QStringList();
    qDebug() << propertyName;
    qDebug() << changedProps;
    QDBusConnection::sessionBus().send(signal);
} */
