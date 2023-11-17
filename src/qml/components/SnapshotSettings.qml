// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
// import QtQuick.Dialogs 1.0

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
        id: defaultSnapshot
        Layout.fillWidth: true
        header: qsTr("Default Snapshot File Location")
        actionItem: TextField {
            text: ""// optionsModel.getDefaultDataDirectory
            onEditingFinished: {
                console.log("Editing finished. New directory: " + text);
                optionsModel.setDefaultSnapshotDirectory(text)
                console.log("Default snapshot directory set to: " + optionsModel.getDefaultDataDirectory);
                defaultSnapshot.forceActiveFocus()
            }
        }
        onClicked: loadedItem.forceActiveFocus()
    }
    Separator { Layout.fillWidth: true }
    Setting {
        id: customSnapshot
        Layout.fillWidth: true
        header: qsTr("Default Snapshot File Location")
        actionItem: Button {
            text: qsTr("Browse...")
            onClicked: {
                var dialog = FileDialog();
                dialog.fileMode = FileDialog.Directory
                dialog.setDirectory(optionsModel.getDefaultDataDirectory);
                dialog.fileSelected.connect(function(selectedDirectory) {
                console.log("Selected directory: " + selectedDirectory);
                optionsModel.setDefaultSnapshotDirectory(selectedDirectory);
                console.log("Default snapshot directory set to: " + optionsModel.getDefaultDataDirectory);
                defaultSnapshot.forceActiveFocus();
                });
                dialog.exec();
            }
        }
        onClicked: loadedItem.forceActiveFocus()
    }
}