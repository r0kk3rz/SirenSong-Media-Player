#ifndef MEDIAPLAYER_H
#define MEDIAPLAYER_H

#include <QtMultimedia>

class MediaPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY ( int playbackStatus READ playbackStatus NOTIFY playbackStatusChanged )
    Q_PROPERTY ( qint64 position READ position NOTIFY positionChanged )
    Q_PROPERTY ( qint64 duration READ duration NOTIFY durationChanged )

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

private slots:
    void setPlaybackStatus( QMediaPlayer::State state );
    void setCurrentContent(QMediaContent content);
    void setPosition(qint64 position);
    void setDuration(qint64 duration);
};

#endif // MEDIAPLAYER_H
