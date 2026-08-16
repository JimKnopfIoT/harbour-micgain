/*
  harbour-micgain — main.cpp
  Copyright (C) 2026  harbour-micgain contributors — GPLv3 or later.

  Persistent microphone gain fix for the far too quiet camera recordings on
  Sailfish OS ports whose Android audio HAL configures a very low input gain
  (seen on the Xperia 10 III). All logic lives in MicGain (src/micgain.h).
*/
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickView>
#include <QScopedPointer>

#include <sailfishapp.h>

#include "micgain.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setApplicationVersion(QStringLiteral(APP_VERSION));

    QScopedPointer<QQuickView> view(SailfishApp::createView());

    MicGain gain;
    view->rootContext()->setContextProperty(QStringLiteral("micgain"), &gain);

    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return app->exec();
}
