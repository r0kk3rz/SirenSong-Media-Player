#include "mediaplaylist.h"
#include <QtSparql>

MediaPlaylist::MediaPlaylist() : QMediaPlaylist()
{  
    QObject::connect(this, &MediaPlaylist::mediaInserted, this, &MediaPlaylist::insertMetaData);
}

QVariantMap MediaPlaylist::getMetaData(int index)
{
    return playlistMetaData.at(index);
}

void MediaPlaylist::insertMetaData(int startIndex, int endIndex)
{
    for(int index = startIndex; index <= endIndex; index++ )
    {
        QUrl location = this->media(index).canonicalUrl();

        QSparqlConnection * conn = new QSparqlConnection("QTRACKER_DIRECT");

        QSparqlQuery metaDataQuery(QString("SELECT ?url ?title ?length ?artist ?album ?filename " \
                                "WHERE { ?song a nmm:MusicPiece . " \
                                    "?song nfo:duration ?length . " \
                                    "?song nie:url ?url . " \
                                    "?song nfo:fileName ?filename . " \
                                    "OPTIONAL { " \
                                           "?song nie:title ?title . " \
                                    " } " \
                                    "OPTIONAL { " \
                                           "?song nmm:performer ?aName . " \
                                           "?aName nmm:artistName ?artist . " \
                                    " } " \
                                    "OPTIONAL { " \
                                            "?song nmm:musicAlbum ?malbum . " \
                                           "?malbum nmm:albumTitle ?album " \
                                    " } " \
                                    "FILTER (?url = \"%1\") " \
                                           "} LIMIT 1").arg(location.toString(QUrl::FullyEncoded)));

        QSparqlResult * result = conn->exec(metaDataQuery);

        result->waitForFinished();

        result->first();

        QVariantMap metaData;

        metaData.insert("Title", result->value(1).toString() != "" ? result->value(1).toString() : result->value(5).toString());
        metaData.insert("Duration", result->value(2).toString());
        metaData.insert("Artist", result->value(3).toString() != "" ? result->value(3).toString() : "Unknown Artist");
        metaData.insert("Album", result->value(4).toString());

        playlistMetaData.insert(index, metaData);
    }
}

void MediaPlaylist::metaDataCallback()
{
    QSparqlResult* result = qobject_cast<QSparqlResult *>(sender());
}
