import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12
import QtGraphicalEffects 1.0

Item {
    id: root
    
    implicitHeight: 700
    implicitWidth: 420
    
    signal captured(string image)
    signal close()
    
    property var preview: null
    property bool searching: false
    property bool captureAfterSearch: false
    property bool capturing: false
    
    function accept() {
        root.preview = null;
        const path = "file:///" + camera.imageCapture.capturedImagePath;
        root.captured(path);
    }
    
    function reject() {
        if (root.preview) {
            const path = camera.imageCapture.capturedImagePath;
            console.log("delete", path);
            App.removeFile(path);
        }
        
        camera.unlock();
        root.preview = null;
        root.searching = false;
    }
    
    function capture() {
        if (root.capturing) return;
        
        root.capturing = true;
        camera.imageCapture.cancelCapture();
        camera.imageCapture.captureToLocation(App.cameraPath);
    }
    
    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage
        position: Camera.BackFace
        
        focus {
            focusMode: CameraFocus.FocusManual
            focusPointMode: CameraFocus.FocusPointCenter
        }
        
        onLockStatusChanged: {
            if (lockStatus === Camera.Locked) {
                if (root.captureAfterSearch) {
                    root.capture();
                }
                else {
                    root.searching = false;
                }
            }
        }
        
        imageCapture {
            onImageCaptured: {
                root.preview = preview;
                camera.unlock();
                root.capturing = false;
                root.searching = false;
            }
            
            onCaptureFailed: {
                camera.unlock();
                root.capturing = false;
                root.searching = false;
            }
        }
    }
    
    Timer {
        id: timer
        running: false
        repeat: false
        interval: 500
        onTriggered: {
            if (camera.lockStatus === Camera.Unlocked) {
                root.searching = false;
            }
        }
    }
    
    Item {
        id: overlay
        parent: Window.contentItem
        anchors.fill: parent
        
        Button {
            id: exitButton
            flat: true
            highlighted: true
            icon.source: "/icons/cross.svg"
            icon.color: "white"
            x: 10; y: 10
            width: 40
            height: 40
            z: 3
            
            onClicked: close()
        }
        
        Image {
            id: focusIcon
            anchors.centerIn: parent
            z: 3
            
            visible: searching
            source: "/icons/focus.svg"
            width: 100
            height: 100
            
            ColorOverlay {
                source: focusIcon
                anchors.fill: parent
                color: "white"
                antialiasing: true
                smooth: true
            }
        }
        
        Image {
            id: previewImage
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            visible: !!preview
            source: preview || ""
            z: 2
        }
        
        Row {
            id: row
            anchors.bottomMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: parent.width - 200
            visible: !!preview
            z: 3
            
            CircleButton {
                id: rejectButton
                source: "/icons/cross.svg"
                onClicked: root.reject()
            }
            
            CircleButton {
                id: acceptButton
                highlighted: true
                source: "/icons/tick.svg"
                onClicked: root.accept()
            }
        }
    }
    
    VideoOutput {
        id: video
        source: camera
        parent: overlay
        width: parent.width
        height: parent.height
        fillMode: VideoOutput.PreserveAspectCrop
        autoOrientation: true
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (root.searching) {
                    root.captureAfterSearch = true;
                }
                else if (!root.preview) {
                    root.capture();
                }
            }
            
            onPressAndHold: {
                if (root.preview) return;
                
                camera.searchAndLock();
                root.searching = true;
//                timer.start();
            }
        }
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
