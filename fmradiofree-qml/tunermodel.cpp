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

#include "tunermodel.h"
#include <QDebug>
#include <QDeclarativeContext>
#include <contextproperty.h>
#include <contextpropertyinfo.h>

TunerModel::TunerModel(QObject *parent) :
    QObject(parent)
  , m_state(StateIdle)
  , m_nextState(StateIdle)
  , m_scanForward(true)
  , m_signal(0)
  , m_stereo(false)
  , m_engine("com.nnaabbcc.fmradio", "/com/nnaabbcc/fmradio", QDBusConnection::sessionBus())
  , m_settings(QDir::homePath() + "/.config/fmradio-free/fmradio.conf", QSettings::IniFormat)
  , m_loudSpeakerIface("org.maemo.Playback.Manager", "/org/maemo/Playback/Manager", "org.maemo.Playback.Manager")
  , m_speakerEnabled(false)
  , m_powered(false)
  , m_version("0.0.9")
  , m_skinId(0)
  , m_isActive(true)
  , m_viewer(NULL)
  , m_stationModel(new StationsModel(new CStationItem))
  , m_isFirstTime(true)
  , m_activeStationNum(0)
  , m_isFullScan(false)
  , m_fullScanPath(FSP_NONE)
{
    connect(&m_engine, SIGNAL(tuned(double,uint)), this, SLOT(slotOnTuned(double,uint)));
    connect(&m_engine, SIGNAL(signalChanged(uint,bool)), this, SLOT(slotOnSignalChanged(uint,bool)));

    m_stationModel->setParent(this);

    m_currentFreq = m_settings.value("lastFreq", 87.5).toDouble();
    m_powered = m_settings.value("powered", false).toBool();
    m_isFirstTime = m_settings.value("firsttime",true).toBool();
    m_skinId = m_settings.value("skinid",0).toInt();

    loadClassicStations();

    m_loudSpeakerProperty = new ContextProperty("/com/nokia/policy/audio_route", this);
    connect( m_loudSpeakerProperty,
             SIGNAL(valueChanged()),
             SLOT(onSpeakerChanged()) );
    m_speakerEnabled = (m_loudSpeakerProperty->value().toString()!="headset" && m_loudSpeakerProperty->value().toString()!="headphone");
}

TunerModel::~TunerModel()
{
    qDebug() << "Terminating backend";
    m_loudSpeakerIface.call("RequestPrivacyOverride", false);

    m_settings.setValue("lastFreq", m_currentFreq);
    m_settings.setValue("powered", m_powered);
    m_settings.setValue("firsttime",m_isFirstTime);
    m_settings.setValue("skinid",m_skinId);

    saveClassicStations();

    m_engine.exit().waitForFinished();
}

void TunerModel::storeStation(int id, double value)
{
    m_settings.setValue("station" + QString::number(id), value);
}

double TunerModel::getStation(int id)
{
    return m_settings.value("station" + QString::number(id)).toDouble();
}

void TunerModel::loadClassicStations()
{
    m_stationModel->deleteAll();
    int count = m_settings.value("/classicstation/count",0).toInt();
    for(int i = 0; i < count; i++)
    {
        m_stationModel->addNewStation(m_settings.value(QString("/classicstation/s%1_freq").arg(i)).toDouble(),
                                      m_settings.value(QString("/classicstation/s%1_username").arg(i)).toString());
    }
}

void TunerModel::saveClassicStations()
{
    int count = m_stationModel->rowCount();
    m_settings.setValue("/classicstation/count",count);
    for(int i = 0; i < count; i++)
    {
        m_settings.setValue(QString("/classicstation/s%1_username").arg(i),
                            m_stationModel->nameByIndex(i));
        m_settings.setValue(QString("/classicstation/s%1_freq").arg(i),
                            m_stationModel->freqByIndex(i));
    }
}

void TunerModel::slotOnBackendClosed(int code, QProcess::ExitStatus status)
{
    qDebug() << "backend process finished" << code << status;

    emit turnedOff();
}

void TunerModel::powerOn(bool on)
{
    if(on)
    {
        m_state = StateScanning;
        m_nextState = StateIdle;
        m_engine.start();
        m_powered = true;
    }
    else
    {
        m_engine.stop();
        m_powered = false;
    }
}

void TunerModel::slotOnTuned(double freq, uint signal)
{
    qDebug() << "Engine tuned to " << freq << signal;
    m_signal = signal;
    emit signalChanged();
    if(m_state == StateScanning && m_nextState == StateIdle)
    {
        qDebug() << "Scan completed";
        m_currentFreq = freq;
        emit scanCompleted(freq);
    }

    m_state = StateIdle;
    if(m_nextState == StateTuning && m_currentFreq!=freq)
    {
        tuneToFreq(m_currentFreq);
    }
    else if (m_nextState == StateScanning)
    {
        scan(m_scanForward);
    }

    if(m_isFullScan)
    {
        doNextScanInFullScan();
        saveStation(freq);
    }

    m_nextState = StateIdle;
}

void TunerModel::tuneToFreq(double freq)
{
    m_currentFreq = freq;

    if(m_state == StateIdle)
    {
        m_state = StateTuning;
        QMetaObject::invokeMethod(&m_engine, "tuneToFreq", Qt::QueuedConnection, Q_ARG(double, m_currentFreq));
    }
    else
    {
        m_nextState = StateTuning;
    }
}

void TunerModel::scan(bool forward)
{
    m_scanForward = forward;

    if(m_state == StateIdle)
    {
        m_state = StateScanning;
        m_engine.scan(m_scanForward);
    }
    else if(m_state != StateScanning)
    {
        m_nextState = StateScanning;
    }
}

double TunerModel::currentFreq()
{
    return m_currentFreq;
}

uint TunerModel::signalLevel()
{
    return m_signal;
}

bool TunerModel::isStereo()
{
    return m_stereo;
}

void TunerModel::slotOnSignalChanged(uint signal, bool stereo)
{
    qDebug() << "Signal changed " << signal << "Stereo: " << stereo;
    m_signal = signal;
    m_stereo = stereo;
    emit signalChanged();
}

void TunerModel::setLoudSpeaker(bool loud)
{
    m_loudSpeakerIface.call("RequestPrivacyOverride", loud);
}

bool TunerModel::isLoudSpeaker()
{
    return m_speakerEnabled;
}

void TunerModel::onSpeakerChanged()
{
    qDebug() << "onSpeakerChanged " << m_loudSpeakerProperty->value().toString();
    m_speakerEnabled = (m_loudSpeakerProperty->value().toString()!="headset" && m_loudSpeakerProperty->value().toString()!="headphone");

    emit speakerStateChanged();
}

bool TunerModel::isPowered()
{
    return m_powered;
}

QString TunerModel::getVersion()
{
    return m_version;
}

int TunerModel::currentSkin()
{
    return m_skinId;
}

void TunerModel::changeSkin(int id)
{
    m_skinId = id;
    showViewer();
}

void TunerModel::showViewer()
{
    QDeclarativeView *viewer = new QDeclarativeView;

    QDeclarativeContext *ctxt = viewer->rootContext();
    ctxt->setContextProperty("tunerModel", this);
    ctxt->setContextProperty("stationsModel",m_stationModel);

    switch(m_skinId)
    {
    case 0:
        viewer->setSource(QUrl("qrc:/skin-chooser/FirstTimeView.qml"));
        break;
    case 1:
        viewer->setSource(QUrl("qrc:/qml-classic/MainWindowClassic.qml"));
        m_isFirstTime = false;
        break;
    case 2:
        viewer->setSource(QUrl("qrc:/qml/MainWindowDevice.qml"));
        m_isFirstTime = false;
        break;
    }
    viewer->showFullScreen();
    if(m_viewer != NULL)
    {
        m_viewer->setVisible(false);
        m_viewer->close();
    }
    m_viewer = viewer;
}

bool TunerModel::isFirstTime()
{
    return m_isFirstTime;
}

void TunerModel::setActive(bool isActive)
{
    m_isActive = isActive;
}

void TunerModel::setActiveStationNum(int index)
{
    m_activeStationNum = index;
}

void TunerModel::fullScan()
{
    m_stationModel->deleteAll();

    if(m_powered == false)
    {
        powerOn(true);
    }

    m_isFullScan = true;
    m_fullScanPath = FSP_NONE;

    doNextScanInFullScan();
}

void TunerModel::doNextScanInFullScan()
{
    if(m_fullScanPath == FSP_NONE)
    {
        m_fullScanPath = FSP_FORWARD;
        emit scanFwdStarted();
        scan(true);
    }

    if(qAbs(currentFreq() - 108.0) < 0.001)
    {
        if(m_fullScanPath == FSP_FORWARD)
        {
            m_fullScanPath = FSP_BACKWARD;
            emit scanBkwStarted();
            scan(false);
        }else if(m_fullScanPath == FSP_SECONDFORWARD)
        {
            m_isFullScan = false;
            m_fullScanPath = FSP_NONE;
            emit fullScanCompleted();
        }
    }else if(qAbs(currentFreq() - 87.5) < 0.001)
    {
        if(m_fullScanPath == FSP_BACKWARD)
        {
            m_fullScanPath = FSP_SECONDFORWARD;
            emit scanFwdStarted();
        }
        scan(true);
    }else{
        if(m_fullScanPath == FSP_FORWARD ||
                m_fullScanPath == FSP_SECONDFORWARD)
        {
            scan(true);
        }else if(m_fullScanPath == FSP_BACKWARD){
            scan(false);
        }
    }
}

void TunerModel::saveStation(qreal freq)
{
    QString name = tr("fm-tr-classic-station").arg(freq);
    m_stationModel->addNewStation(freq,name);
}
