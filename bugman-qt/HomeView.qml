import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    implicitHeight: 900
    implicitWidth: 520
    
    property alias index: swipeView.currentIndex
    
    SwipeView {
        id: swipeView
        interactive: true
        clip: true
        anchors.fill: parent
        focus: false
        focusPolicy: Qt.NoFocus
        
        Repeater {
            id: repeater
            model: App.sets
            
            Loader {
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                sourceComponent: EntrySet {
                    entrySet: modelData
                }
            }
        }
        
        Item {
//            Component.onCompleted: {
//                swipeView.currentIndex = 0
//            }
            
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Add Set")
                highlighted: true
                onClicked: nav.push("SetEditView.qml")
            }
        }
    }
    
    PageIndicator {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        currentIndex: swipeView.currentIndex
        count: repeater.count + 1
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:720;width:420}
}
##^##*/
