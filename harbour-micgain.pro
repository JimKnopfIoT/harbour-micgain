# harbour-micgain — persistent microphone gain fix for quiet camera
# recordings on Sailfish OS (Xperia 10 III class devices).
#
# One Silica page with a slider. Applying opens a sub-second PulseAudio
# record stream under the application name "Advanced Camera" and sets its
# volume; module-stream-restore-nemo persists the value under that name and
# re-applies it to every future recording of the real camera app.

TARGET = harbour-micgain

CONFIG += sailfishapp
QT += core qml quick

CONFIG += link_pkgconfig
PKGCONFIG += sailfishapp libpulse

isEmpty(VERSION): VERSION = 0.1.0
isEmpty(RELEASE): RELEASE = 1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_RELEASE=\\\"$$RELEASE\\\"

HEADERS += \
    src/micgain.h

SOURCES += \
    src/harbour-micgain.cpp \
    src/micgain.cpp

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# English source strings + German (du-Form).
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-micgain-de.ts
lupdate_only {
    SOURCES += qml/*.qml qml/pages/*.qml qml/cover/*.qml
}

DISTFILES += \
    qml/harbour-micgain.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/AboutPage.qml \
    rpm/harbour-micgain.spec \
    harbour-micgain.desktop \
    translations/*.ts
