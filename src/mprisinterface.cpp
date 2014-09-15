#include "mprisinterface.h"

mprisinterface::mprisinterface(MediaPlayer * mediaplayer) : QDBusAbstractAdaptor(mediaplayer), mp(mediaplayer)
{
    canTrue = true;
    canFalse = false;
    identity = "SirenSong";

}

const bool &mprisinterface::CanQuit()
{
    return canFalse;
}

const bool &mprisinterface::CanRaise()
{
    return canFalse;
}

const bool &mprisinterface::HasTrackList()
{
    return canFalse;
}

const QString &mprisinterface::Identity()
{
    return identity;
}

void mprisinterface::Raise()
{

}

void mprisinterface::Quit()
{

}
