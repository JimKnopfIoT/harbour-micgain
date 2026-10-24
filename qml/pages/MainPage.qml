/*
  harbour-micgain — MainPage.qml
  Copyright (C) 2026  harbour-micgain contributors — GPLv3 or later.

  App picker + one slider. The picker lists every app that has ever recorded
  on this device (scanned from PulseAudio's stream-restore database) plus a
  free-text entry for anything else. The slider value is written only via the
  Apply button (micgain.apply) for the selected app — a stray tap on the
  slider while scrolling must not change anything. The stored value is read
  back after every switch and apply, so the "Stored" line always shows the
  truth.

  Qt apps (QtMultimedia) record as "QtPulseAudio:<pid>", so every run leaves
  a new entry that only ever matches a process with that same pid again.
  Those are hidden from the list — a gain set on one would hit a random
  later process — but "Reset all" still covers them.
*/
import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // Apps every device of this class should offer even before their first
    // recording; the scan result is merged in on top.
    readonly property var curated: ["Advanced Camera", "Audio Recorder"]
    property var apps: []
    property int hiddenCount: 0

    function isPerProcess(name) {
        return /^QtPulseAudio:[0-9]+$/.test(name)
    }

    function rescan() {
        var found = micgain.scanTargets()
        var merged = curated.slice()
        var hidden = 0
        for (var i = 0; i < found.length; i++) {
            if (isPerProcess(found[i]))
                hidden++
            else if (merged.indexOf(found[i]) < 0)
                merged.push(found[i])
        }
        apps = merged
        hiddenCount = hidden
    }

    function dbText(pct) {
        // 20*log10(pct/100), one decimal.
        var db = 20 * Math.log(pct / 100) / Math.LN10
        return (db >= 0 ? "+" : "") + db.toFixed(1)
    }

    function selectTarget(name) {
        // Apps picked from the installed-apps page are not necessarily in
        // the recorded-apps scan yet — show them in the list right away so
        // the check mark has a home.
        if (apps.indexOf(name) < 0) {
            var a = apps.slice()
            a.push(name)
            apps = a
        }
        micgain.target = name
        micgain.refresh()
    }

    Connections {
        target: micgain
        onChanged: {
            // Follow the read-back value unless the user is mid-drag. After
            // an apply this is a no-op (the value matches); after a target
            // switch it seeds the slider with that app's stored gain.
            if (!micgain.busy && micgain.currentPercent > 0
                    && !gainSlider.down)
                gainSlider.value = micgain.currentPercent
        }
    }

    RemorsePopup { id: remorse }

    Component.onCompleted: {
        rescan()
        micgain.refresh()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Rescan apps")
                onClicked: page.rescan()
            }
            MenuItem {
                text: qsTr("Reset all apps to 100 %")
                enabled: !micgain.busy
                onClicked: remorse.execute(qsTr("Resetting all apps"),
                                           function() { micgain.resetAll() })
            }
            MenuItem {
                text: qsTr("Reset to 100 % (system default)")
                enabled: !micgain.busy
                onClicked: {
                    gainSlider.value = 100
                    micgain.apply(100)
                }
            }
            MenuItem {
                text: qsTr("Set recommended 300 %")
                enabled: !micgain.busy
                onClicked: {
                    gainSlider.value = 300
                    micgain.apply(300)
                }
            }
        }

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("Microphone gain") }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: qsTr("Boosts the recording volume of the selected app. "
                    + "Each app keeps its own value; it is stored permanently "
                    + "and applied to every future recording. Details: pull "
                    + "down → About.")
            }

            Slider {
                id: gainSlider
                width: parent.width
                label: micgain.target
                //: %1 is the gain percentage, %2 the equivalent in decibels
                valueText: qsTr("%1 % (%2 dB)")
                               .arg(Math.round(sliderValue))
                               .arg(dbText(Math.round(sliderValue)))
                minimumValue: 50
                maximumValue: 600
                stepSize: 25
                value: 300
                enabled: !micgain.busy
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: %1 is the gain percentage
                text: qsTr("Apply %1 %").arg(Math.round(gainSlider.sliderValue))
                enabled: !micgain.busy
                         && Math.round(gainSlider.sliderValue) !== micgain.currentPercent
                onClicked: micgain.apply(Math.round(gainSlider.sliderValue))
            }

            Item {
                width: parent.width
                height: storedItem.height

                DetailItem {
                    id: storedItem
                    label: qsTr("Stored")
                    value: micgain.currentPercent > 0
                           //: %1 is the stored gain percentage
                           ? qsTr("%1 %").arg(micgain.currentPercent)
                           : "–"
                }
                BusyIndicator {
                    anchors {
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    size: BusyIndicatorSize.ExtraSmall
                    running: micgain.busy
                }
            }

            ProgressBar {
                width: parent.width
                visible: micgain.resetTotal > 0
                minimumValue: 0
                maximumValue: Math.max(1, micgain.resetTotal)
                value: micgain.resetDone
                //: %1 entries done, %2 entries in total
                label: qsTr("Resetting %1 of %2").arg(micgain.resetDone)
                                                 .arg(micgain.resetTotal)
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                visible: micgain.error !== ""
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.errorColor
                text: micgain.error
            }

            // --- app picker ------------------------------------------------
            SectionHeader { text: qsTr("App") }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: qsTr("Important: only apps that have already used the "
                    + "microphone at least once are listed here — the system "
                    + "learns about an app the moment it records for the "
                    + "first time. If an app is missing, make one short "
                    + "recording with it and pull down to rescan, or enter "
                    + "its stream name below.")
            }

            Repeater {
                model: page.apps

                delegate: BackgroundItem {
                    width: page.width
                    height: Theme.itemSizeSmall
                    onClicked: page.selectTarget(modelData)

                    // Icon= value from the matching .desktop file: a theme
                    // icon name or an absolute path; "" when nothing matched
                    // (technical streams like "WEBRTC VoiceEngine").
                    readonly property string appIcon: micgain.iconFor(modelData)

                    Image {
                        id: launcherIcon
                        anchors {
                            left: parent.left
                            leftMargin: Theme.horizontalPageMargin
                            verticalCenter: parent.verticalCenter
                        }
                        width: Theme.iconSizeMedium
                        height: Theme.iconSizeMedium
                        sourceSize.width: width
                        sourceSize.height: height
                        fillMode: Image.PreserveAspectFit
                        source: appIcon === "" ? "image://theme/icon-m-mic"
                              : appIcon.charAt(0) === "/" ? "file://" + appIcon
                              : "image://theme/" + appIcon
                    }
                    Label {
                        anchors {
                            left: launcherIcon.right
                            leftMargin: Theme.paddingLarge
                            right: check.left
                            rightMargin: Theme.paddingMedium
                            verticalCenter: parent.verticalCenter
                        }
                        truncationMode: TruncationMode.Fade
                        text: modelData
                        color: micgain.target === modelData
                               ? Theme.highlightColor : Theme.primaryColor
                    }
                    Icon {
                        id: check
                        anchors {
                            right: parent.right
                            rightMargin: Theme.horizontalPageMargin
                            verticalCenter: parent.verticalCenter
                        }
                        source: "image://theme/icon-s-accept"
                        visible: micgain.target === modelData
                    }
                }
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                visible: page.hiddenCount > 0
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                //: %1 is the number of hidden entries
                text: qsTr("%1 temporary entries (QtPulseAudio:…) are hidden: "
                    + "Qt apps get a new one each time they start, so a gain "
                    + "set there would hit a random later process. “Reset all "
                    + "apps to 100 %” includes them.").arg(page.hiddenCount)
            }

            BackgroundItem {
                width: page.width
                height: Theme.itemSizeSmall
                onClicked: pageStack.push(
                    Qt.resolvedUrl("AppPickerPage.qml"),
                    { onPicked: function(name) { page.selectTarget(name) } })

                Icon {
                    id: addIcon
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    source: "image://theme/icon-m-add"
                }
                Label {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                            + Theme.iconSizeMedium + Theme.paddingLarge
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    truncationMode: TruncationMode.Fade
                    text: qsTr("Add another app…")
                    color: Theme.highlightColor
                }
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: qsTr("Values above 400 % can distort loud sounds; "
                    + "100 % is the (too quiet) system default. Applying "
                    + "opens the microphone for a fraction of a second; "
                    + "nothing is recorded.")
            }

            Item { width: 1; height: Theme.paddingLarge }
        }

        VerticalScrollDecorator { }
    }
}
