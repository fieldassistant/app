import QtQuick 2.12
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    
    signal clicked()
    
    property string text: "thing"
    property string subtext: "type"
    
    implicitHeight: wrapper.implicitHeight + 20
    implicitWidth: wrapper.implicitWidth + 20
    border.width: 0
    radius: 5
    
    color: Theme.colorCloud
    
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
    
    Item {
        id: wrapper
        anchors.fill: parent
        anchors.margins: 10
        
        implicitHeight: column.implicitHeight
        implicitWidth: column.implicitWidth
        
        Column {
            id: column
            
            Text {
                text: root.text
                font.pointSize: Theme.fontBody
            }
            Text {
                text: root.subtext
                font.pointSize: Theme.fontSmall
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:640}
}
##^##*/
