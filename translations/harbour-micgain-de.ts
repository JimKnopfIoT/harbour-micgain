<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE TS>
<TS version="2.1" language="de">
<context>
    <name>AboutPage</name>
    <message>
        <source>About</source>
        <translation>Über</translation>
    </message>
    <message>
        <source>Version %1</source>
        <extracomment>%1 is the version number</extracomment>
        <translation>Version %1</translation>
    </message>
    <message>
        <source>The problem</source>
        <translation>Das Problem</translation>
    </message>
    <message>
        <source>Recordings made with camera and audio apps such as Advanced Camera or Audio Recorder are far too quiet on some Sailfish OS devices (measured on the Xperia 10 III): speech peaks 20–25 dB below a normal level, so it is barely audible on playback.</source>
        <translation>Aufnahmen mit Kamera- und Audio-Apps wie Advanced Camera oder Audio Recorder sind auf manchen Sailfish-OS-Geräten viel zu leise (gemessen auf dem Xperia 10 III): Sprache liegt 20–25 dB unter dem normalen Pegel und ist beim Abspielen kaum zu hören.</translation>
    </message>
    <message>
        <source>The cause</source>
        <translation>Die Ursache</translation>
    </message>
    <message>
        <source>The apps are innocent: their files contain exactly the audio PulseAudio delivers, and every volume inside PulseAudio sits at 100 %. The signal is already quiet when it arrives from below — the Android audio HAL, the vendor driver layer Sailfish OS reuses for the hardware, is configured with a much too low microphone input gain for the camcorder path. Fixing it properly would mean changing vendor audio configuration files on the device.</source>
        <translation>Die Apps sind unschuldig: Ihre Dateien enthalten exakt den Ton, den PulseAudio liefert, und alle Lautstärken in PulseAudio stehen auf 100 %. Das Signal kommt schon zu leise von unten an — der Android-Audio-HAL, also die Hersteller-Treiberschicht, die Sailfish OS für die Hardware weiterverwendet, ist für den Camcorder-Pfad mit viel zu niedriger Mikrofon-Eingangsverstärkung konfiguriert. Eine echte Korrektur hieße, Hersteller-Audiokonfiguration auf dem Gerät zu ändern.</translation>
    </message>
    <message>
        <source>What this app does</source>
        <translation>Was diese App tut</translation>
    </message>
    <message>
        <source>It compensates with digital gain in PulseAudio: the chosen recording volume is stored in PulseAudio&apos;s per-app memory (stream-restore) under the selected app&apos;s stream name, and is then applied automatically to every future recording of that app — this app does not need to be running for that. To write the entry, it briefly opens a microphone stream under that name; the microphone is active for a fraction of a second and nothing is recorded or stored.</source>
        <translation>Sie gleicht das mit digitaler Verstärkung in PulseAudio aus: Die gewählte Aufnahme-Lautstärke wird in PulseAudios App-Gedächtnis (stream-restore) unter dem Stream-Namen der ausgewählten App hinterlegt und danach automatisch auf jede künftige Aufnahme dieser App angewendet — diese App muss dafür nicht laufen. Zum Schreiben des Eintrags öffnet sie kurz einen Mikrofon-Stream unter diesem Namen; das Mikrofon ist dabei für den Bruchteil einer Sekunde aktiv, aufgezeichnet oder gespeichert wird nichts.</translation>
    </message>
    <message>
        <source>Trade-off of digital gain: the noise floor rises by the same amount, and values above roughly 400 % can clip loud sounds. 300 % (+9.5 dB) is a good starting point.</source>
        <translation>Kompromiss digitaler Verstärkung: Das Grundrauschen steigt im gleichen Maß, und Werte über etwa 400 % können laute Geräusche übersteuern. 300 % (+9,5 dB) sind ein guter Startwert.</translation>
    </message>
    <message>
        <source>License</source>
        <translation>Lizenz</translation>
    </message>
    <message>
        <source>GNU GPLv3 or later. No warranty — the change can always be undone via “Reset to 100 %”.</source>
        <translation>GNU GPLv3 oder neuer. Keine Gewähr — die Änderung lässt sich jederzeit über „Auf 100 % zurücksetzen&quot; rückgängig machen.</translation>
    </message>
</context>
<context>
    <name>AppPickerPage</name>
    <message>
        <source>Select app</source>
        <translation>App auswählen</translation>
    </message>
    <message>
        <source>Search</source>
        <translation>Suchen</translation>
    </message>
    <message>
        <source>The gain entry is created under the app&apos;s name right away and takes effect with the app&apos;s first recording. After that recording the app also shows up in the main list by itself.</source>
        <translation>Der Verstärkungs-Eintrag wird sofort unter dem Namen der App angelegt und greift mit ihrer ersten Aufnahme. Nach dieser Aufnahme erscheint die App auch von selbst in der Hauptliste.</translation>
    </message>
</context>
<context>
    <name>CoverPage</name>
    <message>
        <source>%1 %</source>
        <extracomment>%1 is the stored gain percentage</extracomment>
        <translation>%1 %</translation>
    </message>
</context>
<context>
    <name>MainPage</name>
    <message>
        <source>About</source>
        <translation>Über</translation>
    </message>
    <message>
        <source>Reset to 100 % (system default)</source>
        <translation>Auf 100 % zurücksetzen (Systemstandard)</translation>
    </message>
    <message>
        <source>Set recommended 300 %</source>
        <translation>Empfohlene 300 % setzen</translation>
    </message>
    <message>
        <source>Microphone gain</source>
        <translation>Mikrofon-Verstärkung</translation>
    </message>
    <message>
        <source>Rescan apps</source>
        <translation>Apps neu einlesen</translation>
    </message>
    <message>
        <source>Boosts the recording volume of the selected app. Each app keeps its own value; it is stored permanently and applied to every future recording. Details: pull down → About.</source>
        <translation>Verstärkt die Aufnahme-Lautstärke der ausgewählten App. Jede App hat ihren eigenen Wert; er wird dauerhaft gespeichert und gilt für jede künftige Aufnahme. Details: Pulley-Menü → Über.</translation>
    </message>
    <message>
        <source>%1 % (%2 dB)</source>
        <extracomment>%1 is the gain percentage, %2 the equivalent in decibels</extracomment>
        <translation>%1 % (%2 dB)</translation>
    </message>
    <message>
        <source>Stored</source>
        <translation>Gespeichert</translation>
    </message>
    <message>
        <source>%1 %</source>
        <extracomment>%1 is the stored gain percentage</extracomment>
        <translation>%1 %</translation>
    </message>
    <message>
        <source>App</source>
        <translation>App</translation>
    </message>
    <message>
        <source>Important: only apps that have already used the microphone at least once are listed here — the system learns about an app the moment it records for the first time. If an app is missing, make one short recording with it and pull down to rescan, or enter its stream name below.</source>
        <translation>Wichtig: Hier stehen nur Apps, die das Mikrofon schon mindestens einmal benutzt haben — das System lernt eine App erst mit ihrer ersten Aufnahme kennen. Fehlt eine App, mach eine kurze Aufnahme mit ihr und lies die Liste über das Pulley-Menü neu ein — oder füge sie unten hinzu.</translation>
    </message>
    <message>
        <source>Add another app…</source>
        <translation>Weitere App hinzufügen…</translation>
    </message>
    <message>
        <source>Values above 400 % can distort loud sounds; 100 % is the (too quiet) system default. Applying opens the microphone for a fraction of a second; nothing is recorded.</source>
        <translation>Werte über 400 % können laute Geräusche verzerren; 100 % ist der (zu leise) Systemstandard. Beim Anwenden ist das Mikrofon für den Bruchteil einer Sekunde aktiv; aufgenommen wird nichts.</translation>
    </message>
</context>
</TS>
