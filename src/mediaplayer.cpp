#include "mediaplayer.h"
#include <QtMultimedia>
#include "trackerinterface.h"
#include <QMediaMetaData>
#include "playlistmodel.h"

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
    QObject::connect(player, &QMediaPlayer::positionChanged, this, &MediaPlayer::setPosition);
    QObject::connect(player, &QMediaPlayer::durationChanged, this, &MediaPlayer::setDuration);
    //QObject::connect(player, &QMediaObject::metaDataAvailableChanged, this, &MediaPlayer::metaDataAvailableCallback);

    QObject::connect(player, SIGNAL(metaDataAvailableChanged(bool)), this, SLOT(metaDataAvailableCallback(bool)));

    QObject::connect(playlist, &QMediaPlaylist::currentIndexChanged, this, &MediaPlayer::checkPlaylist);

    QObject::connect(tracker, &trackerinterface::randomItemComplete, this, &MediaPlayer::randomItemComplete);

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

void MediaPlayer :: playIndex(int index)
{
    if(index <= (playlist->mediaCount() -1))
    {
        playlist->setCurrentIndex(index);
    }
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

PlaylistModel* MediaPlayer :: getPlaylistModel()
{
    PlaylistModel * plModel = new PlaylistModel();
    plModel->setPlaylist(playlist);
    return plModel;
}

void MediaPlayer :: setPosition(qint64 position)
{
    iPosition = position;
    emit positionChanged();

    //hack hack hack, needs doing properly
    metaDataAvailableCallback(player->isMetaDataAvailable());
}

void MediaPlayer :: checkPlaylist(int currentIndex)
{
    qDebug() << "PlaylistIndex: " << currentIndex;
    //check if current item is the last in list
    if(currentIndex == (playlist->mediaCount() -1))
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

void MediaPlayer :: metaDataAvailableCallback(bool available)
{
    if(available)
    {
        setTitle(player->metaData(QMediaMetaData::Title).toString());
        setArtist(player->metaData(QMediaMetaData::AlbumArtist).toString());
    }
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
