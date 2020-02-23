import QtQuick 2.12
import QtQuick.Controls 2.12

import "EntryModel.js" as EntryModel

Item {
    id: root
    
    property var entrySet: EntryModel.data[0]
    
    implicitWidth: 520
    implicitHeight: 600
    
    function onNewEntry() {
        nav.push("EntryEditView.qml", { entrySet });
    }
    
    function onExportSet() {
        nav.push("SetSaveView.qml", { entrySet });
    }
    
    function onEditSet() {
        nav.push("SetEditView.qml", { entrySet });
    }
    
    Item {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        
        implicitHeight: Math.max(title.height, buttons.height)
        
        Text {
            id: title
            text: entrySet.name || "??"
            font.pointSize: Theme.fontSubtitle
        }
        
        Row {
            id: buttons
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            
            Button {
                id: addButton
                flat: true
                icon.source: "icons/plus.svg"
                onClicked: onNewEntry()
            }
            
            Button {
                id: saveButton
                flat: true
                icon.source: "icons/download.svg"
                onClicked: onExportSet()
            }
            
            Button {
                id: editButton
                flat: true
                icon.source: "icons/pencil.svg"
                onClicked: onEditSet()
            }
            
            Button {
                id: deleteButton
                flat: true
                icon.source: "icons/trash.svg"
                onClicked: deleteDialog.open()
            }
        }
    }
    
    ListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        
        spacing: -45
        clip: true
        focus: false
        
        model: entrySet.entries
        
        delegate: EntryBlock {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            entry: modelData
        }
    }
    
    Button {
        anchors.centerIn: parent
        visible: entrySet.entries.length === 0
        text: qsTr("Add Entry")
        highlighted: true
        onClicked: onNewEntry()
    }
    
    DeleteDialog {
        id: deleteDialog
        title: qsTr("Delete Set")
        target: entrySet.name
        
        onAccepted: {
            const index = App.removeSet(entrySet.set_id);
            nav.replace(null, "HomeView.qml", { index });
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
