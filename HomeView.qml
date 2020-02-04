import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.13
import QtQuick.Window 2.13
import AppData 1.0

Item {
    id: root
    implicitHeight: 900
    implicitWidth: 520
    
    property var nav
    
    ColumnLayout {
        id: column
        anchors.fill: parent
        
        SwipeView {
            id: swipeView
            focusPolicy: Qt.NoFocus
            currentIndex: 0
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            Repeater {
                id: repeater
                model: AppData.sets
                
                delegate: EntrySet {
                    entrySet: modelData
                    nav: root.nav
                }
            }
            
            Item {
                LouButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Add Set")
                    highlighted: true
                    onClicked: nav.navigate(Views.setEdit)
                }
            }
        }
        
        PageIndicator {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: false
            currentIndex: swipeView.currentIndex
            count: repeater.count + 1
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:720;width:420}
}
##^##*/
