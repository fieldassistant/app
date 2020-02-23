import QtQuick 2.12
import QtQuick.Templates 2.12 as T

T.SpinBox {
    id: control
    
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentItem.implicitWidth + leftPadding + rightPadding +
                            up.implicitIndicatorWidth +
                            down.implicitIndicatorWidth)
    implicitHeight: Math.max(implicitContentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight,
                             up.implicitIndicatorHeight,
                             down.implicitIndicatorHeight)
    
    spacing: 6
    padding: 6
    leftPadding: 30
    rightPadding: padding + down.indicator.width  + up.indicator.width + spacing
    
    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }
    
    font.pointSize: Theme.fontBody
    
    contentItem: TextInput {
        z: 2
        text: control.textFromValue(control.value, control.locale)
        verticalAlignment: Text.AlignVCenter
        
        font: control.font
        color: Theme.colorText
        selectionColor: Theme.colorBee
        selectedTextColor: "white"
        
        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
        
    }

    up.indicator: Rectangle {
        x: parent.width - width
        implicitHeight: 40
        height: parent.height
        width: height
        color: control.up.pressed ? Theme.colorBee : Theme.colorCloud
        radius: 5

        Text {
            text: "+"
            font: control.font
            color: enabled ? Theme.colorText : Theme.colorBrick
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    
    down.indicator: Rectangle {
        x: parent.width - width * 2
        implicitHeight: 40
        height: parent.height
        width: height
        color: control.down.pressed ? Theme.colorBee : Theme.colorCloud
        radius: 5
        
        Text {
            text: "-"
            font: control.font
            color: enabled ? Theme.colorText : Theme.colorBrick
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    
    background: Rectangle {
        implicitWidth: 160
        implicitHeight: 40
        color: Theme.colorCloud
        radius: 5
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:50;width:200}
}
##^##*/
