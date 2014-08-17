#include "trackerinterface.h"
#include <QtSparql>
#include <QDateTime>

trackerinterface::trackerinterface(QObject *parent) :
    QObject(parent)
{
    srand(QDateTime::currentMSecsSinceEpoch());
    conn = new QSparqlConnection("QTRACKER_DIRECT");
}

int trackerinterface :: countItems()
{
    QSparqlQuery countQuery("SELECT count(?url) AS ?itemCount" \
                            "WHERE { ?song a nmm:MusicPiece . " \
                            "?song nie:title ?title . " \
                            "?song nfo:duration ?length . " \
                                "?song nie:url ?url . " \
                                "?song nmm:performer ?aName . " \
                                "?aName nmm:artistName ?artist . " \
                                "?song nmm:musicAlbum ?malbum . " \
                                "?malbum nmm:albumTitle ?album " \
                            "}");

    countResult = conn->exec(countQuery);

    countResult->waitForFinished();

    qDebug() << "countResultFinished: " << countResult->isFinished();

    countResult->next();

    return countResult->value(0).toInt();

}

void trackerinterface :: randomItem()
{
    int count;
    count = this->countItems();

    int randIndex;

    randIndex = rand() % count;

    qDebug() << "randomIndex: " << randIndex;

    QSparqlQuery urlQuery(QString("SELECT ?url " \
                                    "WHERE { ?song a nmm:MusicPiece . "  \
                                    "?song nie:title ?title . " \
                                    "?song nfo:duration ?length . " \
                                    "?song nie:url ?url . " \
                                    "?song nmm:performer ?aName . " \
                                    "?aName nmm:artistName ?artist . " \
                                    "?song nmm:musicAlbum ?malbum . " \
                                    "?malbum nmm:albumTitle ?album " \
                                    "} " \
                          "OFFSET %1" \
                                  " LIMIT 1").arg(randIndex) );

    randomResult = conn->exec(urlQuery);

    randomResult->waitForFinished();

    randomResult->next();

    qDebug() << "randomUrl: " << randomResult->value(0).toString();

    emit randomItemComplete(randomResult->value(0).toString());
}
