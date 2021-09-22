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
    }
    
    PageIndicator {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        currentIndex: swipeView.currentIndex
        count: repeater.count
    }
    
    CircleButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 25
        
        highlighted: true
        source: "icons/plus.svg"
        onClicked: nav.push("SetEditView.qml")
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:720;width:420}
}
##^##*/
