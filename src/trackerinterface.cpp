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
    QSparqlQuery countQuery("SELECT count(?url) AS ?itemCount " \
                            "WHERE { ?song a nmm:MusicPiece . " \
                                "?song nie:url ?url . " \
                            "?song nie:mimeType ?mime " \
                            "FILTER ( ?mime != 'audio/x-mpegurl') "
                            "}");

    countResult = conn->exec(countQuery);

    countResult->waitForFinished();

    countResult->next();

    return countResult->value(0).toInt();

}

void trackerinterface :: randomItem()
{
    int count;
    count = this->countItems();

    int randIndex;

    randIndex = rand() % count;

    QSparqlQuery urlQuery(QString("SELECT ?url " \
                                    "WHERE { ?song a nmm:MusicPiece . "  \
                                    "?song nie:url ?url . " \
                                  "?song nie:mimeType ?mime " \
                                  "FILTER ( ?mime != 'audio/x-mpegurl') " \
                                    "} " \
                          "OFFSET %1" \
                                  " LIMIT 1").arg(randIndex) );

    randomResult = conn->exec(urlQuery);

    randomResult->waitForFinished();

    randomResult->next();

    emit randomItemComplete(randomResult->value(0).toString());
}
