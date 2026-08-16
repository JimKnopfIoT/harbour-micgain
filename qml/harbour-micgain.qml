/*
  harbour-micgain — application root.
  Copyright (C) 2026  harbour-micgain contributors — GPLv3 or later.
*/
import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow {
    id: app

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
}
