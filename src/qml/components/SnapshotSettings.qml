// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../controls"

ColumnLayout {
    Header {
        headerBold: true
        center: false
        header: qsTr("UTXO Snapshot")
        headerSize: 24
        description: qsTr("The snapshot is a copy of the blockchain at a certain point in time. It is used to speed up the initial blockchain download.")
        descriptionSize: 15
        Layout.bottomMargin: 10
    }
    Separator { Layout.fillWidth: true }
    Setting {
        Layout.fillWidth: true
        header: qsTr("Load UTXO snapshot file")
        actionItem: OptionSwitch {
            checked: optionsModel.loadUtxo
            onToggled: optionsModel.loadUtxo = checked
            onCheckedChanged: {
                if (checked == false) {
                    defaultSnapshot.state = "DISABLED"
                } else {
                    defaultSnapshot.state = "FILLED"
                }
            }
        }
        onClicked: {
          loadedItem.toggle()
          loadedItem.toggled()
        }
    }
    Separator { Layout.fillWidth: true }
    Setting {
        id: defaultSnapshot
        Layout.fillWidth: true
        header: qsTr("Snapshot File Location")
        actionItem: TextField {
            placeholderText: optionsModel.getDefaultDataDirectory
            text: ""
            onEditingFinished: {
                optionsModel.setDefaultSnapshotDirectory(text)
                defaultSnapshot.forceActiveFocus()
            }
        }
        onClicked: loadedItem.forceActiveFocus()
    }
}