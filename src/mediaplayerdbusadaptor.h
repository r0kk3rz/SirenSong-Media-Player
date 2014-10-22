#ifndef MEDIAPLAYERDBUSADAPTOR_H
#define MEDIAPLAYERDBUSADAPTOR_H

#include "mediaplayer.h"
#include <QtDBus>

class mediaplayerDbusAdaptor : public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO ("D-Bus Interface", "org.mpris.MediaPlayer2.Player")

    Q_PROPERTY(QString PlaybackStatus READ PlaybackStatus)
    Q_PROPERTY(QString LoopStatus READ LoopStatus)
    Q_PROPERTY(double Rate READ Rate)
    Q_PROPERTY(qint64 Position READ Position)
    Q_PROPERTY(double MinimumRate READ MinimumRate)
    Q_PROPERTY(double MaximumRate READ MaximumRate)
    Q_PROPERTY(double Volume READ Volume)
    Q_PROPERTY(bool CanGoNext READ CanGoNext)
    Q_PROPERTY(bool CanGoPrevious READ CanGoPrevious)
    Q_PROPERTY(bool CanPlay READ CanPlay)
    Q_PROPERTY(bool CanPause READ CanPause)
    Q_PROPERTY(bool CanSeek READ CanSeek)
    Q_PROPERTY(bool CanControl READ CanControl)
    Q_PROPERTY(QVariantMap Metadata READ Metadata)


public:
    mediaplayerDbusAdaptor(MediaPlayer * mediaplayer);
    const QString &PlaybackStatus();
    const QString &LoopStatus();
    const double &Rate();
    const qint64 &Position();
    const double &MinimumRate();
    const double &MaximumRate();
    const QVariantMap &Metadata();
    const double &Volume();
    const bool &CanGoNext();
    const bool &CanGoPrevious();
    const bool &CanPlay();
    const bool &CanPause();
    const bool &CanSeek();
    const bool &CanControl();

public slots:
    void Play();
    void Pause();
    void PlayPause();
    void Stop();
    void Previous();
    void Next();
    void OpenUri(QString uri);
    void Seek(qint64 offset);
    void SetPosition(QString trackId, qint64 position);



private:
    MediaPlayer * mp;
    QString stoppedStatus;
    QString playingStatus;
    QString pausedStatus;
    QString loopNoneStatus;
    QString loopPlaylistStatus;
    QVariantMap asMetadata;
    QDBusInterface * dbusVolume;
    double normalPlaybackRate;
    double dVolume;
    bool canTrue;
    bool canFalse;

private slots:
    void playbackStatusChanged();
    void metaDataChanged();
};

#endif // MEDIAPLAYERDBUSADAPTOR_H
