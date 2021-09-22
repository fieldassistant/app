import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

Frame {
    id: root
//    implicitWidth: 420
//    implicitHeight: 420
    
    signal update()
    
    property var images: []
    
    function open() {
        enabled = true;
        forceActiveFocus();
    }
    
    function close() {
        enabled = false;
        root.update();
    }
    
    function addImage(image) {
        root.images.push(image);
        root.imagesChanged();
    }
    
    parent: Window.contentItem
    anchors.fill: parent
    padding: 0
    enabled: false
    visible: enabled
    
    background: Rectangle { color: '#fff' }
    
    Keys.onBackPressed: {
        event.accepted = true;
        close();
    }

    Rectangle {
        id: header
        color: '#fff'
        height: row.height + 20
        width: root.width
        z: 10
        
        Row {
            id: row
            anchors.fill: parent
            anchors.margins: 10
            height: closeButton.height
            spacing: 10
            
            Button {
                id: closeButton
                flat: true
                
                icon.source: "/icons/back.svg"
                width: height
                
                onClicked: root.close()
            }
            
            Text {
                id: titleText
                text: "Images"
                verticalAlignment: Text.AlignVCenter
                font.pointSize: Theme.fontBody
                height: closeButton.height
            }
        }
    }

    
    GridView {
        id: grid
        anchors.fill: parent
        anchors.topMargin: header.height
        
        cellWidth: (width + spacing) / Math.floor(width / 100) - spacing
        cellHeight: cellWidth
        
        model: App.images
        
        delegate: EntryImage {
            width: grid.cellWidth
            height: grid.cellHeight
            padding: 5
            
            source: modelData
            checked: root.images.indexOf(modelData) >= 0
            onClicked: imagePreview.open(modelData)
        }
    }
    
    EntryImagePreview {
        id: imagePreview
        checkable: true
        
        images: App.images
        selection: root.images
        onSelectionChanged: root.imagesChanged()
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
