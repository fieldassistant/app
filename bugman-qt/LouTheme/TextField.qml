import QtQuick 2.12
import QtQuick.Templates 2.12 as T


T.TextField {
    id: control
    
    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)
    
    padding: 6
    leftPadding: 30
    
    font.pointSize: Theme.fontBody
    color: Theme.colorText
    selectionColor: Theme.colorBee
    selectedTextColor: "white"
    placeholderTextColor: Theme.colorBrick
    verticalAlignment: TextInput.AlignVCenter
    
    Text {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)
        
        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
    }
    
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        radius: 5
        color: Theme.colorCloud
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
