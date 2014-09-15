#ifndef MPRISINTERFACE_H
#define MPRISINTERFACE_H

#include <QObject>
#include <QtDBus>
#include "mediaplayer.h"

class mprisinterface : public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO ("D-Bus Interface", "org.mpris.MediaPlayer2")
    Q_PROPERTY(bool CanQuit READ CanQuit)
    Q_PROPERTY(bool CanRaise READ CanRaise)
    Q_PROPERTY(bool HasTrackList READ HasTrackList)
    Q_PROPERTY(QString Identity READ Identity)

public:
    mprisinterface(MediaPlayer * mediaplayer);
    const bool &CanQuit();
    const bool &CanRaise();
    const bool &HasTrackList();
    const QString &Identity();

signals:

public slots:
    void Raise();
    void Quit();

private:
    bool canTrue;
    bool canFalse;
    QString identity;
    MediaPlayer * mp;

};

#endif // MPRISINTERFACE_H
