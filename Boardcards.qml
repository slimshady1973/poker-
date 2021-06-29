import QtQuick 2.0
import QtQuick.Layouts 1.12

RowLayout {

    function getCards(board) {
        for (var i = 0; i < 5; i++) {
            cards.itemAt(i).cardsuit = board[i * 3]
            cards.itemAt(i).cardnumber = board[i * 3 + 1]
            cards.itemAt(i).cardsource = board[i * 3 + 2]
        }
    }

    function hideCards() {
        for (var i = 0; i < 5; i++)
            cards.itemAt(i).visible = false
    }

    function show3cards() {
        for (var i = 0; i < 3; i++)
            cards.itemAt(i).visible = true
    }

    function show4card() {
        cards.itemAt(3).visible = true
    }

    function show5card() {
        cards.itemAt(4).visible = true
    }

    function getcardsuit(i) {
            return cards.itemAt(i).cardsuit
    }

    function getcardnumber(i) {
            return cards.itemAt(i).cardnumber
    }

    Repeater {
        id: cards
        model: 5
        Card {
            Layout.preferredHeight: 96
            Layout.preferredWidth: 64
            visible: false
        }
    }

}
