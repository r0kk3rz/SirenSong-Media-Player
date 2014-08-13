#include "mediaplayer.h"
#include <QtMultimedia>

MediaPlayer::MediaPlayer( QObject * parent ) : QObject ( parent )
{
    playlist = new QMediaPlaylist;
    player = new QMediaPlayer;

    player->setPlaylist(playlist);
    iPlaybackStatus = 0;
    iPosition = 0;
    iDuration = 0;

    QObject::connect(player, &QMediaPlayer::stateChanged, this, &MediaPlayer::setPlaybackStatus);
    QObject::connect(playlist, &QMediaPlaylist::currentMediaChanged, this, &MediaPlayer::setCurrentContent);
    QObject::connect(player, &QMediaPlayer::positionChanged, this, &MediaPlayer::setPosition);
    QObject::connect(player, &QMediaPlayer::durationChanged, this, &MediaPlayer::setDuration);
}

void MediaPlayer :: play()
{
    player->play();
}

void MediaPlayer :: play(QString url)
{
    playlist->addMedia(QUrl(url));

    playlist->setCurrentIndex((playlist->mediaCount() - 1));

    player->play();
}

void MediaPlayer :: next()
{
    if(playlist->currentIndex() < (playlist->mediaCount() -1))
        playlist->next();
}

void MediaPlayer :: previous()
{
    if(playlist->currentIndex() != 0)
        playlist->previous();
}

void MediaPlayer :: pause()
{
    player->pause();
}

void MediaPlayer :: stop()
{
    player->stop();
}

void MediaPlayer :: addToPlaylist(QString url)
{
    playlist->addMedia(QUrl(url));
}

const int &MediaPlayer :: playbackStatus ( ) {
    return iPlaybackStatus;
}

void MediaPlayer :: setPlaybackStatus(QMediaPlayer::State state)
{
    iPlaybackStatus = state;
    emit playbackStatusChanged();
}

const QMediaContent &MediaPlayer :: currentContent ( ) {
    return qCurrentContent;
}

void MediaPlayer :: setCurrentContent(QMediaContent content)
{
    qCurrentContent = content;
    emit currentContentChanged();
}


const qint64 &MediaPlayer :: duration ( ) {
    return iDuration;
}

void MediaPlayer :: setDuration(qint64 duration)
{
    iDuration = duration;
    emit durationChanged();
}

const qint64 &MediaPlayer :: position( ) {
    return iPosition;
}

void MediaPlayer :: setPosition(qint64 position)
{
    iPosition = position;
    emit positionChanged();
}

