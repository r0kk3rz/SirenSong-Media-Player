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
    void countItemsComplete(int count);


public slots:
    void randomItem();

private:
    QSparqlResult * countResult;
    QSparqlResult * randomResult;
    QSparqlConnection * conn;

private slots:
    void countItems();
    void random(int count);
    void countItemCallback();
    void randomItemCallback();
};

#endif // TRACKERINTERFACE_H
