import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtPositioning 5.12

import "EntryModel.js" as EntryModel

Item {
    id: root
    implicitHeight: 720
    implicitWidth: 420
    
    property var entrySet
    property var entry: ({})
    
    // Perhaps we could just prefill the 'entry' property?
    property int entry_id: entry.entry_id || App.nextEntryId()
    property int entry_set_id: entry.entry_set_id || entrySet.set_id || 0
    property string voucher: entry.voucher || entrySet.getNextVoucher()
    property var position: entry.position || gps.position.coordinate
    property string timestamp: entry.timestamp || +new Date() + ""
    property string collector: entry.collector || entrySet.collector
    property var images: (entry.images || []).slice(0)
    property var fields: (entry.fields || entrySet.fields).slice(0)
    
    property bool isEditing: !entry
    property int invalid: 0
    
    readonly property int validName: 1
    readonly property int validCollector: 2
    
    function onCreate() {
        if (entry_set_id === 0) {
            console.warn("Missing set_id.");
            return;
        }
        
        root.invalid =
            (!voucher ? validName : 0) |
            (!collector ? validCollector : 0);
        
        if (root.invalid) return;
        
        console.log("save entry", entry_id, entry_set_id)
        
        // It appears the QCoordinate object is a bit funny as a QVariant.
        // Here we instead create a jsobject version of it.
        const {latitude, longitude, altitude} = position;
        
        const index = App.setEntry({
            entry_id,
            entry_set_id,
            voucher,
            timestamp,
            position: { latitude, longitude, altitude },
            collector,
            images,
            fields,
        });
        
        nav.replace(null, "HomeView.qml", { index });
    }
    
    onPositionChanged: {
        console.log("update", position)
    }
    
    PositionSource {
        id: gps
        updateInterval: 5000
        onUpdateTimeout: console.log("GPS timeout")
        onPositionChanged: {
            entry.position = gps.position.coordinate
        }
    }
    
    ColumnLayout {
        spacing: 10
        anchors.fill: parent
        anchors.margins: 10
        
        Text {
            id: title
            text: isEditing
                  ? qsTr("Edit %1").arg(voucher) 
                  : qsTr("New Entry")
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            padding: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
        }

        ListView {
            id: listView
            clip: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 15
            
            header: Column {
                spacing: 15
                anchors.right: parent.right
                anchors.left: parent.left
                
                StringField {
                    id: voucherField
                    anchors.right: parent.right
                    anchors.left: parent.left
                    label: qsTr("Voucher *")
                    placeholder: "NAT01R001"
                    text: voucher
                    onTextChanged: {
                        voucher = text;
                        invalid &= ~validName;
                    }
                    valid: !(root.invalid & validName)
                }
                
                StringField {
                    id: datetimeField
                    anchors.right: parent.right
                    anchors.left: parent.left
                    label: qsTr("Date & Time *")
                    readOnly: true
                    text: Qt.formatDateTime(new Date(+timestamp), "dd/MM/yyyy HH:mm")
                }
                
                StringField {
                    id: positionField
                    label: qsTr("Position *")
                    readOnly: true
                    text: qsTr("%1, %2 @ %3m")
                        .arg(position.latitude.toFixed(5))
                        .arg(position.longitude.toFixed(5))
                        .arg(position.altitude.toFixed(0))
                    
                    anchors.right: parent.right
                    anchors.left: parent.left
                    rightPadding: refreshButton.width
                    
                    Button {
                        id: refreshButton
                        
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        flat: true
                        width: height
                        icon.source: "/icons/refresh.svg"
                        
                        enabled: !isEditing
                        onClicked: gps.update()
                    }
                }
                
                StringField {
                    id: collectorField
                    anchors.right: parent.right
                    anchors.left: parent.left
                    label: qsTr("Collector *")
                    placeholder: qsTr("N. A. Thornberry")
                    text: collector
                    onTextChanged: {
                        collector = text;
                        invalid &= ~validCollector;
                    }
                    valid: !(root.invalid & validCollector)
                }
                
                Rectangle {
                    color: "transparent"
                    anchors.right: parent.right
                    anchors.left: parent.left
                    height: 1
                }
            }
            
            model: fields
            
            delegate: EntryField {
                anchors.right: parent.right
                anchors.left: parent.left
                label: modelData.name
                text: modelData.value || ""
                type: modelData.type
                
                onTextChanged: {
                    fields[index].value = text
                }
            }
            
            footer: Column {
                id: footer
                spacing: 10
                anchors.left: parent.left
                anchors.right: parent.right
                
                Text {
                    text: qsTr("Images")
                    topPadding: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    font.pointSize: Theme.fontBody
                }
                
                Grid {
                    id: grid
                    spacing: 10
                    
                    anchors.left: parent.left
                    anchors.right: parent.right
                    
                    columns: Math.floor(width / 100)
                    property int itemWidth: (width + spacing) / columns - spacing
                    
                    Button {
                        id: imageButton
                        background: Rectangle {
                            color: Theme.colorCloud
                        }
                        flat: true
                        icon.source: "icons/plus.svg"
                        icon.color: Theme.colorBrick
                        width: grid.itemWidth
                        height: width
                        icon.width: width / 2
                        icon.height: width / 2
                        onClicked: imageDialog.open()
                    }
                    
                    Repeater {
                        model: root.images
                        
                        delegate: EntryImage {
                            width: grid.itemWidth
                            height: width
                            source: modelData
                            checked: true
                            onClicked: imagePreview.open(modelData)
                        }
                    }
                }
            }
        }
        
        Button {
            id: createButton
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: isEditing ? qsTr("Save") : qsTr("Create")
            highlighted: true
            enabled: !root.invalid
            onClicked: onCreate()
        }
    }
    
    CircleButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 25
        
        highlighted: true
        source: "icons/focus.svg"
        onClicked: {
            camera.active = true
        }
    }
    
    Loader {
        id: camera
        active: false
        sourceComponent: Camera {
            onCaptured: {
                console.log('SNAP:', image);
                root.images.unshift(image);
            }
            onClose: {
                camera.active = false;
                root.imagesChanged();
                App.refreshImages();
                gc();
            }
        }
    }
    
    EntryImagePreview {
        id: imagePreview
        checkable: true
        
        images: root.images.slice(0)
        selection: root.images
        onSelectionChanged: root.imagesChanged()
    }
    
    ImagePicker {
        id: imageDialog
        
        images: root.images
        onUpdate: root.imagesChanged()
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:720;width:420}
}
##^##*/
