// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Label {
    id: label
    property string newText

    NumberAnimation { id:fadeOut; target: label; property: "opacity"; to: 0; duration: 200 }
    NumberAnimation { id:fadeIn; target: label; property: "opacity"; to: 1; duration: 200 }

    onOpacityChanged:
    {
        if(opacity === 0)
        {
            text = newText
            fadeIn.start()
        }
    }

    onNewTextChanged: {
        fadeOut.stop()
        fadeIn.stop()
        if(opacity == 0)
        {
            text = newText
            fadeIn.start()
        }
        else
        {
            fadeOut.start()
        }
    }
}
