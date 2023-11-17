// Copyright (c) 2022 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"
import "../settings"

Page {
    background: null
    clip: true
    SwipeView {
        id: storages
        anchors.fill: parent
        interactive: false
        orientation: Qt.Vertical
        InformationPage {
            navLeftDetail: NavButton {
                iconSource: "image://images/caret-left"
                text: qsTr("Back")
                onClicked: swipeView.decrementCurrentIndex()
            }
            bannerActive: false
            bold: true
            headerText: qsTr("Storage")
            headerMargin: 0
            description: qsTr("Data retrieved from the Bitcoin network is stored on your device.\nYou must have %1GB of storage available.").arg(
                chainModel.assumedBlockchainSize + chainModel.assumedChainstateSize)
            descriptionMargin: 10
            detailActive: true
            detailItem: ColumnLayout {
                spacing: 0
                StorageOptions {
                    customStorage: advancedStorage.loadedDetailItem.customStorage
                    customStorageAmount: advancedStorage.loadedDetailItem.customStorageAmount
                    Layout.maximumWidth: 450
                    Layout.alignment: Qt.AlignCenter
                }
                TextButton {
                    Layout.topMargin: 10
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("Detailed settings")
                    onClicked: storages.incrementCurrentIndex()
                }
            }
            buttonText: qsTr("Next")
            buttonMargin: 20
        }
        SettingsStorage {
            id: advancedStorage
            navRightDetail: NavButton {
                text: qsTr("Done")
                onClicked: {
                    storages.decrementCurrentIndex()
                }
            }
        }
    }
}
