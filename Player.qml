import QtQuick 2.0
import QtQuick.Layouts 1.12


RowLayout {
    id: player
    x: 170
    y: 70

    visible: false

    property string ava: ""
    property string cardsuit1: ""
    property int cardnumber1: 0
    property string cardsource1: ""

    property string cardsuit2: ""
    property int cardnumber2: 0
    property string cardsource2: ""

    property int balance: 1000
    property int lastBet: 0

    property bool isActive: false
    property bool lost: false

    spacing: 1

    function fold() {
        card1.visible = false
        card2.visible = false
    }

    function open() {
        card1.source = cardsource1
        card2.source = cardsource2
    }

    function close() {
        card1.source = "qrc:/new/prefix1/Novy_proekt.png"
        card2.source = "qrc:/new/prefix1/Novy_proekt.png"
        card1.visible = true
        card2.visible = true
    }

    Rubashka {
        id: card1
        Layout.preferredHeight: 96
        Layout.preferredWidth: 64
    }
    Rubashka {
        id: card2
        Layout.preferredHeight: 96
        Layout.preferredWidth: 64
    }

    ColumnLayout {
        Image {
            id: ava
            Layout.preferredHeight: 96
            Layout.preferredWidth: 96
            source: player.ava
        }
        Text {
            text: "Balance: " + balance
            color: "white"
        }
        Text {
            text: "Bet: " + lastBet
            color: "white"
        }
    }
}

