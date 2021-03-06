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
TARGET = harbour-sirensong

CONFIG += sailfishapp \
            qtsparql

QT += multimedia \
       dbus

SOURCES += \
    src/mediaplayer.cpp \
    src/trackerinterface.cpp \
    src/playlistmodel.cpp \
    src/mediaplayerdbusadaptor.cpp \
    src/mprisinterface.cpp \
    src/mediaplaylist.cpp \
    src/settings.cpp \
    src/harbour-sirensong.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    harbour-sirensong.desktop \
    qml/pages/*.qml \
    qml/pages/functions.js \
    rpm/harbour-sirensong.spec \
    rpm/harbour-sirensong.yaml \
    rpm/harbour-sirensong.changes.in \
    translations/harbour-sirensong-de.ts \
    translations/harbour-sirensong-fi.ts \
    translations/harbour-sirensong-fr.ts \
    translations/harbour-sirensong-cz.ts \
    translations/harbour-sirensong-nl.ts \
    translations/harbour-sirensong-ru.ts \
    translations/harbour-sirensong-sv.ts

icons.files = $${TARGET}.png
icons.path = /usr/share/icons/hicolor/86x86/apps

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
CONFIG += sailfishapp_i18n_unfinished
TRANSLATIONS += translations/harbour-sirensong-de.ts \
    translations/harbour-sirensong-fi.ts \
    translations/harbour-sirensong-fr.ts \
    translations/harbour-sirensong-cz.ts \
    translations/harbour-sirensong-nl.ts \
    translations/harbour-sirensong-ru.ts \
    translations/harbour-sirensong-sv.ts

HEADERS += \
    src/mediaplayer.h \
    src/trackerinterface.h \
    src/playlistmodel.h \
    src/mediaplayerdbusadaptor.h \
    src/mprisinterface.h \
    src/mediaplaylist.h \
    src/settings.h

DISTFILES += \
    qml/pages/SongItem.qml \
    qml/pages/TieredMenu.qml

