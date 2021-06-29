#include "poker.h"
#include <QDebug>

Poker::Poker(QObject *parent) : QObject(parent)
{

}

QVector<QString> Poker::avatars() {
    QVector<QString> avas {
        "qrc:/new/prefix1/41f532b39f85a44ff74deaa2f98a3a79.jpg",
        "qrc:/new/prefix1/pJRRlxmZaEk.jpg",
        "qrc:/new/prefix1/UmLIuKXVDM4.jpg",
        "qrc:/new/prefix1/XwKdEM2WCl4.jpg",
        "qrc:/new/prefix1/zagruzheno.jpg"
    };
    return avas;
}

QVector<Poker::Card> Poker::deck() {
    QVector<QString> sources {
        "qrc:/ezyzip/2Ч.png", "qrc:/ezyzip/3Ч.png", "qrc:/ezyzip/4Ч.png", "qrc:/ezyzip/5Ч.png",
        "qrc:/ezyzip/6Ч.png","qrc:/ezyzip/7Ч.png", "qrc:/ezyzip/8Ч.png", "qrc:/ezyzip/9Ч.png",
        "qrc:/ezyzip/10Ч.png","qrc:/ezyzip/ВЧ.png", "qrc:/ezyzip/ДЧ.png", "qrc:/ezyzip/КЧ.png",
        "qrc:/ezyzip/ТЧ.png", "qrc:/ezyzip/2Б.png", "qrc:/ezyzip/3Б.png", "qrc:/ezyzip/4Б.png", "qrc:/ezyzip/5Б.png",
        "qrc:/ezyzip/6Б.png","qrc:/ezyzip/7Б.png", "qrc:/ezyzip/8Б.png", "qrc:/ezyzip/9Б.png",
        "qrc:/ezyzip/10Б.png","qrc:/ezyzip/ВБ.png", "qrc:/ezyzip/ДБ.png", "qrc:/ezyzip/КБ.png",
        "qrc:/ezyzip/ТБ.png", "qrc:/ezyzip/2К.png", "qrc:/ezyzip/3К.png", "qrc:/ezyzip/4К.png", "qrc:/ezyzip/5К.png",
        "qrc:/ezyzip/6К.png","qrc:/ezyzip/7К.png", "qrc:/ezyzip/8К.png", "qrc:/ezyzip/9К.png",
        "qrc:/ezyzip/10К.png","qrc:/ezyzip/ВК.png", "qrc:/ezyzip/ДК.png", "qrc:/ezyzip/КК.png",
        "qrc:/ezyzip/ТК.png", "qrc:/ezyzip/2В.png", "qrc:/ezyzip/3В.png", "qrc:/ezyzip/4В.png", "qrc:/ezyzip/5В.png",
        "qrc:/ezyzip/6В.png","qrc:/ezyzip/7В.png", "qrc:/ezyzip/8В.png", "qrc:/ezyzip/9В.png",
        "qrc:/ezyzip/10В.png","qrc:/ezyzip/ВВ.png", "qrc:/ezyzip/ДВ.png", "qrc:/ezyzip/КВ.png",
        "qrc:/ezyzip/ТВ.png",
    };
    QVector<Poker::Card> cards {

    };

    for (int i = 2; i < 15; i++) {
        Poker::Card card;
        card.setNumber(i);
        card.setSuit("Hearts");
        card.setSource(sources[i - 2]);
        cards.push_back(card);
    }

    for (int i = 2; i < 15; i++) {
        Poker::Card card;
        card.setNumber(i);
        card.setSuit("Diamonds");
        card.setSource(sources[i - 2 + 13]);
        cards.push_back(card);
    }

    for (int i = 2; i < 15; i++) {
        Poker::Card card;
        card.setNumber(i);
        card.setSuit("Clubs");
        card.setSource(sources[i - 2 + 26]);
        cards.push_back(card);
    }

    for (int i = 2; i < 15; i++) {
        Poker::Card card;
        card.setNumber(i);
        card.setSuit("Spades");
        card.setSource(sources[i - 2 + 39]);
        cards.push_back(card);
    }

    srand(time(NULL));
    QVector<Poker::Card> gottenCards {

    };
    for (int i = 0; i < 17; i++) {
        int cardid = rand() % (52 - i);
        gottenCards.push_back(cards[cardid]);
        cards.remove(cardid);
    }

    return gottenCards;
}

QVector<QString> Poker::getCardsInfo() {

    QVector<Poker::Card> deck = Poker::deck();

    QVector<QString> cards {

    };
    for (int i = 0; i < 17; i++) {
        cards.push_back(deck[i].getSuit());
        cards.push_back(QString::number(deck[i].getNumber()));
        cards.push_back(deck[i].getSource());

    }
    return cards;
}

int Poker::makeTurn(QString suit1, int number1,
                    QString suit2, int number2,
                    int balance, int highestbet, int lastbet) {

    srand(number1);
    int chance = rand() % 100 + 1;

    if ((number1 == number2 || number1 + number2 >= 25) && balance != 0) {
        if (chance < 50 && (balance + lastbet) / 5 >= highestbet)
            return (balance + lastbet) / 5;
        else
            return balance + lastbet;
    }
    else if (suit1 == suit2  && balance != 0) {
        if (chance < 80 && balance + lastbet >= highestbet)
            return highestbet;
        else {
            if (highestbet * 2 < balance + lastbet)
                return highestbet * 2;
            else
                return 0;
        }
    }
    else {
        if (chance < 10  && balance != 0) {
            if (highestbet * 2 < balance + lastbet)
                return highestbet * 2 + lastbet;
            else
                return 0;
        }
        else if (chance > 90  && balance != 0) {
            if ((balance + lastbet) / 5 >= highestbet)
                return (balance + lastbet) / 5;
            else {
                return balance + lastbet;
            }
        }
        else
            return 0;
    }
}

int Poker::makeTurn2(QVector<QString> suits, QVector<int> numbers, int balance,
                     int highestbet, int lastbet) {
    srand(time(NULL));
    QVector<int> sorted {
    };
    QVector<int> copy = numbers;
    qDebug() << copy;

    int cardslength = copy.length();

    bool street = false;
    bool flash = false;
    bool pair = false;

    for (int i = 0; i < cardslength; i++) {
        int numberid = 0;
        int lowest = 99;
        for (int j = 0; j < copy.length(); j++) {
            if (copy[j] < lowest) {
                numberid = j;
                lowest = copy[j];
            }
        }
        sorted.push_back(lowest);
        copy.remove(numberid);
    }

    for (int i = 0; i < sorted.length() - 4; i++) {
        if (sorted[i] + 4 == sorted[i + 1] + 3 == sorted[i + 2] + 2 == sorted[i + 3] + 1 == sorted[i + 4])
            street = true;
    }

    int Hearts = 0;
        int Clubs = 0;
        int Diamonds = 0;
        int Spades = 0;

        for (int i = 0; i < suits.length(); i++) {
            if (suits[i] == "Hearts")
                Hearts++;
            else if (suits[i] == "Clubs")
                Clubs++;
            else if (suits[i] == "Diamonds")
                Diamonds++;
            else
                Spades++;

            if ((Hearts == 5) || (Clubs == 5) || (Spades == 5) || (Diamonds == 5))
                flash = true;
        }

    for (int i = 2; i < numbers.length(); i++) {
        if (numbers[0] == numbers[i] || numbers[1] == numbers[i]) {
            pair = true;
            break;
        }

    }

    srand(numbers[3]);
    int chance = rand() % 100 + 1;

    if ((flash || street || pair) && balance != 0) {
        if (chance < 50)
            return (balance + lastbet) / 5;
        else if (balance + lastbet > highestbet * 2)
            return highestbet * 2;
        else
            return balance + lastbet;
    } else if (balance + lastbet != 0){

        if (chance < 40)
            return 0;
        else if (chance < 80 && balance + lastbet >= highestbet)
            return highestbet;
        else if ((balance + lastbet) / 5 >= highestbet)
            return (balance + lastbet) / 5;
        else
            return 0;

    } else {
        return 0;
    }

}

int Poker::getCombination(QVector<QString> suits, QVector<int> numbers) {
    QVector<int> sorted {
    };

    QVector<QString> sortedsuits {

    };
    QVector<int> copy = numbers;
    QVector<QString> copysuits = suits;

    int cardslength = copy.length();

    int combination = 0;

    for (int i = 0; i < cardslength; i++) {
        int numberid = 0;
        int lowest = 99;
        QString lowestsuit;

        for (int j = 0; j < copy.length(); j++) {
            if (copy[j] < lowest) {
                numberid = j;
                lowest = copy[j];
                lowestsuit = copysuits[j];
            }
        }
        sorted.push_back(lowest);
        sortedsuits.push_back(lowestsuit);
        copy.remove(numberid);
        copysuits.remove(numberid);
    }

    QSet<int> sortedset {};

    for (int i = 0; i < sorted.length(); i++) {
        sortedset.insert(sorted[i]);
    }

    qDebug() << sortedset;
    qDebug() << sorted;
    qDebug() << suits;

    //pair or doublepair
    for (int i = 0; i < numbers.length(); i++) {
        for (int j = i + 1; j < numbers.length(); j++) {
            if (numbers[i] == numbers[j]) {
                combination++;
                if (combination == 2)
                    break;
            }
        }

    }


    //trips
    for (int i = 0; i < numbers.length(); i++) {
        for (int j = i + 1; j < numbers.length(); j++) {
            for (int k = j + 1; k < numbers.length(); k++) {
                if (numbers[i] == numbers[j] == numbers[k]) {
                    combination = 3;
                }
            }
        }

    }
    //street
    for (int i = 0; i < sorted.length() - 4; i++)  {
            if (sorted[i + 4] == sorted[i + 3] + 1 == sorted[i + 2] + 2 == sorted[i + 1] + 3 == sorted[i] + 4)
                combination = 4;
        }


    int Hearts = 0;
    int Clubs = 0;
    int Diamonds = 0;
    int Spades = 0;

    //flash
    for (int i = 0; i < suits.length(); i++) {
        if (suits[i] == "Hearts")
            Hearts++;
        else if (suits[i] == "Clubs")
            Clubs++;
        else if (suits[i] == "Diamonds")
            Diamonds++;
        else
            Spades++;

        if ((Hearts == 5) || (Clubs == 5) || (Spades == 5) || (Diamonds == 5))
            combination = 5;
    }

    //fullhouse

    bool trips = false;
    bool pair = false;
    copy = numbers;

    for (int i = 0; i < copy.length(); i++) {
        for (int j = i + 1; j < numbers.length(); j++) {
            for (int k = j + 1; k < numbers.length(); k++) {
                if (copy[i] == copy[j] == copy[k]) {
                    copy.remove(i);
                    copy.remove(j);
                    copy.remove(k);
                    trips = true;
                    break;
                }
            }
            if (trips == true)
                break;
        }
        if (trips == true)
            break;
    }

    for (int i = 0; i < copy.length(); i++) {
        for (int j = i + 1; j < numbers.length(); j++) {
            if (copy[i] == copy[j]) {
                pair = true;
            }
        }

    }

    if (pair && trips)
        combination = 6;

    //kare
    for (int i = 0; i < numbers.length(); i++) {
        for (int j = i + 1; j < numbers.length(); j++) {
            for (int k = j + 1; k < numbers.length(); k++) {
                for (int z = k + 1; z < numbers.length(); z++) {
                    if (numbers[i] == numbers[j] == numbers[k] == numbers[z]) {
                        combination = 7;
                    }
                }
            }
        }

    }

    //streetflash
    //flashRoyale



    return combination;
}

int Poker::comparePairs(QVector<QString> suits, QVector<int> numbers, int winners) {
    QVector<int> comparisons {};
    for (int i = 0; i < winners; i++) {
        QVector<QString> suitscopy = {suits[i * 2], suits[i * 2 + 1]};
        QVector<int> numberscopy = {numbers[i * 2], numbers[i * 2 + 1]};
        for (int j = winners * 2; j < numbers.length(); j++) {
            suitscopy.push_back(suits[j]);
            numberscopy.push_back(numbers[j]);
        }

        int pairs = 0;

        for (int j = 0; j < numberscopy.length(); j++) {
            for (int k = j + 1; k < numberscopy.length(); k++) {
                if (numberscopy[j] == numberscopy[k] && !pairs) {
                    comparisons.push_back(numberscopy[j]);
                    pairs = numberscopy[j];
                } else if (numberscopy[j] == numberscopy[k] && pairs) {
                    if (pairs < numberscopy[j]) {
                       comparisons[i] = numberscopy[j];
                       break;
                    }
                }
            }

        }
    }

    int result = 0;

    for (int i = 0; i < comparisons.length(); i++) {
            if (comparisons[i] > comparisons[result]) {
                result = i;
            }
    }

    return result;
}
