import QtQuick
import QtQuick.Controls

import QGroundControl
import QGroundControl.Controls

// Important Note: Toolbar buttons must manage their checked state manually in order to support
// view switch prevention. This means they can't be checkable or autoExclusive.

Button {
    id:                 button
    height:             ScreenTools.defaultFontPixelHeight * 3
    leftPadding:        _horizontalMargin
    rightPadding:       _horizontalMargin
    checkable:          false

    property bool logo:        false
    property bool animateLogo: false   // Slow continuous spin, opt-in per instance (e.g. Fly View toolbar only)

    property real _horizontalMargin: ScreenTools.defaultFontPixelWidth

    onCheckedChanged: checkable = false

    background: Rectangle {
        anchors.fill:   parent
        color:          button.checked ? qgcPal.buttonHighlight : Qt.rgba(0,0,0,0)
        border.color:   "red"
        border.width:   QGroundControl.corePlugin.showTouchAreas ? 3 : 0
    }

    contentItem: Row {
        spacing:                ScreenTools.defaultFontPixelWidth
        anchors.verticalCenter: button.verticalCenter
        // Logo buttons render the multi-color SVG natively via VectorImage; non-logo buttons
        // tint their monochrome icon through QGCColoredImage. Plain `Row` skips visible:false items.
        QGCVectorImage {
            visible:                button.logo
            height:                 ScreenTools.defaultFontPixelHeight * 2
            width:                  height
            source:                 visible ? button.icon.source : ""
            anchors.verticalCenter: parent.verticalCenter

            RotationAnimation on rotation {
                running:  button.logo && button.animateLogo
                from:     0
                to:       360
                duration: 60000
                loops:    Animation.Infinite
            }
        }
        QGCColoredImage {
            visible:                !button.logo
            height:                 ScreenTools.defaultFontPixelHeight * 2
            width:                  height
            sourceSize.height:      parent.height
            fillMode:               Image.PreserveAspectFit
            color:                  button.checked ? qgcPal.buttonHighlightText : qgcPal.buttonText
            source:                 visible ? button.icon.source : ""
            anchors.verticalCenter: parent.verticalCenter
        }
        Label {
            id:                     _label
            visible:                text !== ""
            text:                   button.text
            color:                  button.checked ? qgcPal.buttonHighlightText : qgcPal.buttonText
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
