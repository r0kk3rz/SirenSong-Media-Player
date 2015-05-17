#ifndef MEDIAPLAYLIST_H
#define MEDIAPLAYLIST_H

#include <QtMultimedia>

class MediaPlaylist : public QMediaPlaylist
{
public:
    MediaPlaylist();

public slots:
    QVariantMap getMetaData(int index);

private slots:
    void insertMetaData(int startIndex, int endIndex);
    void metaDataCallback();


private:
    QList <QVariantMap> playlistMetaData;
};

#endif // MEDIAPLAYLIST_H
