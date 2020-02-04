import QtQuick 2.0

Row {
    id: root
    spacing: 5
    property var item: ({})
    property string name: item.name || "??"
    property string value: item.value || "??"
    
    
    Text {
        text: root.name + ": "
        font.italic: true
        font.letterSpacing: 0.5
        lineHeight: 1.3
        font.pointSize: Fonts.small
    }
    Text {
        text: root.value || "--"
        font.letterSpacing: 0.5
        lineHeight: 1.3
        font.pointSize: Fonts.small
    }
}
