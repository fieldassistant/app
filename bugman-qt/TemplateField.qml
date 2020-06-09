import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQml.Models 2.12

Rectangle {
    id: root
    
    signal remove()
    signal edited()
    
    property string name: "thing"
    property string type: "type"
    property bool highlighted: false
    property bool hovered: false
    
    implicitHeight: swiper.implicitHeight
    implicitWidth: swiper.implicitWidth + 20 + handle.width
    
    color: highlighted
        ? Theme.colorBrick
        : hovered
        ? Theme.colorCloud
        : Theme.colorPutty
    
    border.width: 0
    radius: 5
    clip: true
    
    Timer {
        id: timer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            swiper.swipe.close()
        }
    }
    
    Image {
        id: handle
        height: parent.height / 3
        width: height
        
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        
        source: "icons/grip-2.svg"
    }
    
    SwipeDelegate {
        id: swiper
        
        anchors.left: handle.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        
        swipe.onOpened: {
            timer.start()
        }
        
        swipe.right: Item {
            id: controls
            anchors.right: parent.right
            height: root.implicitHeight
            width: row.implicitWidth
            
            Rectangle {
                color: Theme.colorBrick
                radius: 5
                anchors.fill: parent
                anchors.leftMargin: -10
            }

            Row {
                id: row
                anchors.verticalCenter: parent.verticalCenter
                
                leftPadding: 10
                rightPadding: 10
                spacing: 15
                
                Button {
                    display: AbstractButton.IconOnly
                    flat: true
                    text: qsTr("Edit")
                    icon.source: "icons/pencil.svg"
                    width: height
                    onClicked: {
                        editDialog.open()
                        timer.stop()
                    }
                }
                
                Button {
                    display: AbstractButton.IconOnly
                    flat: true
                    text: qsTr("Delete")
                    icon.source: "icons/trash.svg"
                    width: height
                    onClicked: {
                        deleteDialog.open()
                        timer.stop()
                    }
                }
            }
        }
        
        background: Rectangle {
            width: parent.width
            height: parent.height
            border.width: 0
            radius: 5
            
            color: root.color
        }
        
        contentItem: Column {
            id: column
            
            Text {
                font.pointSize: Theme.fontBody
                text: root.name
            }
            Text {
                font.pointSize: Theme.fontSmall
                text: root.type
            }
        }
    }
    
    TemplateFieldDialog {
        id: editDialog
        
        name: root.name
        type: root.type
        
        onAccepted: {
            root.name = name
            root.type = type
            root.edited()
            swiper.swipe.close()
        }
        
        onRejected: {
            name = root.name
            type = root.type
            swiper.swipe.close()
        }
    }
    
    DeleteDialog {
        id: deleteDialog
        title: "Delete Field"
        target: root.name
        onAccepted: {
            root.remove()
            swiper.swipe.close()
        }
        onRejected: swiper.swipe.close()
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:70;width:640}
}
##^##*/
