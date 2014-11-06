#include "trackerinterface.h"
#include <QtSparql>
#include <QDateTime>

trackerinterface::trackerinterface(QObject *parent) :
    QObject(parent)
{
    srand(QDateTime::currentMSecsSinceEpoch());
    conn = new QSparqlConnection("QTRACKER_DIRECT");

    QObject::connect(this, &trackerinterface::countItemsComplete, this, &trackerinterface::random);
}

//public method that kicks off the callback chain
void trackerinterface :: randomItem()
{
    this->countItems();
}

void trackerinterface :: countItems()
{
    QSparqlQuery countQuery("SELECT count(?url) AS ?itemCount " \
                            "WHERE { ?song a nmm:MusicPiece . " \
                                "?song nie:url ?url . " \
                            "?song nie:mimeType ?mime " \
                            "FILTER ( ?mime != 'audio/x-mpegurl') "
                            "}");

    countResult = conn->exec(countQuery);

    QObject::connect(countResult, &QSparqlResult::finished, this, &trackerinterface:: countItemCallback);
}

void trackerinterface :: countItemCallback()
{
    countResult->next();

    emit countItemsComplete(countResult->value(0).toInt());
}

void trackerinterface::random(int count)
{
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

    QObject::connect(randomResult, &QSparqlResult::finished, this, &trackerinterface::randomItemCallback);

}

void trackerinterface :: randomItemCallback()
{
    randomResult->next();
    emit randomItemComplete(randomResult->value(0).toString());
}
