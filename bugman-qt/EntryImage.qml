import QtQuick 2.12

Item {
    id: root
    
    signal clicked()
    
    property string source
    property bool checked: false
    property int padding: 0
    
    // Add a checked icon.
    
    Image {
        id: image
        source: root.source
        
        asynchronous: true
        autoTransform: true
        cache: false
        sourceSize.width: width * 1.4
        sourceSize.height: height * 1.4
        
        x: padding
        y: padding
        width: parent.width - padding * 2
        height: parent.height - padding * 2
        fillMode: Image.PreserveAspectCrop
        
        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
        
        CircleButton {
            size: 25
            source: "/icons/tick.svg"
            checkable: true
            highlighted: true
            checked: true
            enabled: false
            visible: root.checked
            
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10
        }
    }
}
