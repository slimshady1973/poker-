import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {
    width: 960
    height: 640
    visible: true
    title: qsTr("Poker")
    color: "#BDBDBC"

    property string cardsuit1: ""
    property int cardnumber1: 0
    property string cardsource1: ""

    property string cardsuit2: ""
    property int cardnumber2: 0
    property string cardsource2: ""

    property int balance: 1000
    property int lastBet: 0
    property bool isActive: false

    property int turn: 1


    property int lastPlayer: 2
    property int prelastPlayer: 2
    property int dealer: 5
    property var board: []
    property int bank: 0
    property int highestBet: 20
    property int bigBlind: 20
    property int activePlayers: 6

    function lost() {
        loseDialog.visible = true
    }
    function wingame() {
        winDialog.visible = true
    }

    function findActivePlayer() {
        for (var i = 0; i < 5; i++) {
            if (players.itemAt(i).isActive === true)
                return i
        }
        return 5
    }

    function win(winner) {
        if (winner === 5) {
            balance = balance + bank
            hud.visible = false
            timer.running = true
        } else {
            players.itemAt(winner).balance = players.itemAt(winner).balance + bank
        }
    }

    function makeTurn(start, end) {
        for (var i = start; i < end; i++) {
            if (players.itemAt(i).isActive === true) {
                var bet = poker.makeTurn(players.itemAt(i).cardsuit1,  players.itemAt(i).cardnumber1,
                                         players.itemAt(i).cardsuit2, players.itemAt(i).cardnumber2,
                                         players.itemAt(i).balance, highestBet, players.itemAt(i).lastBet)
                console.log(bet)
                if (bet >= highestBet) {
                    players.itemAt(i).balance = players.itemAt(i).balance + players.itemAt(i).lastBet - bet
                    bank = bank + bet - players.itemAt(i).lastBet
                    players.itemAt(i).lastBet = bet
                    if (bet > highestBet)
                        lastPlayer = i
                    highestBet = bet
                }
                else if(bet === players.itemAt(i).balance + players.itemAt(i).lastBet) {
                    players.itemAt(i).balance = 0
                    bank = bank + bet - players.itemAt(i).lastBet
                    players.itemAt(i).lastBet = bet

                } else {
                    players.itemAt(i).isActive = false
                    players.itemAt(i).fold()
                    activePlayers = activePlayers - 1
                    if (activePlayers === 1)
                        win(findActivePlayer())
                }

            }
        }
    }

    function makeTurn2(start, end, cardcount) {
        for (var i = start; i < end; i++) {
            if (players.itemAt(i).isActive === true) {
                var suits = [players.itemAt(i).cardsuit1, players.itemAt(i).cardsuit2]
                var numbers = [players.itemAt(i).cardnumber1, players.itemAt(i).cardnumber2]

                for (var j = 0; j < cardcount; j++) {
                    suits.push(boardcards.getcardsuit(j))
                    numbers.push(boardcards.getcardnumber(j))
                }

                var bet = poker.makeTurn2(suits, numbers,
                                         players.itemAt(i).balance, highestBet, players.itemAt(i).lastBet)
                console.log(bet)
                    if (bet >= highestBet) {
                        players.itemAt(i).balance = players.itemAt(i).balance - bet + players.itemAt(i).lastBet
                        bank = bank + bet - players.itemAt(i).lastBet
                        players.itemAt(i).lastBet = bet
                        if (bet > highestBet)
                            lastPlayer = i
                        highestBet = bet
                    }
                    else if(bet === players.itemAt(i).balance + players.itemAt(i).lastBet) {
                        players.itemAt(i).balance = players.itemAt(i).balance + players.itemAt(i).lastBet - bet
                        bank = bank + bet - players.itemAt(i).lastBet
                        players.itemAt(i).lastBet = bet
                    }
                    else {
                        players.itemAt(i).isActive = false
                        players.itemAt(i).fold()
                        activePlayers = activePlayers - 1
                        if (activePlayers === 1)
                            if (isActive) {

                            } else {
                                win(findActivePlayer())
                            }
                    }

            }
        }
    }


    function newGame() {
        var avatars = poker.avatars()
        isActive = true
        playerBalance.visible = true
        bankStack.visible = true
        timerField.visible = true
        highestBet = 20;
        bank = 0
        lastPlayer = 2
        prelastPlayer = 2
        board = []
        turn = 1


        var xes = [0, 170, 600, 720, 600]
        var yes = [270, 70, 70, 270, 470]
        var cardInfo = poker.getCardsInfo()
        for(var i = 0; i < 5; i++) {
            players.itemAt(i).visible = true
            players.itemAt(i).ava = avatars[i]
            players.itemAt(i).x = xes[i]
            players.itemAt(i).y = yes[i]
            players.itemAt(i).isActive = true
            players.itemAt(i).close()

            players.itemAt(i).cardsuit1 = cardInfo[i * 6]
            players.itemAt(i).cardnumber1 = parseInt(cardInfo[i * 6 + 1])
            players.itemAt(i).cardsource1 = cardInfo[i * 6 + 2]

            players.itemAt(i).cardsuit2 = cardInfo[i * 6 + 3]
            players.itemAt(i).cardnumber2 = parseInt(cardInfo[i * 6 + 4])
            players.itemAt(i).cardsource2 = cardInfo[i * 6 + 5]

            players.itemAt(i).balance = 1000
            players.itemAt(i).lastBet = 0

            console.log(i)
        }
        cardsuit1 = cardInfo[30]
        cardnumber1 = cardInfo[31]
        cardsource1 = cardInfo[32]

        cardsuit2 = cardInfo[33]
        cardnumber2 = cardInfo[34]
        cardsource2 = cardInfo[35]

        balance = 1000
        lastBet = 0
        dealer = 5

        for (var i = 36; i < cardInfo.length; i++) {
            board.push(cardInfo[i]);
        }

        boardcards.getCards(board)
        boardcards.hideCards()

        turn1()

    }

    function newRound() {
        if (balance < 1) {
            lost()
            return
        }

        for (var i = 0; i < 5; i++) {
            players.itemAt(i).isActive = false
        }

        bank = 0
        board = []
        activePlayers = 1
        for (var i = 0; i < 5; i++) {
            if (players.itemAt(i).balance > 19) {
                activePlayers = activePlayers + 1
                players.itemAt(i).isActive = true
            }
        }

        if (activePlayers === 1) {
            wingame()
            return
        }

        turn = 1
        isActive = true
        highestBet = 20

        boardcards.hideCards()

        if (dealer === 5)
            dealer = 0
        else
            dealer = dealer + 1

        if (dealer === 5) {
            lastPlayer = 2
            prelastPlayer = 2
        } else if (dealer < 3) {
            lastPlayer = dealer + 3
            prelastPlayer = dealer + 3
        }

        var cardInfo = poker.getCardsInfo()

        for(var i = 0; i < 5; i++) {
            if (players.itemAt(i).isActive) {
                players.itemAt(i).close()

                players.itemAt(i).cardsuit1 = cardInfo[i * 6]
                players.itemAt(i).cardnumber1 = parseInt(cardInfo[i * 6 + 1])
                players.itemAt(i).cardsource1 = cardInfo[i * 6 + 2]

                players.itemAt(i).cardsuit2 = cardInfo[i * 6 + 3]
                players.itemAt(i).cardnumber2 = parseInt(cardInfo[i * 6 + 4])
                players.itemAt(i).cardsource2 = cardInfo[i * 6 + 5]
            }
        }

        cardsuit1 = cardInfo[30]
        cardnumber1 = cardInfo[31]
        cardsource1 = cardInfo[32]

        cardsuit2 = cardInfo[33]
        cardnumber2 = cardInfo[34]
        cardsource2 = cardInfo[35]

        for (var i = 36; i < cardInfo.length; i++) {
            board.push(cardInfo[i]);
        }

        boardcards.getCards(board)

        turn1()
    }

    function turn1() {
        if (dealer === 5) {
            makeTurn(2, 5)
        }
        else if (dealer < 3) {
            makeTurn(dealer + 3, 5)
        }
        else if (dealer === 3) {
            makeTurn(0, 5)
        }
        else {
            makeTurn(1, 5)
        }

        hud.visible = true
    }

    function continueTurn1() {
            prelastPlayer = lastPlayer
            makeTurn(0, prelastPlayer);
            if (prelastPlayer === lastPlayer) {
                console.log("turn ended")
                turn2()
            }
            else {
                makeTurn(prelastPlayer, lastPlayer)
                prelastPlayer = lastPlayer
                if (isActive) {
                    hud.visible = true
                } else {
                    continueTurn1()
                }
            }
    }

    function clearTurn() {
        highestBet = 0
        lastBet = 0
        if (dealer === 5)
            lastPlayer = 0
        else
            lastPlayer = dealer + 1
        for (var i = 0; i < 5; i++) {
            players.itemAt(i).lastBet = 0
        }
    }

    function turn2() {
        turn = 2
        clearTurn()
        boardcards.show3cards()

        if (dealer === 5) {
            makeTurn2(0, 5, 3)
        } else {
            makeTurn2(dealer + 1, 5, 3)
        }

        if (isActive)
            hud.visible = true
        else
            continueTurn2()
    }

    function continueTurn2() {
            prelastPlayer = lastPlayer
            makeTurn2(0, prelastPlayer, 3);
            if (prelastPlayer === lastPlayer) {
                console.log("turn ended")
                turn3();
            }
            else {
                makeTurn(prelastPlayer, lastPlayer)
                prelastPlayer = lastPlayer
                if (isActive) {
                    hud.visible = true
                } else {
                    continueTurn2()
                }
            }
    }

    function turn3() {
        turn = 3
        clearTurn()
        boardcards.show4card()

        if (dealer === 5) {
            makeTurn2(0, 5, 4)
        } else {
            makeTurn2(dealer + 1, 5, 4)
        }

        if (isActive)
            hud.visible = true
        else
            continueTurn3()
    }

    function continueTurn3() {
            prelastPlayer = lastPlayer
            makeTurn2(0, prelastPlayer, 4);
            if (prelastPlayer === lastPlayer) {
                console.log("turn ended")
                turn4();
            }
            else {
                makeTurn2(prelastPlayer, lastPlayer, 4)
                prelastPlayer = lastPlayer
                if (isActive) {
                    hud.visible = true
                } else {
                    continueTurn3()
                }
            }
    }

    function turn4() {
        turn = 4
        clearTurn()
        boardcards.show5card()

        if (dealer === 5) {
            makeTurn2(0, 5, 5)
        } else {
            makeTurn2(dealer + 1, 5, 5)
        }

        if (isActive)
            hud.visible = true
        else
            continueTurn4()
    }

    function continueTurn4() {
            prelastPlayer = lastPlayer
            makeTurn2(0, prelastPlayer, 5);
            if (prelastPlayer === lastPlayer) {
                console.log("turn ended")
                endGame();
            }
            else {
                makeTurn2(prelastPlayer, lastPlayer, 5)
                prelastPlayer = lastPlayer
                if (isActive) {
                    hud.visible = true
                } else {
                    continueTurn4()
                }
            }
    }

    function endGame() {
        var combinations = []
        var playerids = []

        var winner = 0
        var winnernum = 0
        var winners = []
        var winnersnum = []
        var winnercombination = 0;
        var winnerscombination = []

        for (var i = 0; i < 5; i++) {
            var suits = [players.itemAt(i).cardsuit1, players.itemAt(i).cardsuit2]
            var numbers = [players.itemAt(i).cardnumber1, players.itemAt(i).cardnumber2]
            if (players.itemAt(i).isActive === true) {
                players.itemAt(i).open()
                for (var j = 0; j < 5; j++) {
                    suits.push(boardcards.getcardsuit(j))
                    numbers.push(boardcards.getcardnumber(j))
                }
                combinations.push(poker.getCombination(suits, numbers))
                playerids.push(i)

            }
        }

        if (isActive === true) {
            var playersuits = [cardsuit1, cardsuit2]
            var playernumbers = [cardnumber1, cardnumber2]
            for (var j = 0; j < 5; j++) {
                playersuits.push(boardcards.getcardsuit(j))
                playernumbers.push(boardcards.getcardnumber(j))
            }
            combinations.push(poker.getCombination(playersuits, playernumbers))
            playerids.push(5)
        }

        winner = playerids[0]
        winnercombination = combinations[0]

        for (var i = 1; i < combinations.length; i++) {
            if (combinations[i] > winnercombination) {
                winner = playerids[i]
                winnernum = i
                winners = []
                winnercombination = combinations[i]
            } else if (combinations[i] === winnercombination && winners.length === 0) {
                winners.push(playerids[winnernum])
                winners.push(playerids[i])
                winnersnum.push(winnernum)
                winnersnum.push(i)
            } else if (combinations[i] === winnercombination) {
                winners.push(playerids[i])
                winnersnum.push(i)
            }
        }
        console.log(combinations)
        console.log(playerids)
        console.log(winners)
        console.log(winnercombination)
        console.log(winners.length)

        console.log(winner)

        var comparison = 0

        if (winners.length > 0) {
            var suits = []
            var numbers = []
            for (var i = 0; i < winners.length - 1; i++) {
                suits.push(players.itemAt(winners[i]).cardsuit1)
                numbers.push(players.itemAt(winners[i]).cardnumber1)
                suits.push(players.itemAt(winners[i]).cardsuit2)
                numbers.push(players.itemAt(winners[i]).cardnumber2)
            }

            if (winners[winners.length - 1] === 5) {
                suits.push(cardsuit1)
                suits.push(cardsuit2)
                numbers.push(cardnumber1)
                numbers.push(cardnumber2)
            }

            for (var i = 0; i < 5; i++) {
                suits.push(boardcards.getcardsuit(i))
                numbers.push(boardcards.getcardnumber(i))
            }
            comparison = poker.comparePairs(suits, numbers, winners.length)
        }

        console.log(comparison)

        if (winners.length > 0 && comparison === 0) {
            for (var i = 0; i < winners.length; i++) {
                if (winners[i] === 5) {
                    balance = balance + (bank / winners.length)
                    timer.running = true
                } else {
                    players.itemAt(winners[i]).balance = players.itemAt(winners[i]).balance + (bank / winners.length)
                    timer.running = true
                }

            }
        } else if (winners.length > 0) {

                if (winners[comparison] === 5) {
                    balance = balance + bank
                    timer.running = true
                }
                else {
                    players.itemAt(winners[comparison]).balance = players.itemAt(winners[comparison]).balance + bank
                    timer.running = true
                }

        } else {
            if (winner === 5) {
                balance = balance + bank
                timer.running = true
            }
            else {
                players.itemAt(winner).balance = players.itemAt(winner).balance + bank
                timer.running = true
            }
        }


    }

    TextField {
        id: timerField
        readOnly: true
        Layout.fillWidth: true
        horizontalAlignment: TextInput.AlignHCenter
        property int countdown: 15
        visible: false
        x: 200
        y: 10
        Timer {
            id: timer
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                timerField.text = "Time: " + timerField.countdown
                timerField.countdown--;
                if (timerField.countdown <= 0) {
                    timer.running = false
                    timerField.countdown = 8
                    timerField.text = ""
                    newRound()
                }
            }

        }

    }

    Image {
        id: pokerTable
        anchors.centerIn: parent
        source: "qrc:/new/prefix1/189-1898993_poker-table-png-poker-table-online.png"
    }

    Button {
        id: newGameButton
        anchors.centerIn: parent
        text: "New game"
        onClicked: {
            newGameButton.visible = false
            newGame()
        }
    }

    Repeater {
        id: players
        model: 5
        Player {
            visible: false
        }
    }

    RowLayout {
        x: 170
        y: 460
        Image {
            id: card1
            source: cardsource1
            Layout.preferredHeight: 144
            Layout.preferredWidth: 96
        }
        Image {
            id: card2
            source: cardsource2
            Layout.preferredHeight: 144
            Layout.preferredWidth: 96
        }
    }

    ColumnLayout {
        id: playerBalance
        visible: false
        x: 10
        y: 460
        Text {
            color: "white"
            text: "Balance: " + balance
        }
        Text {
            color: "white"
            text: "Bet: " + lastBet
        }
    }

    ColumnLayout {
        id: hud
        x: 400
        y: 460
        visible: false

        TextField {
            id: textField
            Layout.preferredHeight: 30
            Layout.preferredWidth: 150
            validator: IntValidator {
                top: balance + lastBet
                bottom: highestBet
            }
        }

        spacing: 1

        Button {
            id: raiseButton
            onClicked: {
                if (textField.text >= highestBet && textField.text != "") {
                    hud.visible = false
                    highestBet = parseInt(textField.text)
                    balance = balance - parseInt(textField.text) + lastBet
                    lastBet = parseInt(textField.text)
                    lastPlayer = 5
                    bank = bank + lastBet
                    textField.text = ""
                    if (turn === 1) {
                        continueTurn1()
                    }
                    else if (turn === 2) {
                        continueTurn2()
                    }
                    else if (turn === 3) {
                        continueTurn3()
                    }
                    else if (turn === 4) {
                        continueTurn4()
                    }
                }

            }
            background: Rectangle {
                color: "red"
            }

            Layout.preferredHeight: 30
            Layout.preferredWidth: 150

            text: "Raise"
        }

        Button {
            id: callButton
            onClicked: {
                hud.visible = false
                if (balance - highestBet + lastBet < 1) {
                    balance = 0
                } else {
                    balance = balance - highestBet + lastBet
                }
                lastBet = highestBet
                bank = bank + highestBet
                if (turn === 1) {
                    if (lastPlayer === 5 && dealer === 5)
                        turn2()
                    else
                        continueTurn1()
                }
                else if (turn === 2) {
                    if (lastPlayer === 5 && dealer === 5) {
                        turn3()
                    } else {
                        continueTurn2()
                    }
                }
                else if (turn === 3) {
                    if (lastPlayer === 5 && dealer === 5) {
                        turn3()
                    } else {
                        continueTurn3()
                    }
                }
                else if (turn === 4) {
                    if (lastPlayer === 5 && dealer === 5) {
                        turn4()
                    } else {
                        continueTurn4()
                    }
                }

            }
            background: Rectangle {
                color: "red"
            }

            Layout.preferredHeight: 30
            Layout.preferredWidth: 150

            text: "Call"
        }

        Button {
            id: foldButton
            onClicked: {
                hud.visible = false
                isActive = false
                activePlayers = activePlayers - 1
                continueTurn1()
            }

            Layout.preferredHeight: 30
            Layout.preferredWidth: 150
            background: Rectangle {
                color: "red"
            }
            text: "Fold"
        }
    }

    Boardcards {
        id: boardcards
        anchors.centerIn: parent
    }

    Text {
        id: bankStack
        text: "Bank: " + bank
        x: 450
        y: 375
        color: "white"
        visible: false
    }

    Dialog {
        id: loseDialog
        anchors.centerIn: parent
        height: 150
        width: 200
        title: "You lost!"

        Button {
            id: startnewgame
            x: 50
            y: 50
            onClicked: {
                loseDialog.visible = false
                newGame()
            }
            text: "New Game"

        }
    }

    Dialog {
        id: winDialog
        anchors.centerIn: parent
        height: 150
        width: 200
        title: "You won!"

        Button {
            id: startgame
            x: 50
            y: 50
            onClicked: {
                winDialog.visible = false
                newGame()
            }
            text: "New Game"

        }
    }
}
