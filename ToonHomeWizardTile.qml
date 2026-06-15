
import QtQuick 2.1
import qb.components 1.0

Tile {
  id : homeWizardTile

// ---- properties

// configuration data fixed values

  property string startColor : "#0000E0" // blue ring during startup

  property variant days : ["Zondag", "Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrijdag", "Zaterdag" ]

  // use dimState to control tile colors and data collection speed
  property bool dimState: screenStateController.dimmedColors

// ---- Functions

  onVisibleChanged: {
    if (visible) {
      if (app.activeMe) { updateTileData() }
      app.activeMe = true                   // release main app Timer
      tileButton.buttonText2Active = false  // Make sure top text is BIG
    }
  }

  onDimStateChanged: {
    if (app.activeMe) {
      if (dimState){
        app.startGetHomeWizardsTimerTimerSpeed(app.syncSlow)
      }
    }
  }

  function updateTileData() {

    if (visible) {

      // showFullRing for Energy Sockets
      var showFullRing =  ( app.tileFormat == app.tileFormatAlwaysRing ) ||
                    ( ( app.tileFormat == app.tileFormatWholeRing ) &&
                        ( app.deviceOn[0] || app.deviceOn[1] ||
                         app.deviceOn[2] || app.deviceOn[3] ||
                         app.deviceOn[4] || app.deviceOn[5] ||
                         app.deviceOn[6] || app.deviceOn[7]
                         )
                    )

      // showFullRingError for for Energy Sockets and P1 Meter
      var showFullRingError = ! ( app.deviceOke[0] && app.deviceOke[1] &&
                              app.deviceOke[2] && app.deviceOke[3] &&
                              app.deviceOke[4] && app.deviceOke[5] &&
                              app.deviceOke[6] && app.deviceOke[7] &&
                              app.deviceOke[8] )

      ring.border.color = showFullRingError ? app.errorColor : app.tileRingColor

      mask_0.visible = ! ( app.deviceOn[0] || showFullRing || showFullRingError )
      mask_1.visible = ! ( app.deviceOn[1] || showFullRing || showFullRingError )
      mask_2.visible = ! ( app.deviceOn[2] || showFullRing || showFullRingError )
      mask_3.visible = ! ( app.deviceOn[3] || showFullRing || showFullRingError )
      mask_4.visible = ! ( app.deviceOn[4] || showFullRing || showFullRingError )
      mask_5.visible = ! ( app.deviceOn[5] || showFullRing || showFullRingError )
      mask_6.visible = ! ( app.deviceOn[6] || showFullRing || showFullRingError )
      mask_7.visible = ! ( app.deviceOn[7] || showFullRing || showFullRingError )

      if ( app.deviceOke[8] && (app.homeWizardDataOnTile == app.homeWizardDataOnTileP1Meter) ) {
        // P1 Meter configured and oke
        tileLogo.visible = false
        tileButton.buttonText = Math.round(app.deviceWatts[8]) + " Watt"
        tileButton.buttonText2 = ""
        tileButton.buttonText2Stack = false
      } else {
        switch (app.homeWizardDataOnTile) {
        case app.homeWizardDataOnTileLogo:
          tileLogo.visible = true
          tileButton.buttonText = ""
          tileButton.buttonText2 = ""
          tileButton.buttonText2Stack = false
          break
        case app.homeWizardDataOnTileText:
          tileLogo.visible = false
          tileButton.buttonText = "HomeWizard"
          tileButton.buttonText2 = ""
          tileButton.buttonText2Stack = false
          break
        case app.homeWizardDataOnTileNow:
          tileLogo.visible = false
          var today = new Date();
          var strTime=("00"+today.getHours()).slice(-2)+":"+("00"+(today.getMinutes())).slice(-2)
          var strDate=days[today.getDay()] + "\n"+("00"+today.getDate()).slice(-2)+"-"+("00"+(today.getMonth()+1)).slice(-2)+"-"+today.getFullYear()
          tileButton.buttonText2Stack = true
          tileButton.buttonText = strTime
          tileButton.buttonText2 = strDate
          break
        }
      }
    }
  }

// ---- Tile

// -------- Ring

  Rectangle {
    id : ring
    height : homeWizardTile.height
    width : homeWizardTile.height
    radius : homeWizardTile.height / 2
    anchors {
      centerIn : parent
    }
    border {
      width : 10
      color : startColor
    }
    color : dimState ? "black" : "white"
  }

// -------- 8 Tile masks

  Rectangle {
    id : mask_0
    visible : false
    width : homeWizardTile.height / 3
    height : width
    color : (canvas.dimState) ? "black" : "white"
    anchors {
      top : parent.top
      right : mask_1.left
    }
  }

  Rectangle {
    id : mask_1
    visible : false
    width : homeWizardTile.height / 3
    height : homeWizardTile.height / 3
    color : (canvas.dimState) ? "black" : "white"
    anchors {
      top : parent.top
      horizontalCenter : parent.horizontalCenter
    }
  }

  Rectangle {
    id : mask_2
    visible : false
    width : homeWizardTile.height / 3
    height : width
    color : (canvas.dimState) ? "black" : "white"
    anchors {
      top : parent.top
      left : mask_1.right
    }
  }

  Rectangle {
    id : mask_3
    visible : false
    width : homeWizardTile.height / 3
    height : homeWizardTile.height / 3
    color : (canvas.dimState) ? "black" : "white"
    anchors {
      top : mask_0.bottom
      left : mask_0.left
    }
  }

  Rectangle {
    id : mask_4
    visible : false
    width : homeWizardTile.height / 3
    height : homeWizardTile.height / 3
    color : (canvas.dimState) ? "black" : "white"
    anchors {
      top : mask_2.bottom
      right : mask_2.right
    }
  }

  Rectangle {
    id : mask_5
    visible : false
    width : homeWizardTile.height / 3
    height : width
    color : (canvas.dimState) ? "black" : "white"
    anchors {
      top : mask_3.bottom
      left : mask_3.left
    }
  }

  Rectangle {
    id : mask_6
    visible : false
    width : homeWizardTile.height / 3
    height : homeWizardTile.height / 3
    color : (canvas.dimState) ? "black" : "white"
    anchors {
      bottom: mask_5.bottom
      left : mask_1.left
    }
  }

  Rectangle {
    id : mask_7
    visible : false
    width : homeWizardTile.height / 3
    height : width
    color : (canvas.dimState) ? "black" : "white"
    anchors {
      top : mask_4.bottom
      right : mask_4.right
    }
  }

// -------- Tile Button

  YaLabel {
    id : tileButton
    height : homeWizardTile.height - 10
    width : height
    buttonBorderRadius : height / 2
    anchors {
      centerIn : parent
    }
    buttonBorderWidth : 0
    buttonActiveColor : dimState ? "black" : "white"
    buttonSelectedColor : buttonActiveColor
    buttonHoverColor : buttonActiveColor
    hoveringEnabled : false
    buttonDisabledColor : "white"
    buttonText : "HomeWizard"
    buttonText2 : "start..."
    buttonText2Stack : true
    pixelsizeoverride : true
    pixelsizeoverridesize : isNxt ? 30 : 24
    textColor : dimState ? "white" : "black"
    anchors {
      verticalCenter : parent.verticalCenter
      horizontalCenter : parent.horizontalCenter
    }
    onClicked : { stage.openFullscreen(app.homeWizardScreenURL);}
    Image {
      id : tileLogo
      visible : false
      anchors.centerIn : parent
      width : implicitWidth * ( isNxt ? 0.25 : 0.2 )
      height : implicitHeight * ( isNxt ? 0.25 : 0.2 )
      source: "file:///qmf/qml/apps/toonHomeWizard/drawables/homewizard.png"
    }
  }

}
