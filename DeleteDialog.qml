import QtQuick 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

Dialog {
    id: root
    
    property var target
    property string text: qsTr("Delete \"%1\", are you sure?").arg(root.target)
    
    Connections {
        target: Navigation
        function onCloseDialog() {
            if (root.visible) root.reject();
            else root.close();
        }
    }
    
    onVisibleChanged: {
        Navigation.hasDialog = root.visible
        
        if (root.visible) {
            deleteButton.enabled = false
            timer.start()
        }
    }
    
    Timer {
        id: timer
        interval: 800
        running: false
        repeat: false
        onTriggered: {
            deleteButton.enabled = true
        }
    }
    
    Text {
        text: root.text
        wrapMode: Text.WordWrap
        font.pointSize: Theme.body
        anchors.fill: parent
        width: 280
    }
    
    footer: DialogButtonBox {
        
        Button {
            id: deleteButton
            text: qsTr("Delete")
            highlighted: true
            enabled: false
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
        
        Button {
            id: cancelButton
            text: qsTr("Wait no!")
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
