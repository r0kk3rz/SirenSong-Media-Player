#ifndef MEDIAPLAYER_H
#define MEDIAPLAYER_H

#include <QtMultimedia>
#include "trackerinterface.h"
#include "playlistmodel.h"
#include "mediaplaylist.h"

class MediaPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY ( int playbackStatus READ playbackStatus NOTIFY playbackStatusChanged )
    Q_PROPERTY ( qint64 position READ position NOTIFY positionChanged )
    Q_PROPERTY ( qint64 duration READ duration NOTIFY durationChanged )
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY artistChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(PlaylistModel * playlistModel READ playlistModel)
    Q_PROPERTY(bool loopStatus READ loopStatus NOTIFY loopStatusChanged)

public:
    MediaPlayer(QObject * parent = 0 );
    const int &playbackStatus( );
    const qint64 &position( );
    const qint64 &duration( );
    const QString &title( );
    const QString &artist( );
    const int &currentIndex( );
    const bool &loopStatus();
    PlaylistModel* &playlistModel();


public slots:
    void play( );
    void play(QString url);
    void playIndex(int index);
    void next( );
    void previous( );
    void pause( );
    void stop( );
    void addToPlaylist(QString url);
    void clearPlaylist();
    void toggleLoop();
    //void setCurrentResultsQuery(QString query);


signals:
    void playbackStatusChanged( );
    void positionChanged( );
    void durationChanged( );
    void titleChanged( );
    void artistChanged( );
    void currentIndexChanged();
    void loopStatusChanged();

private:
    QMediaPlayer * player;
    MediaPlaylist * playlist;
    int iPlaybackStatus;
    qint64 iPosition;
    qint64 iDuration;
    QString sCurrentResultsQuery;
    QSparqlResult * result;
    trackerinterface * tracker;
    QString mediaTitle;
    QString mediaArtist;
    int iCurrentIndex;
    PlaylistModel * plModel;
    bool shuffle;
    bool loop;

private slots:
    void setPlaybackStatus( QMediaPlayer::State state );
    void setPosition(qint64 position);
    void setDuration(qint64 duration);
    void setTitle(QString title);
    void setArtist(QString artist);
    void checkPlaylist(int currentIndex);
    void metaDataCallback();
};

#endif // MEDIAPLAYER_H
