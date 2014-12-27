# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = SirenSong-Media-Player

CONFIG += sailfishapp \
            qtsparql

QT += multimedia \
       dbus

SOURCES += src/SirenSong-Media-Player.cpp \
    src/mediaplayer.cpp \
    src/trackerinterface.cpp \
    src/playlistmodel.cpp \
    src/mediaplayerdbusadaptor.cpp \
    src/mprisinterface.cpp \
    src/mediaplaylist.cpp \
    src/settings.cpp

OTHER_FILES += qml/SirenSong-Media-Player.qml \
    qml/cover/CoverPage.qml \
    rpm/SirenSong-Media-Player.changes.in \
    rpm/SirenSong-Media-Player.spec \
    rpm/SirenSong-Media-Player.yaml \
    translations/*.ts \
    SirenSong-Media-Player.desktop \
    qml/pages/AlphaMenu.qml \
    qml/pages/AlphaMenuGroupView.qml \
    qml/pages/AlphaMenuGroup.qml \
    qml/pages/PlayerPage.qml \
    qml/pages/SongSelect.qml \
    qml/pages/ArtistSelect.qml \
    qml/pages/SearchSelect.qml \
    qml/pages/functions.js \
    qml/pages/LibraryPage.qml \
    translations/SirenSong-Media-Player-cz.ts \
    qml/pages/SettingsPage.qml \
    translations/SirenSong-Media-Player-fr.ts \
    translations/SirenSong-Media-Player-nl.ts \
    translations/SirenSong-Media-Player-ru.ts

icons.files = $${TARGET}.png
icons.path = /usr/share/icons/hicolor/86x86/apps

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
CONFIG += sailfishapp_i18n_unfinished
TRANSLATIONS += translations/SirenSong-Media-Player-de.ts \
translations/SirenSong-Media-Player-fi.ts \
translations/SirenSong-Media-Player-fr.ts \
translations/SirenSong-Media-Player-cz.ts \
translations/SirenSong-Media-Player-nl.ts \
translations/SirenSong-Media-Player-ru.ts

HEADERS += \
    src/mediaplayer.h \
    src/trackerinterface.h \
    src/playlistmodel.h \
    src/mediaplayerdbusadaptor.h \
    src/mprisinterface.h \
    src/mediaplaylist.h \
    src/settings.h

