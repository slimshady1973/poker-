import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

ColumnLayout {
    x: 400
    y: 460
    visible: false

    property int balance: 1000

    signal raiseBet(var value)
    signal check()
    signal fold()
    signal call()

    TextField {
        id: textField
        Layout.preferredHeight: 40
        Layout.preferredWidth: 100
        validator: IntValidator {
            top: balance
            bottom: 1
        }
    }

    spacing: 1

    Button {
        id: raiseButton
        onClicked: {
            raiseBet(textField.text)
            balance = balance - textField.text

        }
        background: Rectangle {
            color: "red"
        }

        Layout.preferredHeight: 40
        Layout.preferredWidth: 100

        text: "Raise"
    }

    Button {
        id: callButton
        onClicked: call()
        background: Rectangle {
            color: "red"
        }

        Layout.preferredHeight: 40
        Layout.preferredWidth: 100

        text: "Call"
    }

    Button {
        id: checkButton
        onClicked: check()
        Layout.preferredHeight: 40
        Layout.preferredWidth: 100
        background: Rectangle {
            color: "red"
        }
        text: "Check"
    }

    Button {
        id: foldButton
        onClicked: fold()
        Layout.preferredHeight: 40
        Layout.preferredWidth: 100
        background: Rectangle {
            color: "red"
        }
        text: "Fold"
    }
}
