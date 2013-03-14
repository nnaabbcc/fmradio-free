#
#  fmradio-qml - UI for FM radio
#  Copyright (C) 2012 Andrey Kozhanov <andy.tolst@gmail.com>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.

#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

TARGET = fmradio
QT += declarative dbus

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable link_pkgconfig
PKGCONFIG += contextsubscriber-1.0

HEADERS += \
    tunermodel.h \
    dbus/fmradiointerface.h \
    stationsmodel.h

SOURCES += main.cpp \
    tunermodel.cpp \
    dbus/fmradiointerface.cpp \
    stationsmodel.cxx

!isEmpty(MEEGO_VERSION_MAJOR) {
DEFINES+=MEEGO_OS
}

RESOURCES += resources.qrc

OTHER_FILES += fmradio.conf \
    qml-classic/StationListPage.qml \
    qml-classic/MainWindowClassic.qml \
    qml-classic/MainPage.qml \
    qml-classic/components/star.png \
    qml-classic/components/scale_pointer.png \
    qml-classic/components/record-btn.png \
    qml-classic/components/radio_scale2.jpg \
    qml-classic/components/radio_scale1.jpg \
    qml-classic/components/black_cover_mirror.png \
    qml-classic/components/black_cover.png \
    qml-classic/components/TunerScale.qml \
    qml-classic/components/SeekButton.qml \
    qml-classic/components/ScanButton.qml \
    qml-classic/components/RecordButton.qml \
    qml-classic/components/PowerButton.qml \
    qml-classic/components/ModalDialog.qml \
    qml-classic/components/MagicLabel.qml \
    qml-classic/components/AboutDialog.qml \
    qml/MainWindowDevice.qml \
    qml/MainWindowDesktop.qml \
    qml/MainView.qml \
    qml/components/title.png \
    qml/components/switch_on.png \
    qml/components/switch_off.png \
    qml/components/star.png \
    qml/components/speaker_button_headset_highlited.png \
    qml/components/speaker_button_headset.png \
    qml/components/Smirnof.ttf \
    qml/components/settings-button-pressed.png \
    qml/components/settings-button-normal.png \
    qml/components/seek_button_right_pressed.png \
    qml/components/seek_button_right.png \
    qml/components/seek_button_left_pressed.png \
    qml/components/seek_button_left.png \
    qml/components/scale_glass_cover.png \
    qml/components/scale_background.png \
    qml/components/rds-screen-glass.png \
    qml/components/rds-screen-bg.png \
    qml/components/rds-logo.png \
    qml/components/radio_scale.jpg \
    qml/components/panel_background.png \
    qml/components/nixie_tube_empty_light.png \
    qml/components/nixie_tube_empty.png \
    qml/components/nixie_dot.png \
    qml/components/nixie_digit_9.png \
    qml/components/nixie_digit_8.png \
    qml/components/nixie_digit_7.png \
    qml/components/nixie_digit_6.png \
    qml/components/nixie_digit_5.png \
    qml/components/nixie_digit_4.png \
    qml/components/nixie_digit_3.png \
    qml/components/nixie_digit_2.png \
    qml/components/nixie_digit_1.png \
    qml/components/nixie_digit_0.png \
    qml/components/nixie_background.png \
    qml/components/meter_light.png \
    qml/components/meter_foreground.png \
    qml/components/meter_background.png \
    qml/components/meter_arrow.png \
    qml/components/mainview-settings-button-normal.png \
    qml/components/mainview-settings-button-enabled.png \
    qml/components/help_volumeter.jpg \
    qml/components/help_scale.jpg \
    qml/components/help_header.jpg \
    qml/components/help_button_group.jpg \
    qml/components/close-btn-pressed.png \
    qml/components/close-btn-normal.png \
    qml/components/button_pressed.png \
    qml/components/button_disabled.png \
    qml/components/black_cover.png \
    qml/components/background.jpg \
    qml/components/TunerScale.qml \
    qml/components/SpeakerButton.qml \
    qml/components/SeekButton.qml \
    qml/components/SecurityWarning.qml \
    qml/components/RdsInfo.qml \
    qml/components/PowerSwitch.qml \
    qml/components/NixieTubeDigit.qml \
    qml/components/LargeButton.qml \
    qml/components/HelpScreen.qml \
    qml/components/HelpButton.qml \
    qml/components/HeadsetDialog.qml \
    qml/components/DigitalTuner.qml \
    qml/components/ButtonsContainer.qml \
    qml/components/Button.qml \
    qml/components/AnalogMeter.qml \
    skin-chooser/skin_retro.jpg \
    skin-chooser/skin_classic.jpg \
    skin-chooser/SkinChooser.qml \
    skin-chooser/FirstTimeView.qml

target.path += /opt/fmradio-free/
INSTALLS += target

desktop_file.target  = desktop_file
desktop_file.files   = fmradio.desktop
desktop_file.path    = $$APP_INSTALL_ROOT/usr/share/applications
INSTALLS += desktop_file

desktop_icon.files   = fmradio80.png
desktop_icon.path    = $$APP_INSTALL_ROOT/usr/share/icons/hicolor/80x80/apps
INSTALLS += desktop_icon

resource_conf.files   = fmradio.conf
resource_conf.path    = $$APP_INSTALL_ROOT/usr/share/policy/etc/syspart.conf.d
INSTALLS += resource_conf

