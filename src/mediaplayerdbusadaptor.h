#ifndef MEDIAPLAYERDBUSADAPTOR_H
#define MEDIAPLAYERDBUSADAPTOR_H

#include "mediaplayer.h"
#include <QtDBus>

class mediaplayerDbusAdaptor : public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO ("D-Bus Interface", "org.mpris.MediaPlayer2.Player")


public:
    mediaplayerDbusAdaptor(MediaPlayer * mediaplayer);

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
};

#endif // MEDIAPLAYERDBUSADAPTOR_H
