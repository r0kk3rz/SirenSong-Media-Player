#ifndef MEDIAPLAYER_H
#define MEDIAPLAYER_H

#include <QtMultimedia>
#include "trackerinterface.h"

class MediaPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY ( int playbackStatus READ playbackStatus NOTIFY playbackStatusChanged )
    Q_PROPERTY ( qint64 position READ position NOTIFY positionChanged )
    Q_PROPERTY ( qint64 duration READ duration NOTIFY durationChanged )
    Q_PROPERTY(QMediaContent currentContent READ currentContent NOTIFY currentContentChanged)

public:
    MediaPlayer(QObject * parent = 0 );
    const int &playbackStatus( );
    const QMediaContent &currentContent( );
    const qint64 &position( );
    const qint64 &duration( );

public slots:
    void play( );
    void play(QString url);
    void next( );
    void previous( );
    void pause( );
    void stop( );
    void addToPlaylist(QString url);
    //void setCurrentResultsQuery(QString query);

signals:
    void playbackStatusChanged( );
    void currentContentChanged( );
    void positionChanged( );
    void durationChanged( );

private:
    QMediaPlaylist * playlist;
    QMediaPlayer * player;
    int iPlaybackStatus;
    QMediaContent qCurrentContent;
    qint64 iPosition;
    qint64 iDuration;
    QString sCurrentResultsQuery;
    QSparqlResult * result;
    trackerinterface * tracker;

private slots:
    void setPlaybackStatus( QMediaPlayer::State state );
    void setCurrentContent(QMediaContent content);
    void setPosition(qint64 position);
    void setDuration(qint64 duration);
    void checkPlaylist();
    void randomItemComplete(QString url);
};

#endif // MEDIAPLAYER_H
