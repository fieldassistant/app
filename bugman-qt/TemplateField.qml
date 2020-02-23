import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQml.Models 2.12

Rectangle {
    id: root
    
    signal remove()
    signal edited()
    
    property string name: "thing"
    property string type: "type"
    property bool highlighted: false
    property bool hovered: false
    
    implicitHeight: wrapper.implicitHeight + 20
    implicitWidth: wrapper.implicitWidth + 20
    border.width: 0
    radius: 5
    
    color: highlighted
        ? Theme.colorBrick
        : hovered
        ? Theme.colorCloud
        : Theme.colorPutty
    
    Behavior on color {
        ColorAnimation { duration: 100 }
    }
    
    Item {
        id: wrapper
        anchors.fill: parent
        anchors.margins: 10
        
        implicitHeight: column.height
        implicitWidth: column.implicitWidth + 40 + row.width
        
        Column {
            id: column
            anchors.left: parent.left
            anchors.right: row.left
            
            
            Text {
                font.pointSize: Theme.fontBody
                text: root.name
            }
            Text {
                font.pointSize: Theme.fontSmall
                text: root.type
            }
        }
        
        Row {
            id: row
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            
            Button {
                display: AbstractButton.IconOnly
                flat: true
                text: qsTr("Edit")
                icon.source: "icons/pencil.svg"
                width: height
                onClicked: editDialog.open()
            }
            
            Button {
                display: AbstractButton.IconOnly
                flat: true
                text: qsTr("Delete")
                icon.source: "icons/trash.svg"
                width: height
                onClicked: deleteDialog.open()
            }
        }
    }
    
    TemplateFieldDialog {
        id: editDialog
        
        name: root.name
        type: root.type
        
        onAccepted: {
            root.name = name
            root.type = type
            root.edited()
        }
        
        onRejected: {
            name = root.name
            type = root.type
        }
    }
    
    DeleteDialog {
        id: deleteDialog
        title: "Delete Field"
        target: root.name
        onAccepted: root.remove()
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:640}
}
##^##*/
