<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE TS>
<TS version="2.1">
<context>
    <name>AboutPage</name>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="20"/>
        <source>About</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="32"/>
        <source>Version %1</source>
        <extracomment>%1 is the version number</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="37"/>
        <source>The problem</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="60"/>
        <source>The apps are innocent: their files contain exactly the audio PulseAudio delivers, and every volume inside PulseAudio sits at 100 %. The signal is already quiet when it arrives from below — the Android audio HAL, the vendor driver layer Sailfish OS reuses for the hardware, is configured with a much too low microphone input gain for the camcorder path. Fixing it properly would mean changing vendor audio configuration files on the device.</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="79"/>
        <source>It compensates with digital gain in PulseAudio: the chosen recording volume is stored in PulseAudio&apos;s per-app memory (stream-restore) under the selected app&apos;s stream name, and is then applied automatically to every future recording of that app — this app does not need to be running for that. To write the entry, it briefly opens a microphone stream under that name; the microphone is active for a fraction of a second and nothing is recorded or stored.</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="52"/>
        <source>The cause</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="45"/>
        <source>Recordings made with camera and audio apps such as Advanced Camera or Audio Recorder are far too quiet on some Sailfish OS devices (measured on the Xperia 10 III): speech peaks 20–25 dB below a normal level, so it is barely audible on playback.</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="71"/>
        <source>What this app does</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="96"/>
        <source>Trade-off of digital gain: the noise floor rises by the same amount, and values above roughly 400 % can clip loud sounds. 300 % (+9.5 dB) is a good starting point.</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="102"/>
        <source>License</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="110"/>
        <source>GNU GPLv3 or later. No warranty — the change can always be undone via “Reset to 100 %”.</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>AppPickerPage</name>
    <message>
        <location filename="../qml/pages/AppPickerPage.qml" line="34"/>
        <source>Select app</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AppPickerPage.qml" line="39"/>
        <source>Search</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/AppPickerPage.qml" line="51"/>
        <source>The gain entry is created under the app&apos;s name right away and takes effect with the app&apos;s first recording. After that recording the app also shows up in the main list by itself.</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>CoverPage</name>
    <message>
        <location filename="../qml/cover/CoverPage.qml" line="25"/>
        <source>%1 %</source>
        <extracomment>%1 is the stored gain percentage</extracomment>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>MainPage</name>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="92"/>
        <source>About</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="96"/>
        <source>Rescan apps</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="100"/>
        <source>Reset all apps to 100 %</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="102"/>
        <source>Resetting all apps</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="106"/>
        <source>Reset to 100 % (system default)</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="114"/>
        <source>Set recommended 300 %</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="128"/>
        <source>Microphone gain</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="136"/>
        <source>Boosts the recording volume of the selected app. Each app keeps its own value; it is stored permanently and applied to every future recording. Details: pull down → About.</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="160"/>
        <source>Apply %1 %</source>
        <extracomment>%1 is the gain percentage</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="196"/>
        <source>Resetting %1 of %2</source>
        <extracomment>%1 entries done, %2 entries in total</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="211"/>
        <source>App</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="219"/>
        <source>Important: only apps that have already used the microphone at least once are listed here — the system learns about an app the moment it records for the first time. If an app is missing, make one short recording with it and pull down to rescan, or enter its stream name below.</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="290"/>
        <source>%1 temporary entries (QtPulseAudio:…) are hidden: Qt apps get a new one each time they start, so a gain set there would hit a random later process. “Reset all apps to 100 %” includes them.</source>
        <extracomment>%1 is the number of hidden entries</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="322"/>
        <source>Add another app…</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="333"/>
        <source>Values above 400 % can distort loud sounds; 100 % is the (too quiet) system default. Applying opens the microphone for a fraction of a second; nothing is recorded.</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="147"/>
        <source>%1 % (%2 dB)</source>
        <extracomment>%1 is the gain percentage, %2 the equivalent in decibels</extracomment>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="172"/>
        <source>Stored</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainPage.qml" line="175"/>
        <source>%1 %</source>
        <extracomment>%1 is the stored gain percentage</extracomment>
        <translation type="unfinished"></translation>
    </message>
</context>
</TS>
