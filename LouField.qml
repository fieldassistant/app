import QtQuick 2.12
import QtQuick.Controls 2.13

Item {
    id: root
    implicitHeight: labelText.height + textField.height + 5
    implicitWidth: 200
    height: implicitHeight
    
    property string label: ""
    property string placeholder: "..."
    property string type: "string"
    property alias text: textField.text
    property alias readOnly: textField.readOnly
    readonly property alias editHeight: textField.implicitHeight
    
    Text {
        id: labelText
        text: root.label || "Label*"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 30
        font.pointSize: Theme.body
    }
    
    TextField {
        id: textField
        anchors.top: labelText.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.left: parent.left
        placeholderText: placeholder
        leftPadding: 30
        font.pointSize: Theme.body
        
        background: Rectangle {
            radius: 5
            color: Theme.cloud
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:200}
}
##^##*/
