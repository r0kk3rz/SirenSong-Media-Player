#include "mediaplayerdbusadaptor.h"

mediaplayerDbusAdaptor::mediaplayerDbusAdaptor(MediaPlayer * mediaplayer) : QDBusAbstractAdaptor(mediaplayer), mp(mediaplayer)
{
    playingStatus = "Playing";
    pausedStatus = "Paused";
    stoppedStatus = "Stopped";
    normalPlaybackRate = 1.0;

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
    }
}

const double &mediaplayerDbusAdaptor::Rate()
{
    return normalPlaybackRate;
}

const double &mediaplayerDbusAdaptor::MinimumRate()
{
    return normalPlaybackRate;
}

const double &mediaplayerDbusAdaptor::MaximumRate()
{
    return normalPlaybackRate;
}
