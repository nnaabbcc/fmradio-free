/*
 *  fmradio-qml - UI for FM radio
 *  Copyright (C) 2012 Andrey Kozhanov <andy.tolst@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifndef TUNERMODEL_H
#define TUNERMODEL_H

#include <QObject>
#include <QDBusInterface>
#include <QDeclarativeView>
#include "dbus/fmradiointerface.h"

#include "stationsmodel.h"

class ContextProperty;

class TunerModel : public QObject
{
    Q_OBJECT
public:
    explicit TunerModel(QObject *parent = 0);
    ~TunerModel();

    void showViewer();

signals:
    void scanCompleted(double freq);
    void ready();
    void signalChanged();
    void turnedOff();
    void speakerStateChanged();
    void scanFwdStarted();
    void scanBkwStarted();
    void fullScanCompleted();

public slots:
    void powerOn(bool on);
    void tuneToFreq(double freq);
    void scan(bool forward);
    void storeStation(int id, double value);
    double getStation(int id);

    uint signalLevel();
    bool isStereo();
    double currentFreq();

    void setLoudSpeaker(bool loud);
    bool isLoudSpeaker();

    bool isPowered();

    QString getVersion();

    int currentSkin();
    void changeSkin(int id);
    bool isFirstTime();

    void setActive(bool isActive);

    void setActiveStationNum(int index);

    void fullScan();

private slots:
    void slotOnTuned(double freq, uint signal);
    void slotOnSignalChanged(uint signal, bool stereo);
    void slotOnBackendClosed(int code, QProcess::ExitStatus status);
    void onSpeakerChanged();

private:
    void loadClassicStations();
    void saveClassicStations();

    void doNextScanInFullScan();
    void saveStation(qreal freq);

private:
    enum TunerState {
        StateIdle,
        StateTuning,
        StateScanning
    };

    enum FullScanPath{
        FSP_NONE,
        FSP_FORWARD,
        FSP_BACKWARD,
        FSP_SECONDFORWARD
    };

    TunerState m_state;
    TunerState m_nextState;

    bool m_scanForward;

    bool m_isPowered;
    double m_currentFreq;
    uint m_signal;
    bool m_stereo;
    FMRadioInterface m_engine;

    QProcess m_backend;
    QSettings m_settings;
    QDBusInterface m_loudSpeakerIface;
    ContextProperty* m_loudSpeakerProperty;
    bool m_speakerEnabled;
    bool m_powered;

    QString m_version;

    int m_skinId;
    bool m_isActive;

    QDeclarativeView * m_viewer;
    StationsModel * m_stationModel;

    bool m_isFirstTime;

    int m_activeStationNum;

    bool m_isFullScan;
    FullScanPath m_fullScanPath;
};

#endif // TUNERMODEL_H
