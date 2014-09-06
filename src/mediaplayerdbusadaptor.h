#ifndef MEDIAPLAYERDBUSADAPTOR_H
#define MEDIAPLAYERDBUSADAPTOR_H

#include "mediaplayer.h"
#include <QtDBus>

class mediaplayerDbusAdaptor : public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO ("D-Bus Interface", "org.mpris.MediaPlayer2.Player")

    Q_PROPERTY(QString PlaybackStatus READ PlaybackStatus)
    Q_PROPERTY(double Rate READ Rate)
    Q_PROPERTY(double MinimumRate READ MinimumRate)
    Q_PROPERTY(double MaximumRate READ MaximumRate)


public:
    mediaplayerDbusAdaptor(MediaPlayer * mediaplayer);
    const QString &PlaybackStatus();
    const double &Rate();
    const double &MinimumRate();
    const double &MaximumRate();

public slots:
    void Play();
    void Pause();
    void PlayPause();
    void Stop();
    void Previous();
    void Next();
    void OpenUri(QString uri);

private:
    MediaPlayer * mp;
    QString stoppedStatus;
    QString playingStatus;
    QString pausedStatus;
    double normalPlaybackRate;
};

#endif // MEDIAPLAYERDBUSADAPTOR_H
