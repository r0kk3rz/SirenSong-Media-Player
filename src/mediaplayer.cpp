#include "mediaplayer.h"
#include <QtMultimedia>
#include "trackerinterface.h"
#include <QMediaMetaData>
#include "playlistmodel.h"

MediaPlayer::MediaPlayer( QObject * parent ) : QObject ( parent )
{
    playlist = new MediaPlaylist;
    player = new QMediaPlayer;
    tracker = new trackerinterface;
    player->setPlaylist(playlist);
    iPlaybackStatus = 0;
    iPosition = 0;
    iDuration = 0;
    iCurrentIndex = 0;
    sCurrentResultsQuery = "";
    mediaArtist = "";
    mediaTitle = "";
    plModel = new PlaylistModel();
    plModel->setPlaylist(playlist);
    shuffle = false;
    loop = false;

    QObject::connect(player, &QMediaPlayer::stateChanged, this, &MediaPlayer::setPlaybackStatus);
    QObject::connect(player, &QMediaPlayer::positionChanged, this, &MediaPlayer::setPosition);
    QObject::connect(player, &QMediaPlayer::durationChanged, this, &MediaPlayer::setDuration);

    //Old connection syntax due to overloaded metaDataChanged()
    QObject::connect(player, SIGNAL(metaDataChanged()), this, SLOT(metaDataCallback()));

    QObject::connect(playlist, &QMediaPlaylist::currentIndexChanged, this, &MediaPlayer::checkPlaylist);

    //QObject::connect(tracker, &trackerinterface::randomItemComplete, this, &MediaPlayer::addToPlaylist);

    //old connection syntax due to overloaded slot method
    QObject::connect(tracker, SIGNAL(randomItemComplete(QString)), this, SLOT(addToPlaylist(QString)));
}

void MediaPlayer :: play()
{
    player->play();
}

void MediaPlayer :: play(QString url)
{
    this->addToPlaylist(url);

    playlist->setCurrentIndex((playlist->mediaCount() - 1));

    play();
}

void MediaPlayer :: playIndex(int index)
{
    if(index <= (playlist->mediaCount() -1))
    {
        playlist->setCurrentIndex(index);
        play();
    }
}

void MediaPlayer :: next()
{
    if((playlist->currentIndex() < (playlist->mediaCount() -1)) || loop)
    {
        playlist->next();
    }
}

void MediaPlayer :: previous()
{
    if((playlist->currentIndex() != 0) || loop)
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

void MediaPlayer :: addToPlaylist(QList<QString> items)
{
    foreach (const QString &url, items)
    {
        
    }
}

void MediaPlayer::clearPlaylist()
{
    qDebug() << "Clear Playlist";
    stop();
    playlist->clear();
}

void MediaPlayer::toggleLoop()
{
    qDebug() << "Toggle Loop: " << loop;
    if(loop == true)
    {
        loop = false;
        playlist->setPlaybackMode(QMediaPlaylist::Sequential);
        emit loopStatusChanged();
        checkPlaylist(playlist->currentIndex());
    }
    else
    {
        loop = true;
        playlist->setPlaybackMode(QMediaPlaylist::Loop);
        emit loopStatusChanged();
    }
}

const bool &MediaPlayer :: loopStatus()
{
    return loop;
}

const int &MediaPlayer :: playbackStatus ( ) {
    return iPlaybackStatus;
}

const int &MediaPlayer::currentIndex() {
    return iCurrentIndex;
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

PlaylistModel* &MediaPlayer :: playlistModel()
{
    return plModel;
}

void MediaPlayer :: setPosition(qint64 position)
{
    iPosition = position;
    emit positionChanged();
}

void MediaPlayer :: checkPlaylist(int currentIndex)
{
    iCurrentIndex = currentIndex;
    emit currentIndexChanged();

    if(!shuffle && !loop)
    {
        //check if current item is the last in list
        if(currentIndex == (playlist->mediaCount() -1))
        {
            //insert random item next
            tracker->randomItem();
        }
    }
}

void MediaPlayer :: metaDataCallback()
{

    if(player->metaData(QMediaMetaData::Title).toString() != "")
    {
        setTitle(player->metaData(QMediaMetaData::Title).toString());
    }
    else
    {
        setTitle(QFileInfo(player->currentMedia().canonicalUrl().toString()).fileName());
    }

    if(player->metaData(QMediaMetaData::AlbumArtist).toString() != "")
    {
        setArtist(player->metaData(QMediaMetaData::AlbumArtist).toString());
    }
    else
    {
        setArtist("Unknown Artist");
    }


}
