import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtGraphicalEffects 1.12

T.Switch {
    id: control
    
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    
    padding: 6
    spacing: 6
    
    contentItem: Label {
        
    }
    
    background: Rectangle {
        id: background
        color: control.checked ? Theme.colorBee : Theme.colorBrick
        implicitWidth: 46
        implicitHeight: 26
        x: control.leftPadding
        y: control.height / 2 - height / 2
        radius: 14
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    indicator: Rectangle {
        id: indicator
        y: background.y + 3
        x: background.x + (control.checked ? background.width - width - 3 : 3)
        color: Theme.colorCloud
        radius: 10
        width: 20
        height: 20
        
        Behavior on x {
            PropertyAnimation {
                easing.type: Easing.OutCirc
            }
        }
        
        IconLabel {
            anchors.fill: parent
            anchors.margins: 2
            
            icon.source: "/icons/tick.svg"
            icon.color: Theme.colorBee
            
            opacity: control.checked ? 1 : 0
            
            Behavior on opacity {
                PropertyAnimation { duration: 100 }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:100}
}
##^##*/
