import QtQuick 2.12
import QtQuick.Controls 2.12

Dialog {
    id: root
    
    property string name: ""
    property string type: ""
    property bool valid: !!name
    
    title: qsTr("Edit Field")
    
    Column {
        id: content
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 15
        
        StringField {
            id: nameEdit
            label: qsTr("Name")
            placeholder: "..."
            anchors.right: parent.right
            anchors.left: parent.left
            text: root.name
            
            Binding {
                target: root
                property: "name"
                value: nameEdit.text
            }
        }
        
        ComboField {
            id: typeEdit
            label: qsTr("Type")
            anchors.right: parent.right
            anchors.left: parent.left
            
            current: root.type
            model: ["string", "integer", "decimal", "switch", "text"]
            
            Binding {
                target: root
                property: "type"
                value: typeEdit.current
            }
        }
    }
    
    footer: DialogButtonBox {
        
        Button {
            id: saveButton
            text: qsTr("Save")
            highlighted: true
            enabled: valid
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
        
        Button {
            id: cancelButton
            text: qsTr("Cancel")
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
