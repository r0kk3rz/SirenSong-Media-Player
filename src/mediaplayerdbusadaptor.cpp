#include "mediaplayerdbusadaptor.h"

mediaplayerDbusAdaptor::mediaplayerDbusAdaptor(MediaPlayer * mediaplayer) : QDBusAbstractAdaptor(mediaplayer), mp(mediaplayer)
{

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

