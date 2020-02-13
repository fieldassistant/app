import QtQuick 2.14
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

Item {
    id: root
//    implicitWidth: 420
//    implicitHeight: 420
    
    parent: Window.contentItem
    anchors.fill: parent
    enabled: false
    visible: false
    
    signal update()
    
    property var images: []
    property int offset: flick.height
    
    Connections {
        target: Navigation
        onCloseDialog: root.close()
    }
    
    onEnabledChanged: {
        Navigation.hasDialog = root.enabled
    }
    
    function open() {
        offset = flick.height - 300
        enabled = true
        visible = true
    }
    
    function close() {
        if (camera.fullscreen) {
            camera.close()
        }
        else {
            enabled = false;
            offset = flick.height;
            flick.contentY = 0;
            root.update();
        }
    }
    
    function onToggleImage(image, toggle) {
        const index = root.images.indexOf(image);
        if (index >= 0 && !toggle) {
            root.images.splice(index, 1);
        }
        else {
            root.images.push(image);
        }
        root.imagesChanged();
    }
    
    function onAddImage(image) {
        root.images.push(image);
        root.imagesChanged();
    }
    
    Behavior on offset {
        PropertyAnimation {
            easing.type: Easing.OutCirc
            duration: 200
            
            onFinished: {
                if (!root.enabled) {
                    root.visible = false
                }
            }
        }
    }
    
    Binding {
        target: header
        property: "y"
        value: Math.max(0, -flick.contentY + offset)
    }
    
    Rectangle {
        id: header
        color: "#fff"
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
    
    Flickable {
        id: flick
        clip: true
        
        flickableDirection: Flickable.VerticalFlick
        height: root.height
        width: root.width
        
        onDragEnded: {
            if (contentY < -50) {
                root.close();
            }
        }
        
        contentHeight: content.implicitHeight
        contentWidth: content.implicitWidth
        
        Rectangle {
            id: content
            color: "#fff"
            implicitHeight: grid.height + header.height + 450
            implicitWidth: flick.width
            y: offset
            
            Grid {
                id: grid
                columns: 4
                columnSpacing: 10
                rowSpacing: 10
                anchors.top: parent.top
                anchors.topMargin: header.height
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.margins: 10
                
                property int itemWidth: {
                    var spacing = (grid.columns - 1) * grid.rowSpacing;
                    return (grid.width - spacing) / grid.columns;
                }
                
                Camera {
                    id: camera
                    width: grid.itemWidth
                    height: width
                    z: 15
                    layer.enabled: true
                    onCaptured: root.onAddImage(image)
                }
                
                Repeater {
                    model: App.images
                    
                    delegate: EntryImage {
                        width: grid.itemWidth
                        height: width
                        source: modelData
                        overlay: imageOverlay
                        checked: images.indexOf(modelData) >= 0
                        onToggled: root.onToggleImage(modelData, keep)
                    }
                }
                
//                Repeater {
//                    model: 40
//                    delegate: Rectangle {
//                        color: "#000"
//                        width: grid.itemWidth
//                        height: width
//                    }
//                }
            }
        }
    }
    
    EntryImagePreview {
        id: imageOverlay
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
