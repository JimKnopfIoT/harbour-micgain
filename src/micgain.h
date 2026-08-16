/*
  harbour-micgain — MicGain
  Copyright (C) 2026  harbour-micgain contributors — GPLv3 or later.

  Reads and writes the persistent recording volume PulseAudio keeps for the
  stream restore id "source-output-by-application-name:Advanced Camera".

  Sailfish's module-stream-restore-nemo does not speak the standard
  ext-stream-restore protocol, so the database cannot be edited directly.
  Instead, both reading and writing briefly open a real record stream whose
  application.name is "Advanced Camera": on connect PulseAudio applies the
  stored volume (that is the read), and setting the stream's volume makes the
  module persist the new value under the shared id (that is the write). The
  microphone is therefore active for a fraction of a second per operation;
  no audio data is read or kept.
*/
#ifndef MICGAIN_H
#define MICGAIN_H

#include <QHash>
#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariant>

class MicGain : public QObject
{
    Q_OBJECT
    // The application name whose stored volume is read/written. Each name
    // has its own independent entry in PulseAudio's stream-restore database.
    Q_PROPERTY(QString target READ target WRITE setTarget NOTIFY changed)
    // Last value read back from PulseAudio for the current target, in
    // percent; 0 = not yet known.
    Q_PROPERTY(int currentPercent READ currentPercent NOTIFY changed)
    Q_PROPERTY(bool busy READ busy NOTIFY changed)
    // Human-readable error of the last operation, "" if it succeeded.
    Q_PROPERTY(QString error READ error NOTIFY changed)

public:
    explicit MicGain(QObject *parent = nullptr);

    QString target() const { return m_target; }
    void setTarget(const QString &name);
    int currentPercent() const { return m_percent; }
    bool busy() const { return m_busy; }
    QString error() const { return m_error; }

    Q_INVOKABLE void refresh();          // read the stored value
    Q_INVOKABLE void apply(int percent); // set and persist a new value

    // Application names that already have a recording entry in PulseAudio's
    // stream-restore database, i.e. every app that has ever recorded on this
    // device. Parsed straight from the on-disk database file.
    Q_INVOKABLE QStringList scanTargets() const;

    // Launcher icon for a stream's application name, matched against the
    // Name= entries of the installed .desktop files. Returns the Icon= value
    // (a theme icon name, or an absolute path) or "" when no app matches —
    // the QML side supplies a generic fallback then.
    Q_INVOKABLE QString iconFor(const QString &appName) const;

    // All launcher-visible installed apps as {name, icon} maps, sorted by
    // name. Used by the picker: selecting one creates the gain entry under
    // that app's name proactively — the value takes effect with the app's
    // first recording.
    Q_INVOKABLE QVariantList installedApps() const;

signals:
    void changed();
    // Internal: emitted from the worker thread, queued into the GUI thread.
    void workerDone(int percent, const QString &error);

private slots:
    void onWorkerDone(int percent, const QString &error);

private:
    void start(int setPercent); // setPercent < 0 = read only

    QString m_target = QStringLiteral("Advanced Camera");
    int m_percent = 0;
    bool m_busy = false;
    QString m_error;
    void ensureDesktopIndex() const;

    // Built lazily from /usr/share/applications on first use:
    // normalized desktop Name -> Icon value, plus the display list.
    mutable QHash<QString, QString> m_iconIndex;
    mutable QVariantList m_installedApps;
    mutable bool m_iconIndexBuilt = false;
};

#endif // MICGAIN_H
