#!/bin/bash
qdbusxml2cpp -v -c FMRadioInterface -p fmradiointerface fmradio-backend.xml com.nnaabbcc.fmradio

qdbusxml2cpp -v -c FMRadioAdaptor -a fmradioadaptor fmradio-backend.xml com.nnaabbcc.fmradio

