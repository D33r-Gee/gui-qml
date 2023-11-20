// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"

Item {
    property alias navRightDetail: utxoSwipe.navRightDetail
    property alias navMiddleDetail: utxoSwipe.navMiddleDetail
    property alias navLeftDetail: utxoSwipe.navLeftDetail
    property alias showHeader: utxoSwipe.showHeader
    SwipeView {
        id: utxoSwipe
        property alias navRightDetail: utxo_settings.navRightDetail
        property alias navMiddleDetail: utxo_settings.navMiddleDetail
        property alias navLeftDetail: utxo_settings.navLeftDetail
        property alias showHeader: utxo_settings.showHeader
        anchors.fill: parent
        interactive: false
        orientation: Qt.Horizontal
        InformationPage {
            id: utxo_settings
            background: null
            clip: true
            bannerActive: false
            bold: true
            headerText: qsTr("Utxo settings")
            headerMargin: 0
            detailActive: true
            detailItem: UtxoLoad {}
        }
    }
}