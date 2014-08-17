#ifndef TRACKERINTERFACE_H
#define TRACKERINTERFACE_H

#include <QObject>
#include <QtSparql>

class trackerinterface : public QObject
{
    Q_OBJECT
public:
    explicit trackerinterface(QObject *parent = 0);

signals:
    void randomItemComplete(QString url);

public slots:
    void randomItem();

private:
    QSparqlResult * countResult;
    QSparqlResult * randomResult;
    QSparqlConnection * conn;

private slots:
    int countItems();
};

#endif // TRACKERINTERFACE_H
