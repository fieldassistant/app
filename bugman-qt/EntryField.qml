import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    implicitWidth: 200
    implicitHeight: labelText.height + editHeight + 5
    height: implicitHeight
    
    property string label: "??"
    property string placeholder: "..."
    property string type: "string"
    property alias text: stringField.text
    
    readonly property int editHeight:
        stringField.visible ? stringField.height
        : intField.visible ? intField.height
        : realField.visible ? realField.height
        : textField.visible ? textField.height
        : rangeField.visible ? rangeField.height
        : listField.visible && listField.height
    
    Label {
        id: labelText
        text: root.label
        anchors.left: parent.left
    }
    
    TextField {
        id: stringField
        visible: !type || type === "string"
        enabled: visible
        
        anchors.topMargin: 5
        anchors.top: labelText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        
        placeholderText: placeholder
        text: root.text
        onTextChanged: root.text = text
    }
    
    SpinBox {
        id: intField
        visible: type === "integer"
        enabled: visible
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 5
        anchors.top: labelText.bottom
        
        editable: true
        value: +root.text
        onValueChanged: {
            if (enabled) root.text = value + ""
        }
    }
    
    TextField {
        id: realField
        visible: type === "decimal"
        enabled: visible
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 5
        anchors.top: labelText.bottom
        
        text: root.text
        onTextChanged: root.text = text
        font.pointSize: Theme.fontBody
        
        validator: DoubleValidator {}
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }
    
    TextArea {
        id: textField
        visible: type === "text"
        enabled: visible
        
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 5
        anchors.top: labelText.bottom
        
        text: root.text
        onTextChanged: root.text = text
        placeholderText: placeholder
    }
    
    Switch {
        id: boolField
        visible: type === "switch"
        enabled: visible
        
        anchors.left: labelText.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        
        padding: 0
        checked: root.text === "yes"
//        checked: true
        onCheckedChanged: root.text = checked ? "yes" : "no"
    }
    
    Slider {
        id: rangeField
        visible: type === "range"
        anchors.right: parent.right
        anchors.topMargin: 5
        anchors.top: labelText.bottom
    }
    
    ComboBox {
        id: listField
        visible: type === "list"
        enabled: visible
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 5
        anchors.top: labelText.bottom
        
        model: ["one", "two", "three"]
        currentIndex: Math.max(0, model.indexOf(root.text))
        
        onCurrentIndexChanged: {
            if (enabled) root.text = model[currentIndex]
        }
    }
}

