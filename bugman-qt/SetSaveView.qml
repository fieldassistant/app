import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    implicitHeight: 900
    implicitWidth: 520
    
    property var entrySet
    property string name: entrySet.name
    property string set_id: entrySet.set_id
    
    function onExport() {
        dialog.path = App.exportSet(fileNameField.text, root.set_id)
        
        if (dialog.path) {
            dialog.open();
        }
        // or error?
    }
    
    Column {
        spacing: 15
        anchors.fill: parent
        
        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 80
            
            Text {
                text: qsTr("Export: %1").arg(root.name)
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                padding: 10
                font.pointSize: Theme.fontSubtitle
            }
        }
        
        StringField {
            id: fileNameField
            anchors.left: parent.left
            anchors.right: parent.right
            
            label: qsTr("File name")
            placeholder: root.name + ".zip"
            
            validMessage: qsTr("Exists")
            valid: !App.exportPathExists(text)
            
            Binding on text {
                property: "text"
                value: root.name + ".zip"
            }
        }
        
        Button {
            text: qsTr("Export")
            highlighted: true
            anchors.left: parent.left
            anchors.leftMargin: 30
            
            onClicked: onExport()
        }
    }
    
    Dialog {
        id: dialog
        title: qsTr("Exported %1").arg(name)
        
        property string path
        
        width: 320
        standardButtons: Dialog.Ok
        
//        Keys.onBackPressed: {
//            console.log("dialog back")
//            event.accepted = true;
//            visible ? reject() : close();
//        }
        
        Text {
            id: content
            text: qsTr("File saved as: \"%1\"").arg(dialog.path)
            elide: Text.ElideRight
            font.pointSize: Theme.fontBody
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: parent.width
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:580;width:320}
}
##^##*/
