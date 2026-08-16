/*
  harbour-micgain — AppPickerPage.qml
  Copyright (C) 2026  harbour-micgain contributors — GPLv3 or later.

  All launcher-visible installed apps; tapping one hands its name back to
  MainPage, which creates the gain entry under that name proactively. No app
  is launched for this — the stored value simply takes effect the first time
  the chosen app records.
*/
import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // MainPage sets this; called with the chosen app name before popping.
    property var onPicked

    readonly property var allApps: micgain.installedApps()
    property string filter: ""

    function matches(name) {
        return filter === ""
            || name.toLowerCase().indexOf(filter.toLowerCase()) >= 0
    }

    SilicaListView {
        id: list
        anchors.fill: parent

        header: Column {
            width: page.width

            PageHeader { title: qsTr("Select app") }

            SearchField {
                id: search
                width: parent.width
                placeholderText: qsTr("Search")
                onTextChanged: page.filter = text.trim()
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: qsTr("The gain entry is created under the app's name "
                    + "right away and takes effect with the app's first "
                    + "recording. After that recording the app also shows up "
                    + "in the main list by itself.")
            }

            Item { width: 1; height: Theme.paddingMedium }
        }

        model: page.allApps

        delegate: BackgroundItem {
            width: page.width
            height: page.matches(modelData.name) ? Theme.itemSizeSmall : 0
            visible: page.matches(modelData.name)
            clip: true

            onClicked: {
                if (page.onPicked)
                    page.onPicked(modelData.name)
                pageStack.pop()
            }

            Image {
                id: appIcon
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
                source: modelData.icon === "" ? "image://theme/icon-m-other"
                      : modelData.icon.charAt(0) === "/"
                        ? "file://" + modelData.icon
                        : "image://theme/" + modelData.icon
            }
            Label {
                anchors {
                    left: appIcon.right
                    leftMargin: Theme.paddingLarge
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                truncationMode: TruncationMode.Fade
                text: modelData.name
            }
        }

        VerticalScrollDecorator { }
    }
}
