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

CONFIG += sailfishapp

QT += multimedia

SOURCES += src/SirenSong-Media-Player.cpp \
    src/mediaplayer.cpp

OTHER_FILES += qml/SirenSong-Media-Player.qml \
    qml/cover/CoverPage.qml \
    rpm/SirenSong-Media-Player.changes.in \
    rpm/SirenSong-Media-Player.spec \
    rpm/SirenSong-Media-Player.yaml \
    translations/*.ts \
    SirenSong-Media-Player.desktop \
    qml/pages/Main.qml \
    qml/pages/AlphaMenu.qml \
    qml/pages/AlphaMenuGroupView.qml \
    qml/pages/AlphaMenuGroup.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/SirenSong-Media-Player-de.ts

HEADERS += \
    src/mediaplayer.h

