import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    id: root
    visible: true
    title: qsTr("Bugman")
    
    height: 720
    width: 520
    color: Theme.colorStone
    
//    onClosing: {
//        close.accepted = Navigation.isExitReady;
//        Navigation.goBack();
//    }
    
    Header {
        id: header
        
        anchors.left: parent.left
        anchors.right: parent.right
        z: 100
        
        active: nav.depth > 1
        onBack: nav.pop()
        onAbout: nav.push("AboutView.qml")
    }
    
    StackView {
        id: nav
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        
        initialItem: "HomeView.qml"
        
        Keys.onBackPressed: {
            event.accepted = nav.depth > 1
            nav.pop();
        }
        
//        HomeView {
//            id: homeView
//        }
        
//        AboutView {
//            id: aboutView
//        }
        
//        EntryEditView {
//            id: entryEditView
//        }
        
//        SetEditView {
//            id: setEditView
//        }
        
//        SetSaveView {
//            id: saveSetView
//        }
    }
}


