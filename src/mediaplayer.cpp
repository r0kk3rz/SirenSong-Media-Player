#include "mediaplayer.h"
#include <QtMultimedia>
#include "trackerinterface.h"
#include <QMediaMetaData>

MediaPlayer::MediaPlayer( QObject * parent ) : QObject ( parent )
{
    playlist = new QMediaPlaylist;
    player = new QMediaPlayer;
    tracker = new trackerinterface;

    player->setPlaylist(playlist);
    iPlaybackStatus = 0;
    iPosition = 0;
    iDuration = 0;
    sCurrentResultsQuery = "";
    mediaArtist = "Artist";
    mediaTitle = "Title";

    QObject::connect(player, &QMediaPlayer::stateChanged, this, &MediaPlayer::setPlaybackStatus);
    QObject::connect(player, &QMediaPlayer::currentMediaChanged, this, &MediaPlayer::setCurrentContent);
    QObject::connect(player, &QMediaPlayer::positionChanged, this, &MediaPlayer::setPosition);
    QObject::connect(player, &QMediaPlayer::durationChanged, this, &MediaPlayer::setDuration);
    QObject::connect(tracker, &trackerinterface::randomItemComplete, this, &MediaPlayer::randomItemComplete);

    //old connect syntax due to overloaded metaDataChanged signal
    QObject::connect(player, SIGNAL(metaDataChanged(QString&,QVariant&)), this, SLOT(metaDataCallback(QString&,QVariant&)));
}

void MediaPlayer :: play()
{
    player->play();
}

void MediaPlayer :: play(QString url)
{
    this->addToPlaylist(url);

    playlist->setCurrentIndex((playlist->mediaCount() - 1));

    player->play();
}

void MediaPlayer :: next()
{
    if(playlist->currentIndex() < (playlist->mediaCount() -1))
    {
        playlist->next();
    }
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
    checkPlaylist();
    qDebug("currentContentChanged");
}

const QString &MediaPlayer :: title ( ) {
    return mediaTitle;
}

void MediaPlayer :: setTitle(QString title)
{
    mediaTitle = title;
    emit titleChanged();
}

const QString &MediaPlayer :: artist ( ) {
    return mediaArtist;
}

void MediaPlayer :: setArtist(QString artist)
{
    mediaArtist = artist;
    emit artistChanged();
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

void MediaPlayer :: checkPlaylist()
{
    //check if current item is the last in list
    if(playlist->currentIndex() == (playlist->mediaCount() -1))
    {
        //insert random item next
        tracker->randomItem();
    }

    qDebug() << "mediaCount: " << playlist->mediaCount();

    //cleanup task so list doesnt get too big
    //if(playlist->mediaCount() >= 50)
    //{
        //make sure we arent removing the current media
      //  if(playlist->currentIndex() != 0)
        //{
          //  playlist->removeMedia(0);
        //}
    //}
}

//async callback handler for tracker
void MediaPlayer :: randomItemComplete(QString url)
{
    this->addToPlaylist(url);
}

void MediaPlayer :: metaDataCallback(QString &key, QVariant &value)
{
    qDebug() << "metadatakey: " << key;
    qDebug() << "metadatavalue: " << value.toString();

    if(key == QMediaMetaData::Title)
        setTitle(value.toString());
        
    if(key == QMediaMetaData::AlbumArtist)
        setArtist((value.toString()));
}
