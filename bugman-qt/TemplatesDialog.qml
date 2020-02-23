import QtQuick 2.12
import QtQuick.Controls 2.12

Dialog {
    id: root
    
    signal accepted(var template)
    
    width: 320
    height: parent.height * 0.75
    
    title: qsTr("Templates")
    standardButtons: Dialog.Close
    
    ListView {
        id: contents
        spacing: 10
        anchors.fill: parent
        clip: true
        
        model: App.templates
        
        delegate: TemplateItem {
            text: modelData.name
            subtext: qsTr("%1 / %2 fields")
                .arg(modelData.author)
                .arg(modelData.fields.length)
            
            anchors.right: parent.right
            anchors.left: parent.left
            
            onClicked: {
                accepted(modelData)
                close()
            }
        }
    }
}

