import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

AbstractButton {
    id: control
    
    implicitWidth: Math.max(control.flat ? 0 : (leftInset + implicitBackgroundWidth + rightInset),
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    spacing: 6
    padding: 6
    horizontalPadding: control.flat ? padding : padding + 2
    
    font.pointSize: Theme.fontBody
    
    icon.height: 24
    icon.width: 24
    icon.color: control.enabled
        ? control.checked || control.highlighted && !control.flat
            ? "white" : Theme.colorText
        : Theme.colorBrick
    
    property bool flat: false
    property bool highlighted: false
    
//    enabled: false
//    text: "Button"
//    icon.source: "/icons/cross.svg"

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.flat ? AbstractButton.IconOnly : AbstractButton.TextBesideIcon
        
        font: control.font
        text: control.text
        icon: control.icon
        color: control.enabled ? "white" : Theme.colorBrick
    }
    
    background: Rectangle {
        implicitHeight: 40
        implicitWidth: 120
        
        visible: !control.flat || control.down
        radius: 5
        color: control.enabled
                ? control.down
                    ? Theme.colorStone
                    : control.highlighted
                        ? Theme.colorBee
                        : Theme.colorBrick
                : "transparent"
        
        border {
            width: 2
            color: control.enabled ? "transparent" : Theme.colorBrick
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
