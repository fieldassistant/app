pragma Singleton
import QtQuick 2.0

QtObject {
    id: colors
    
    readonly property color colorStone: "#dcd3c9";
    readonly property color colorPutty: "#f1efe9";
    readonly property color colorCloud: "#f9f7f2";
    readonly property color colorBrick: "#c6bdb6";
    readonly property color colorBee:   "#d8a619";
    readonly property color colorText:  "#335259";
    
    readonly property int fontSmall: 14;
    readonly property int fontBody: 16;
    readonly property int fontSubtitle: 22;
    readonly property int fontTitle: 32;
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
