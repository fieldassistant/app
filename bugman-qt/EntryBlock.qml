import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import "EntryModel.js" as EntryModel

Frame {
    id: root
    
    implicitWidth: 520
    implicitHeight: tab.height + body.height + offset
    
    property var entry: EntryModel.data[0].entries[0]
    property int offset: root.focus ? 60 : 0
    
    function onRemove() {
        const index = App.removeEntry(entry.entry_set_id, entry.entry_id);
        nav.replace(null, "HomeView.qml", { index });
    }
    
    function onEdit() {
        nav.push("EntryEditView.qml", { entry });
    }
    
    background: Rectangle { visible: false }
    
    transform: Rotation {
        id: rotation
        angle: root.focus ? 0 : -10
        axis: "1,0,0"
        origin.x: body.width / 2
        
        Behavior on angle {
            PropertyAnimation {
                easing.type: Easing.OutCirc
                duration: 300
            }
        }
    }
    
    Behavior on offset {
        PropertyAnimation {
            easing.type: Easing.OutCirc
            duration: 300
        }
    }
    
    DropShadow {
        anchors.fill: tab
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10.0
        samples: 17
        color: "#30000000"
        source: tab
    }
    
    DropShadow {
        anchors.fill: body
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10.0
        samples: 17
        color: "#30000000"
        source: body
    }
    
    Item {
        id: tab
        enabled: true
        anchors.top: parent.top
        anchors.left: parent.left
        
        implicitHeight: voucherText.height
        implicitWidth: voucherText.width
        
        MouseArea {
            anchors.fill: parent
            enabled: true
            onClicked: {root.focus = !root.focus}
        }
        
        Rectangle {
            id: tabBg
            color: root.focus ? Theme.colorCloud : Theme.colorPutty
            radius: 8
            border.width: 0
            anchors.fill: parent
            anchors.bottomMargin: -30
        }
        
        Text {
            id: voucherText
            text: entry.voucher || "??"
            font.weight: Font.Bold
            bottomPadding: 5
            topPadding: 5
            rightPadding: 60
            leftPadding: 10
            anchors.top: parent.top
            font.pixelSize: 20
        }
    }
    
    Item {
        id: body
        clip: true
        anchors.right: parent.right
        anchors.top: tab.bottom
        anchors.left: parent.left
        
        enabled: root.focus
        
        implicitHeight: root.focus
            ? detailBox.height
            : previewBox.height
        
        Behavior on implicitHeight {
            PropertyAnimation {
                easing.type: Easing.OutCirc
                duration: 300
            }
        }
        
        Rectangle {
            id: bodyBg
            color: root.focus ? Theme.colorCloud : Theme.colorPutty
            radius: 10
            anchors.fill: parent
            border.color: "#00000000"
            border.width: 0
        }
        
        Text {
            id: previewBox
            text: qsTr("%1 / %2")
                .arg(Qt.formatDateTime(new Date(+entry.timestamp), "dd MMM yyyy / HH:mm"))
                .arg(entry.collector)
            verticalAlignment: Text.AlignTop
            padding: 10
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.left: parent.left
            font.pointSize: Theme.fontSmall
            height: 100
            
            opacity : root.focus ? 0 : 1
            
            Behavior on opacity {
                PropertyAnimation { duration: 100 }
            }
        }
        
        ColumnLayout {
            id: detailBox
            spacing: 10
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            
            opacity : root.focus ? 1 : 0
            
            Behavior on opacity {
                PropertyAnimation { duration: 100 }
            }
            
            Column {
                id: detailRows
                spacing: 5
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumHeight: 100
                
                EntryBlockItem {
                    name: "Voucher"
                    value: entry.voucher
                }
                
                EntryBlockItem {
                    name: "Date"
                    value: Qt.formatDateTime(new Date(+entry.timestamp), "dd MMM yyyy - HH:mm")
                }
                
                
                EntryBlockItem {
                    name: "Collector"
                    value: entry.collector
                }
                
                EntryBlockItem {
                    name: "Position"
                    value: qsTr("%1, %2 @ %3m")
                        .arg(entry.position.latitude.toFixed(5))
                        .arg(entry.position.longitude.toFixed(5))
                        .arg(entry.position.altitude.toFixed(0))
                }
                
                Repeater {
                    model: entry.fields
                    delegate: EntryBlockItem {
                        item: modelData
                        
                    }
                }
            }
            
            Grid {
                id: grid
                spacing: 10
                Layout.fillWidth: true
                
                Repeater {
                    model: root.entry.images.slice(0)
                    
                    delegate: EntryImage {
                        width: 120
                        height: width
                        source: modelData
                        onClicked: imagePreview.open(modelData)
                    }
                }
            }
            
            Row {
                id: buttonBox
                Layout.topMargin: 10
                Layout.bottomMargin: 20
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                spacing: 10
                
                Button {
                    id: editButton
                    text: qsTr("Edit")
                    flat: true
                    onClicked: onEdit()
                    icon.source: "icons/pencil.svg"
                    width: height
                }
                
                Button {
                    id: deleteButton
                    text: qsTr("Delete")
                    flat: true
                    onClicked: deleteDialog.open()
                    icon.source: "icons/trash.svg"
                    width: height
                }
            }
        }
    }
    
    EntryImagePreview {
        id: imagePreview
        checkable: false
        images: entry.images.slice(0)
        selection: images
    }
    
    DeleteDialog {
        id: deleteDialog
        title: "Delete Entry"
        target: entry.voucher
        
        onAccepted: onRemove()
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
