#include "settings.h"

Settings::Settings(QObject *parent) : QObject(parent)
{
}

void Settings::setValue(const QString &key, const QVariant &value)
{
        _settings.setValue(key, value);
}

QVariant Settings::value(const QString &key, const QVariant &defaultValue) const
{
    return _settings.value(key, defaultValue);
}
