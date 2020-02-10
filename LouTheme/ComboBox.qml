import QtQuick 2.14
import QtQuick.Templates 2.14 as T
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.14

T.ComboBox {
    id: control
    
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             icon.height + topPadding + bottomPadding)
    
    padding: 6
    spacing: 6
    leftPadding: 30
    
    font.pointSize: Theme.body
    model: ["hum"]
    
    delegate: ItemDelegate {
        width: control.width
        highlighted: control.highlightedIndex === index
        
        contentItem: Text {
            text: modelData
            color: Theme.text
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignRight
        }
    }
    
    indicator: Image {
        id: icon
        source: "/icons/dropdown.svg"
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 18
        height: 18
        
        ColorOverlay {
            source: icon
            anchors.fill: icon
            color: control.pressed ? Theme.brick : Theme.text
        }
    }
    
    contentItem: Text {
        id: content
        leftPadding: 0
        rightPadding: control.indicator.width + control.spacing
        
        text: control.displayText
        font: control.font
        color: control.pressed ? Theme.brick : Theme.text
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        color: Theme.cloud
        radius: 5
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: roo.highlightedIndex
        }

        background: Rectangle {
            border.color: "#21be2b"
            radius: 5
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:30;width:100}
}
##^##*/