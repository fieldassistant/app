import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    implicitHeight: 80
    implicitWidth: 520
    
    signal back()
    signal about()
    
    property bool active: false
    
    Rectangle {
        id: headerBg
        color: Theme.colorCloud
        anchors.fill: parent
    }
    
    Button {
        id: backButton
        enabled: active
        opacity: enabled ? 1 : 0.3
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        flat: true
        icon.height: 40
        icon.width: 40
        padding: 10
        icon.source: "/icons/back.svg"
        onClicked: root.back()
    }
    
    Text {
        text: qsTr("Field Assistant")
        anchors.centerIn: parent
        font.pointSize: Theme.fontTitle
    }
    
    Button {
        id: logoButton
        anchors.verticalCenter: parent.verticalCenter
        flat: true
        anchors.right: parent.right
        anchors.rightMargin: 10
        icon.source: "/icons/bugman_logo.svg"
        icon.color: Theme.colorBee
        icon.height: 55
        icon.width: 55
        padding: 5
        onClicked: root.about()
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:80;width:520}
}
##^##*/
