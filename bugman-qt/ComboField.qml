import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    implicitHeight: labelText.height + editField.height + 5
    implicitWidth: 200
    
    property string label: ""
    property var model: ([])
    property string current: ""
    
    Binding {
        target: root
        when: current !== editField.currentText
        property: "current"
        value: editField.currentText
    }
    
    onModelChanged: {
        if (!current) current = model[0] || "";
    }
    
    Label {
        id: labelText
        text: root.label || "Label*"
        anchors.right: parent.right
        anchors.left: parent.left
    }
    
    ComboBox {
        id: editField
        anchors.top: labelText.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.left: parent.left
        
        model: root.model
        currentIndex: Math.max(0, model.indexOf(current))
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:200}
}
##^##*/
