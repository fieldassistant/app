import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12

T.Dialog {
    id: control
    
    implicitWidth: Math.max(
        header.implicitWidth,
        leftPadding + contentItem.implicitWidth + rightPadding,
        footer.implicitWidth)
    
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))
    
    padding: 10
    modal: true
    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    font.pointSize: Theme.fontBody
    
    background: Rectangle {
        color: Theme.colorPutty
    }
    
    header: Text {
        text: control.title
        visible: control.title
        elide: Label.ElideRight
        padding: 10
        font.pointSize: Theme.fontSubtitle
    }
    
    footer: DialogButtonBox {
        background: Rectangle { color: "transparent" }
        spacing: 10
        visible: count > 0
    }
    
    T.Overlay.modal: Rectangle {
        color: "#66000000"
    }
    
    T.Overlay.modeless: Rectangle {
        color: "#66000000"
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
