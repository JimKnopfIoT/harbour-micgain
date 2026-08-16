/*
  harbour-micgain — AboutPage.qml
  Copyright (C) 2026  harbour-micgain contributors — GPLv3 or later.
*/
import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("About") }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Mic Gain"
                font.pixelSize: Theme.fontSizeExtraLarge
                color: Theme.highlightColor
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                //: %1 is the version number
                text: qsTr("Version %1").arg(Qt.application.version)
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
            }

            SectionHeader { text: qsTr("The problem") }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                text: qsTr("Recordings made with camera and audio apps such as "
                    + "Advanced Camera or Audio Recorder are far too quiet on "
                    + "some Sailfish OS devices (measured on the Xperia 10 "
                    + "III): speech peaks 20–25 dB below a normal level, so "
                    + "it is barely audible on playback.")
            }

            SectionHeader { text: qsTr("The cause") }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                text: qsTr("The apps are innocent: their files contain "
                    + "exactly the audio PulseAudio delivers, and every "
                    + "volume inside PulseAudio sits at 100 %. The signal is "
                    + "already quiet when it arrives from below — the Android "
                    + "audio HAL, the vendor driver layer Sailfish OS reuses "
                    + "for the hardware, is configured with a much too low "
                    + "microphone input gain for the camcorder path. Fixing "
                    + "it properly would mean changing vendor audio "
                    + "configuration files on the device.")
            }

            SectionHeader { text: qsTr("What this app does") }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                text: qsTr("It compensates with digital gain in PulseAudio: "
                    + "the chosen recording volume is stored in PulseAudio's "
                    + "per-app memory (stream-restore) under the selected "
                    + "app's stream name, and is then applied automatically "
                    + "to every future recording of that app — this app does "
                    + "not need to be running for that. To write the entry, "
                    + "it briefly opens a microphone stream under that name; "
                    + "the microphone is active for a fraction of a second "
                    + "and nothing is recorded or stored.")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: qsTr("Trade-off of digital gain: the noise floor rises "
                    + "by the same amount, and values above roughly 400 % can "
                    + "clip loud sounds. 300 % (+9.5 dB) is a good starting "
                    + "point.")
            }

            SectionHeader { text: qsTr("License") }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: qsTr("GNU GPLv3 or later. No warranty — the change can "
                    + "always be undone via “Reset to 100 %”.")
            }

            Item { width: 1; height: Theme.paddingLarge }
        }

        VerticalScrollDecorator { }
    }
}
