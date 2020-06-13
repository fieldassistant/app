import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

Frame {
    id: root
    
    signal update()
    
    property var images: ([])
    property var selection: images
    property var local: selection.slice(0)
    property bool checkable: false
    
    function close() {
        root.y = root.height;
        root.enabled = false;
        root.update();
    }
    
    function open(image = "") {
        swipeView.currentIndex = Math.max(0, images.indexOf(image));
        root.enabled = true;
        root.visible = true;
        root.forceActiveFocus();
        root.y = 0;
    }
    
    function toggle(image) {
        const index = root.selection.indexOf(image);
        
        if (index >= 0) {
            root.selection.splice(index, 1);
        }
        else {
            root.selection.push(image);
        }
        
        if (root.images.length == 0) {
            root.close();
        }
        else {
            root.local = root.selection.slice(0);
        }
    }
    
    function jump(image) {
        const index = root.images.indexOf(image);
        if (index >= 0) {
            swipeView.currentIndex = index;
        }
    }
    
    parent: Window.contentItem
    height: parent.height
    width: parent.width
    padding: 0
    enabled: false
    visible: false
    y: height
    
    background: Rectangle {
        anchors.fill: parent
        color: "black"
    }
    
    Keys.onBackPressed: {
        event.accepted = true;
        close();
    }
    
    Behavior on y {
        PropertyAnimation {
            easing.type: Easing.OutCirc
        }
    }
    
    SwipeView {
        id: swipeView
        anchors.fill: parent
        
        Repeater {
            model: root.images
            
            Loader {
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                
                sourceComponent: Item {
                    anchors.fill: parent
                    
                    Rectangle {
                        color: "black"
                        anchors.fill: parent
                    }
                    
                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "file:///" + modelData
                    }
                    
                    CircleButton {
                        id: toggleButton
                        checkable: true
                        visible: root.checkable
                        highlighted: true
                        source: "/icons/tick.svg"
                        
                        anchors.right: parent.right
                        anchors.rightMargin: 50
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 150
                        
                        checked: root.local.indexOf(modelData) >= 0
                        onClicked: root.toggle(modelData)
                    }
                }
            }
        }
    }
    
    Row {
        id: imageBar
        x: root.width / 2 - 55 - swipeView.currentIndex * 110
        anchors.bottom: parent.bottom
        height: 100
        spacing: 10
        
        Behavior on x {
            PropertyAnimation {
                easing.type: Easing.OutCirc
            }
        }
        
        Repeater {
            model: root.images
            
            Loader {
                active: index > swipeView.currentIndex - 6 &&
                        index < swipeView.currentIndex + 6
                width: 100
                height: 100
                
                EntryImage {
                    anchors.fill: parent
                    source: modelData
                    checked: root.local.indexOf(modelData) >= 0
                    onClicked: root.jump(modelData)
                }
            }
        }
    }
    
    Button {
        id: exitButton
        flat: true
        highlighted: true
        icon.source: "/icons/cross.svg"
        icon.color: "white"
        width: 40
        height: 40
        x: 10
        y: 10
        onClicked: root.close()
    }
    
    // Page indicator?
}

