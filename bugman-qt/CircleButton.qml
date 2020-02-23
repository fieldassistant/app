import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: root
    
    property string source
    property int size: 50
    
    width: size
    height: size
    flat: true
    checkable: false
    checked: true
    icon.source: !checkable || checked ? root.source : ""
    icon.color: "white"
    
    background: Rectangle {
        anchors.fill: parent
        color: !checkable || checked
            ? highlighted
                ? Theme.colorBee
                : Theme.colorBrick
            : "transparent"
        radius: 25
        border.width: 3
        border.color: highlighted
            ? Theme.colorBee
            : Theme.colorBrick
    }
}
