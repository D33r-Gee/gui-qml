// Copyright (c) 2023 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../controls"
import "../../components"

Item {
    property alias navRightDetail: snapshotSwipe.navRightDetail
    property alias navMiddleDetail: snapshotSwipe.navMiddleDetail
    property alias navLeftDetail: snapshotSwipe.navLeftDetail
    property alias showHeader: snapshotSwipe.showHeader
    SwipeView {
        id: snapshotSwipe
        property alias navRightDetail: snapshot_settings.navRightDetail
        property alias navMiddleDetail: snapshot_settings.navMiddleDetail
        property alias navLeftDetail: snapshot_settings.navLeftDetail
        property alias showHeader: snapshot_settings.showHeader
        anchors.fill: parent
        interactive: false
        orientation: Qt.Horizontal
        InformationPage {
            id: snapshot_settings
            background: null
            clip: true
            bannerActive: false
            bold: true
            headerText: qsTr("Snapshot settings")
            headerMargin: 0
            detailActive: true
            detailItem: SnapshotSettings {}
        }
    }
}