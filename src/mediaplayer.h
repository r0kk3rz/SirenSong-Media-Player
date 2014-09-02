#ifndef MEDIAPLAYER_H
#define MEDIAPLAYER_H

#include <QtMultimedia>
#include "trackerinterface.h"
#include "playlistmodel.h"

class MediaPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY ( int playbackStatus READ playbackStatus NOTIFY playbackStatusChanged )
    Q_PROPERTY ( qint64 position READ position NOTIFY positionChanged )
    Q_PROPERTY ( qint64 duration READ duration NOTIFY durationChanged )
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY artistChanged)

public:
    MediaPlayer(QObject * parent = 0 );
    const int &playbackStatus( );
    const qint64 &position( );
    const qint64 &duration( );
    const QString &title( );
    const QString &artist( );


public slots:
    void play( );
    void play(QString url);
    void playIndex(int index);
    void next( );
    void previous( );
    void pause( );
    void stop( );
    void addToPlaylist(QString url);
    //void setCurrentResultsQuery(QString query);
    Q_INVOKABLE PlaylistModel* getPlaylistModel();

signals:
    void playbackStatusChanged( );
    void positionChanged( );
    void durationChanged( );
    void titleChanged( );
    void artistChanged( );

private:
    QMediaPlayer * player;
    QMediaPlaylist * playlist;
    int iPlaybackStatus;
    qint64 iPosition;
    qint64 iDuration;
    QString sCurrentResultsQuery;
    QSparqlResult * result;
    trackerinterface * tracker;
    QString mediaTitle;
    QString mediaArtist;

private slots:
    void setPlaybackStatus( QMediaPlayer::State state );
    void setPosition(qint64 position);
    void setDuration(qint64 duration);
    void setTitle(QString title);
    void setArtist(QString artist);
    void checkPlaylist(int currentIndex);
    void randomItemComplete(QString url);
    void metaDataCallback(QString &key, QVariant &value);
    void metaDataAvailableCallback(bool available);

};

#endif // MEDIAPLAYER_H
