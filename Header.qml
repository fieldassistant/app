import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Item {
    id: root
    implicitHeight: 80
    implicitWidth: 520
    
    property Navigation nav
    
    Rectangle {
        id: headerBg
        color: Colors.cloud
        anchors.fill: parent
    }
    
    Button {
        id: backButton
        text: qsTr("Back")
        padding: 15
        enabled: !nav.isHome
        opacity: enabled ? 1 : 0.3
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        flat: true
        display: AbstractButton.IconOnly
        icon.source: "icons/back.svg"
        icon.height: parent.height
        icon.width: parent.height
        width: parent.height
        onClicked: nav.navigate(Views.home)
    }
    
    Text {
        text: qsTr("Field Assistant")
        anchors.centerIn: parent
        font.pointSize: Fonts.title
    }
    
    Button {
        id: logoButton
        flat: true
        display: AbstractButton.IconOnly
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        icon.source: "icons/bugman_logo.svg"
        icon.color: Colors.bee
        icon.height: parent.height
        icon.width: parent.height
        onClicked: nav.navigate(Views.about)
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:80;width:520}
}
##^##*/
