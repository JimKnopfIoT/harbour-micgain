/*
  harbour-micgain — MicGain
  Copyright (C) 2026  harbour-micgain contributors — GPLv3 or later.
*/
#include "micgain.h"

#include <cstring>
#include <thread>

#include <QDir>
#include <QFile>

#include <pulse/pulseaudio.h>

namespace {

struct Ctx {
    pa_threaded_mainloop *ml = nullptr;
    pa_context *ctx = nullptr;
    pa_stream *stream = nullptr;
    int readPercent = -1;
    bool opOk = false;
};

void ctxState(pa_context *, void *ud)
{
    pa_threaded_mainloop_signal(static_cast<pa_threaded_mainloop *>(ud), 0);
}

void streamState(pa_stream *, void *ud)
{
    pa_threaded_mainloop_signal(static_cast<pa_threaded_mainloop *>(ud), 0);
}

void infoCb(pa_context *, const pa_source_output_info *i, int eol, void *ud)
{
    Ctx *c = static_cast<Ctx *>(ud);
    if (eol) {
        pa_threaded_mainloop_signal(c->ml, 0);
        return;
    }
    if (i->volume.channels > 0)
        c->readPercent =
            (int)((i->volume.values[0] * 100.0 / PA_VOLUME_NORM) + 0.5);
}

void successCb(pa_context *, int success, void *ud)
{
    Ctx *c = static_cast<Ctx *>(ud);
    c->opOk = success != 0;
    pa_threaded_mainloop_signal(c->ml, 0);
}

void waitOp(Ctx &c, pa_operation *o)
{
    if (!o)
        return;
    while (pa_operation_get_state(o) == PA_OPERATION_RUNNING)
        pa_threaded_mainloop_wait(c.ml);
    pa_operation_unref(o);
}

void teardown(Ctx &c, bool locked)
{
    if (!c.ml)
        return;
    if (!locked)
        pa_threaded_mainloop_lock(c.ml);
    if (c.stream) {
        pa_stream_disconnect(c.stream);
        pa_stream_unref(c.stream);
    }
    if (c.ctx) {
        pa_context_disconnect(c.ctx);
        pa_context_unref(c.ctx);
    }
    pa_threaded_mainloop_unlock(c.ml);
    pa_threaded_mainloop_stop(c.ml);
    pa_threaded_mainloop_free(c.ml);
    c.ml = nullptr;
}

// Blocking sequence, runs on a worker thread. Returns the read-back percent
// (after setting, if setPercent >= 0) or -1 with *error filled in.
// appName must match the target app's stream name byte for byte, spaces
// included — the stream restore id is keyed on it.
int runPulse(const QByteArray &appName, int setPercent, QString *error)
{
    Ctx c;
    c.ml = pa_threaded_mainloop_new();

    pa_proplist *pl = pa_proplist_new();
    pa_proplist_sets(pl, PA_PROP_APPLICATION_NAME, appName.constData());
    c.ctx = pa_context_new_with_proplist(pa_threaded_mainloop_get_api(c.ml),
                                         appName.constData(), pl);
    pa_context_set_state_callback(c.ctx, ctxState, c.ml);

    pa_threaded_mainloop_start(c.ml);
    pa_threaded_mainloop_lock(c.ml);

    if (pa_context_connect(c.ctx, nullptr, PA_CONTEXT_NOFLAGS, nullptr) < 0) {
        *error = QStringLiteral("PulseAudio: %1")
                     .arg(pa_strerror(pa_context_errno(c.ctx)));
        pa_proplist_free(pl);
        teardown(c, true);
        return -1;
    }
    for (;;) {
        pa_context_state_t st = pa_context_get_state(c.ctx);
        if (st == PA_CONTEXT_READY)
            break;
        if (!PA_CONTEXT_IS_GOOD(st)) {
            *error = QStringLiteral("PulseAudio: %1")
                         .arg(pa_strerror(pa_context_errno(c.ctx)));
            pa_proplist_free(pl);
            teardown(c, true);
            return -1;
        }
        pa_threaded_mainloop_wait(c.ml);
    }

    // Mirror the camera's own stream format; the format does not matter for
    // the volume, only the application name does.
    pa_sample_spec spec;
    spec.format = PA_SAMPLE_S16LE;
    spec.rate = 48000;
    spec.channels = 1;
    c.stream = pa_stream_new_with_proplist(c.ctx, "Record Stream", &spec,
                                           nullptr, pl);
    pa_proplist_free(pl);
    pa_stream_set_state_callback(c.stream, streamState, c.ml);

    pa_buffer_attr attr;
    memset(&attr, 0xff, sizeof(attr));
    attr.fragsize = 960;
    // nullptr device: the default source; Sailfish's routing policy puts
    // record streams on the active input anyway, and the restore entry is
    // keyed by name, not by device.
    if (pa_stream_connect_record(c.stream, nullptr, &attr,
                                 PA_STREAM_NOFLAGS) < 0) {
        *error = QStringLiteral("PulseAudio: %1")
                     .arg(pa_strerror(pa_context_errno(c.ctx)));
        teardown(c, true);
        return -1;
    }
    for (;;) {
        pa_stream_state_t st = pa_stream_get_state(c.stream);
        if (st == PA_STREAM_READY)
            break;
        if (!PA_STREAM_IS_GOOD(st)) {
            *error = QStringLiteral("PulseAudio: %1")
                         .arg(pa_strerror(pa_context_errno(c.ctx)));
            teardown(c, true);
            return -1;
        }
        pa_threaded_mainloop_wait(c.ml);
    }

    uint32_t idx = pa_stream_get_index(c.stream);

    if (setPercent >= 0) {
        pa_cvolume v;
        pa_cvolume_init(&v);
        pa_cvolume_set(&v, 1,
                       (pa_volume_t)(PA_VOLUME_NORM * (double)setPercent / 100.0));
        waitOp(c, pa_context_set_source_output_volume(c.ctx, idx, &v,
                                                      successCb, &c));
        if (!c.opOk) {
            *error = QStringLiteral("PulseAudio: setting the volume failed");
            teardown(c, true);
            return -1;
        }
    }

    waitOp(c, pa_context_get_source_output_info(c.ctx, idx, infoCb, &c));
    int result = c.readPercent;
    teardown(c, true);
    if (result < 0)
        *error = QStringLiteral("PulseAudio: reading the volume failed");
    return result;
}

} // namespace

MicGain::MicGain(QObject *parent)
    : QObject(parent)
{
    // The worker emits from its own thread; the queued connection marshals
    // the result back onto the GUI thread.
    connect(this, &MicGain::workerDone, this, &MicGain::onWorkerDone,
            Qt::QueuedConnection);
}

void MicGain::setTarget(const QString &name)
{
    const QString trimmed = name.trimmed();
    if (trimmed.isEmpty() || trimmed == m_target)
        return;
    m_target = trimmed;
    // The old reading belongs to the old target; show "unknown" until the
    // refresh the UI triggers next comes back.
    m_percent = 0;
    m_error.clear();
    emit changed();
}

void MicGain::refresh()
{
    start(-1);
}

void MicGain::apply(int percent)
{
    if (percent < 10 || percent > 1000)
        return;
    start(percent);
}

void MicGain::start(int setPercent)
{
    if (m_busy)
        return;
    m_busy = true;
    m_error.clear();
    emit changed();

    const QByteArray appName = m_target.toUtf8();
    std::thread([this, appName, setPercent]() {
        QString err;
        int pct = runPulse(appName, setPercent, &err);
        emit workerDone(pct, err);
    }).detach();
}

void MicGain::onWorkerDone(int percent, const QString &error)
{
    m_busy = false;
    m_error = error;
    if (percent >= 0)
        m_percent = percent;
    emit changed();
}

QStringList MicGain::scanTargets() const
{
    // PulseAudio's "simple database" file: a flat sequence of
    // [u32 keylen][key][u32 datalen][data] records, lengths little endian
    // (host order of the phone; verified against the real file).
    // Recording entries carry this key prefix, followed by the app name.
    static const QByteArray kPrefix =
        QByteArrayLiteral("source-output-by-application-name:");

    QStringList result;
    const QDir dir(QDir::homePath() + QStringLiteral("/.config/pulse"));
    const QStringList files = dir.entryList(
        QStringList() << QStringLiteral("*-stream-volumes.simple"),
        QDir::Files);
    for (const QString &fn : files) {
        QFile f(dir.filePath(fn));
        if (!f.open(QIODevice::ReadOnly))
            continue;
        const QByteArray d = f.readAll();
        int pos = 0;
        auto readLen = [&](quint32 *len) -> bool {
            if (pos + 4 > d.size())
                return false;
            const uchar *p = reinterpret_cast<const uchar *>(d.constData() + pos);
            *len = quint32(p[0]) | (quint32(p[1]) << 8)
                 | (quint32(p[2]) << 16) | (quint32(p[3]) << 24);
            pos += 4;
            // Keys and volume payloads are tiny; a huge length means we lost
            // sync (or the format changed) — stop rather than misparse.
            return *len <= 4096;
        };
        for (;;) {
            quint32 keyLen = 0, dataLen = 0;
            if (!readLen(&keyLen) || pos + (int)keyLen > d.size())
                break;
            const QByteArray key = d.mid(pos, keyLen);
            pos += keyLen;
            if (!readLen(&dataLen) || pos + (int)dataLen > d.size())
                break;
            pos += dataLen;
            if (key.startsWith(kPrefix)) {
                const QString name =
                    QString::fromUtf8(key.mid(kPrefix.size())).trimmed();
                if (!name.isEmpty() && !result.contains(name))
                    result << name;
            }
        }
    }
    result.sort(Qt::CaseInsensitive);
    return result;
}

namespace {
// "Advanced Camera" -> "advancedcamera": desktop Name= entries and stream
// application names usually agree on the words but not always on case or
// punctuation.
QString normalized(const QString &s)
{
    QString out;
    out.reserve(s.size());
    for (const QChar ch : s)
        if (ch.isLetterOrNumber())
            out += ch.toLower();
    return out;
}
} // namespace

void MicGain::ensureDesktopIndex() const
{
    if (m_iconIndexBuilt)
        return;
    m_iconIndexBuilt = true;

    QStringList sortedNames;
    QHash<QString, QString> iconByDisplayName;

    const QDir dir(QStringLiteral("/usr/share/applications"));
    const QStringList files = dir.entryList(
        QStringList() << QStringLiteral("*.desktop"), QDir::Files);
    for (const QString &fn : files) {
        QFile f(dir.filePath(fn));
        if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
            continue;
        QStringList names;
        QString icon;
        bool hidden = false;
        // Flat scan is enough: [Desktop Entry] is the only group that
        // carries Name=/Icon= in launcher files, localized Name[xx]=
        // variants included.
        while (!f.atEnd()) {
            const QString line = QString::fromUtf8(f.readLine()).trimmed();
            if (line.startsWith(QLatin1String("Name"))) {
                const int eq = line.indexOf(QLatin1Char('='));
                const QString key = line.left(eq);
                if (key == QLatin1String("Name")
                        || key.startsWith(QLatin1String("Name[")))
                    names << line.mid(eq + 1).trimmed();
            } else if (line.startsWith(QLatin1String("Icon="))) {
                icon = line.mid(5).trimmed();
            } else if (line == QLatin1String("NoDisplay=true")
                       || line == QLatin1String("Hidden=true")) {
                hidden = true;
            }
        }
        if (icon.isEmpty() || names.isEmpty())
            continue;
        for (const QString &n : names) {
            const QString key = normalized(n);
            if (!key.isEmpty() && !m_iconIndex.contains(key))
                m_iconIndex.insert(key, icon);
        }
        // The picker shows launcher-visible apps only, under their plain
        // (first) Name.
        const QString display = names.first();
        if (!hidden && !iconByDisplayName.contains(display)) {
            iconByDisplayName.insert(display, icon);
            sortedNames << display;
        }
    }

    sortedNames.sort(Qt::CaseInsensitive);
    for (const QString &n : sortedNames) {
        QVariantMap app;
        app.insert(QStringLiteral("name"), n);
        app.insert(QStringLiteral("icon"), iconByDisplayName.value(n));
        m_installedApps << app;
    }
}

QString MicGain::iconFor(const QString &appName) const
{
    ensureDesktopIndex();
    return m_iconIndex.value(normalized(appName));
}

QVariantList MicGain::installedApps() const
{
    ensureDesktopIndex();
    return m_installedApps;
}
