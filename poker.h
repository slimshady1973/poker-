#ifndef POKER_H
#define POKER_H

#include <QObject>
#include <QVector>


class Poker : public QObject
{
    Q_OBJECT
public:
    explicit Poker(QObject *parent = nullptr);
    class Card {
    public:

        void setSuit(QString setSuit) {suit = setSuit;}
        void setNumber(int setNumber) {number = setNumber;}
        void setSource(QString setSource) {source = setSource;}

        QString getSuit() {return suit;}
        int getNumber() {return number;}
        QString getSource() {return source;}

    private:
        QString suit;
        int number;
        QString source;
    };

signals:

public slots:
        QVector<QString> avatars();
        QVector<Card> deck();
        QVector<QString> getCardsInfo();
        int makeTurn(QString suit1, int number1,
                     QString suit2, int number2,
                     int balance, int highestbet, int lastbet);
        int makeTurn2(QVector<QString> suits, QVector<int> numbers, int balance,
                      int highestbet, int lastbet);
        int getCombination(QVector<QString> suits, QVector<int> numbers);

        int comparePairs(QVector<QString> suits, QVector<int> numbers, int winners);

};

#endif // POKER_H
