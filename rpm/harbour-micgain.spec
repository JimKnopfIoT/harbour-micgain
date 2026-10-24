# harbour-micgain — persistent microphone gain fix for quiet camera
# recordings on Sailfish OS.
#
# Neutral packaging metadata — no personal identifiers.
Name:       harbour-micgain
Summary:    Fix quiet camera recordings (microphone gain)
Version:    0.4.0
Release:    1
# Neutral build host so built RPMs carry no real hostname/domain.
%define _buildhost reproducible-builder
License:    GPL-3.0-or-later
URL:        https://github.com/JimKnopfIoT/harbour-micgain
Source0:    %{name}-%{version}.tar.bz2
Vendor:     harbour-micgain contributors
Packager:   harbour-micgain contributors

Requires:   sailfishsilica-qt5

BuildRequires: pkgconfig(sailfishapp)
BuildRequires: pkgconfig(Qt5Core)
BuildRequires: pkgconfig(Qt5Qml)
BuildRequires: pkgconfig(Qt5Quick)
BuildRequires: pkgconfig(libpulse)
BuildRequires: desktop-file-utils
BuildRequires: qt5-qttools-linguist

%description
Camera apps record almost inaudibly quiet audio on some Sailfish OS ports
(seen with Advanced Camera on the Xperia 10 III): the Android audio HAL
underneath is configured with a far too low microphone input gain. This app
stores a boosted recording volume for the camera's audio stream in
PulseAudio's per-application memory (stream-restore); PulseAudio then applies
the gain automatically to every future recording. One slider, default 300 %,
fully revertible.

%prep
%setup -q

%build
%qmake5 VERSION=%{version} RELEASE=%{release}
%make_build

%install
%qmake5_install
strip %{buildroot}%{_bindir}/%{name} || :

desktop-file-install --delete-original \
    --dir %{buildroot}%{_datadir}/applications \
    %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png

%changelog
* Sat Oct 24 2026 harbour-micgain contributors 0.4.0-1
- "Reset all apps to 100 %" in the pull-down menu: sets every recording
  entry back to the system default in one go, with progress display.
- Per-process entries "QtPulseAudio:<pid>" (left by every run of a Qt app,
  e.g. Speech Note) are hidden from the list: a gain set there hits a random
  later process with the same pid. Reset all still covers them.
- The slider no longer writes on release; an explicit Apply button does, so
  a stray tap while scrolling cannot change a stored value.
* Sun Aug 16 2026 harbour-micgain contributors 0.3.2-1
- About page wording: name only the device the analysis was done on.
* Sun Aug 16 2026 harbour-micgain contributors 0.3.1-1
- Fix the database scanner: record lengths are little endian, the scan
  aborted on the first record and the auto-detected app list stayed empty
  (only the curated entries showed).
* Sun Aug 16 2026 harbour-micgain contributors 0.3.0-1
- App list shows launcher icons; prominent note that only apps which have
  recorded before are auto-detected; free-text field replaced by a picker
  over all installed apps (entry is created proactively, no launch needed).
* Sun Aug 16 2026 harbour-micgain contributors 0.2.0-1
- App picker: every app that ever recorded is scanned from the
  stream-restore database and offered as a selectable entry (plus curated
  defaults and a free-text field); per-app gain values.
* Sun Aug 16 2026 harbour-micgain contributors 0.1.0-1
- Initial release: slider (50–600 %, default 300 %) storing a persistent
  PulseAudio recording volume for the Advanced Camera stream, About page
  documenting the Android-HAL root cause, German translation.
