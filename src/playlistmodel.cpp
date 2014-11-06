/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "playlistmodel.h"
#include "mediaplaylist.h"

PlaylistModel::PlaylistModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_playlist(0)
{
    iCurrentIndex = 0;
}

    QHash<int, QByteArray> PlaylistModel::roleNames() const
    {
            QHash<int, QByteArray> roles;
            roles[Title] = "title";
            roles[Artist] = "artist";
            roles[Album] = "album";
            roles[Duration] = "duration";
            return roles;
    }

int PlaylistModel::rowCount(const QModelIndex &parent) const
{
    return m_playlist && !parent.isValid() ? m_playlist->mediaCount() : 0;
}


const int &PlaylistModel::currentIndex()
{
    return iCurrentIndex;
}

QVariant PlaylistModel::data(const QModelIndex &index, int role) const
{
    if (index.isValid()) {
        QVariant value = m_data[index];
        if (!value.isValid()) {
            QVariantMap data;

            data = m_playlist->getMetaData(index.row());

            if(role == Title)
                return data.value("Title");

            if(role == Artist)
                return data.value("Artist");

            if(role == Album)
                return data.value("Album");

            if(role == Duration)
                return data.value("Duration");
        }

        return value;
    }
    return QVariant();
}

MediaPlaylist *PlaylistModel::playlist() const
{
    return m_playlist;
}

void PlaylistModel::setPlaylist(MediaPlaylist *playlist)
{
    if (m_playlist) {
        disconnect(m_playlist, SIGNAL(mediaAboutToBeInserted(int,int)), this, SLOT(beginInsertItems(int,int)));
        disconnect(m_playlist, SIGNAL(mediaInserted(int,int)), this, SLOT(endInsertItems()));
        disconnect(m_playlist, SIGNAL(mediaAboutToBeRemoved(int,int)), this, SLOT(beginRemoveItems(int,int)));
        disconnect(m_playlist, SIGNAL(mediaRemoved(int,int)), this, SLOT(endRemoveItems()));
        disconnect(m_playlist, SIGNAL(mediaChanged(int,int)), this, SLOT(changeItems(int,int)));
        disconnect(m_playlist, SIGNAL(currentIndexChanged(int)), this, SLOT(setCurrentIndex(int)));
    }

    beginResetModel();
    m_playlist = playlist;
    iCurrentIndex = playlist->currentIndex();

    if (m_playlist) {
        connect(m_playlist, SIGNAL(mediaAboutToBeInserted(int,int)), this, SLOT(beginInsertItems(int,int)));
        connect(m_playlist, SIGNAL(mediaInserted(int,int)), this, SLOT(endInsertItems()));
        connect(m_playlist, SIGNAL(mediaAboutToBeRemoved(int,int)), this, SLOT(beginRemoveItems(int,int)));
        connect(m_playlist, SIGNAL(mediaRemoved(int,int)), this, SLOT(endRemoveItems()));
        connect(m_playlist, SIGNAL(mediaChanged(int,int)), this, SLOT(changeItems(int,int)));
        connect(m_playlist, SIGNAL(currentIndexChanged(int)), this, SLOT(setCurrentIndex(int)));
    }

    endResetModel();
}

void PlaylistModel::beginInsertItems(int start, int end)
{
    beginInsertRows(QModelIndex(), start, end);
}

void PlaylistModel::endInsertItems()
{
    endInsertRows();
}

void PlaylistModel::beginRemoveItems(int start, int end)
{
    beginRemoveRows(QModelIndex(), start, end);
}

void PlaylistModel::endRemoveItems()
{
    endInsertRows();
}

void PlaylistModel::changeItems(int start, int end)
{
    emit dataChanged(index(start,0), index(end,ColumnCount));
}

void PlaylistModel::setCurrentIndex(int index)
{
    iCurrentIndex = index;
    emit currentIndexChanged();
}
