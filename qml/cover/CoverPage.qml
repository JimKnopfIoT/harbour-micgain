/*
  harbour-micgain — CoverPage.qml
  Copyright (C) 2026  harbour-micgain contributors — GPLv3 or later.
*/
import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        anchors.centerIn: parent
        spacing: Theme.paddingMedium

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(implicitWidth, parent.parent.width - 2 * Theme.paddingLarge)
            truncationMode: TruncationMode.Fade
            text: micgain.target
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.secondaryColor
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            //: %1 is the stored gain percentage
            text: micgain.currentPercent > 0
                  ? qsTr("%1 %").arg(micgain.currentPercent) : "–"
            font.pixelSize: Theme.fontSizeHuge
            color: Theme.highlightColor
        }
    }
}
