import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

Screen {
  id : homeWizardScreen
  screenTitle : qsTr("HomeWizard")
  
// ---- Properties

// -------- Control properties

  property bool debug : false // used to (de)activate app.log messages

  property bool activeMe : false  // used to enable/disable calls to updateScreenData()

// -------- Screen properties

  property variant days : ["Zondag", "Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrijdag", "Zaterdag" ]

  property int rowHeight : isNxt ?  45 :  36
  property int textPixelSize : isNxt ?  20 :  16
  property int name_width : isNxt ? 250 : 200
  property int watts_width : isNxt ? 150 : 120
  property int kWh_width : isNxt ? 200 : 150
  property int wifi_width : isNxt ? 150 : 120
  property int buttonWidth : isNxt ? 105 :  84

  property int buttonborderwidth : 0
  property int buttonmargin : 4
  property int textmargin : 10

  property int namebuttonborderwidth : 0

  property int onOffToggleHeight : isNxt ? 35 : 28

// -------- Live properties

  // We need to tell functions for which device we want to do something
  property int index_device

// ---- Functions

// -------- Function onVisibleChanged

  onVisibleChanged: {

    if (visible) {

//  List all properties of some object to find what you can change
//      app.dumpProperties(scrollbar.childrenRect, "scrollbar.childrenRect")
//      app.dumpProperties(deviceOn_7, "deviceOn_7")

      app.startGetHomeWizardsTimerTimerSpeed(app.syncFast)

      activeMe = true

      appSetupScreen.visible = false
      deviceSettingsPanel.visible = false
      deviceSettingsPanelHelp.visible = false

      deviceSettingsPanelHelp.visible = true
      var i = 0
      for (i = 0 ; i < 9 ; i++ ) {
        deviceSettingsPanelHelp.visible = deviceSettingsPanelHelp.visible
          && ( ! app.deviceActive[i] )
      }

      updateScreenConfiguration()
      updateScreenData()

    } else {
      app.settingsActive = false
      app.startGetHomeWizardsTimerTimerSpeed(app.syncSlow)
      activeMe = false
    }
  }

// -------- Function onDimStateChanged

  onDimStateChanged: {
    if (dimState){
      activeMe = false
    }
  }

// -------- Function updateScreenConfiguration

  function updateScreenConfiguration() {

    if ( activeMe ) {

      row_0.visible = ( app.deviceActive[0] && app.deviceVisible[0])
      row_1.visible = ( app.deviceActive[1] && app.deviceVisible[1])
      row_2.visible = ( app.deviceActive[2] && app.deviceVisible[2])
      row_3.visible = ( app.deviceActive[3] && app.deviceVisible[3])
      row_4.visible = ( app.deviceActive[4] && app.deviceVisible[4])
      row_5.visible = ( app.deviceActive[5] && app.deviceVisible[5])
      row_6.visible = ( app.deviceActive[6] && app.deviceVisible[6])
      row_7.visible = ( app.deviceActive[7] && app.deviceVisible[7])
      row_8.visible = ( app.deviceActive[8] && app.deviceVisible[8])

      deviceOn_0.backgroundColorKnob = app.deviceSwitchEnable[0] ? "#009900" : "#000099"
      deviceOn_1.backgroundColorKnob = app.deviceSwitchEnable[1] ? "#009900" : "#000099"
      deviceOn_2.backgroundColorKnob = app.deviceSwitchEnable[2] ? "#009900" : "#000099"
      deviceOn_3.backgroundColorKnob = app.deviceSwitchEnable[3] ? "#009900" : "#000099"
      deviceOn_4.backgroundColorKnob = app.deviceSwitchEnable[4] ? "#009900" : "#000099"
      deviceOn_5.backgroundColorKnob = app.deviceSwitchEnable[5] ? "#009900" : "#000099"
      deviceOn_6.backgroundColorKnob = app.deviceSwitchEnable[6] ? "#009900" : "#000099"
      deviceOn_7.backgroundColorKnob = app.deviceSwitchEnable[7] ? "#009900" : "#000099"

      deviceName_0.buttonText = app.deviceName[0];
      deviceName_1.buttonText = app.deviceName[1];
      deviceName_2.buttonText = app.deviceName[2];
      deviceName_3.buttonText = app.deviceName[3];
      deviceName_4.buttonText = app.deviceName[4];
      deviceName_5.buttonText = app.deviceName[5];
      deviceName_6.buttonText = app.deviceName[6];
      deviceName_7.buttonText = app.deviceName[7];
      deviceName_8.buttonText = app.deviceName[8];

      deviceOn_0.enabled = app.deviceSwitchEnable[0]
      deviceOn_1.enabled = app.deviceSwitchEnable[1]
      deviceOn_2.enabled = app.deviceSwitchEnable[2]
      deviceOn_3.enabled = app.deviceSwitchEnable[3]
      deviceOn_4.enabled = app.deviceSwitchEnable[4]
      deviceOn_5.enabled = app.deviceSwitchEnable[5]
      deviceOn_6.enabled = app.deviceSwitchEnable[6]
      deviceOn_7.enabled = app.deviceSwitchEnable[7]

      // Setup Screen

      handle.x =  (Number("0x"+app.tileRingColor.substring(3,5))/255)  * (slider.width - handle.width)

      // r1 .. r3 for ring format
      r1.checked = (app.tileFormat == app.tileFormatAlwaysRing)
      r2.checked = (app.tileFormat == app.tileFormatSegmentedRing)
      r3.checked = (app.tileFormat == app.tileFormatWholeRing)

      p0.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileLogo)
      p1.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileText)
      p2.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileNow)
      p3.checked = (app.homeWizardDataOnTile == app.homeWizardDataOnTileP1Meter)
      p3.visible = app.deviceActive[8]

      // k1 .. k5 for kWh selection
      k1.checked = (app.kWhColumn == app.kWhToday)
      k2.checked = (app.kWhColumn == app.kWhWeek)
      k3.checked = (app.kWhColumn == app.kWhMonth)
      k4.checked = (app.kWhColumn == app.kWhMinOffset)
      k5.checked = (app.kWhColumn == app.kWhTotal)

      kWhDecimalsvalue.text = app.kWhDecimals

      // w1 .. w2 for wifi strength scale
      w1.checked = (app.wifidBm)
      w2.checked = (! app.wifidBm)

    }
  }

// -------- Function updateScreenData

  function wattsNow(index) {
    return ( app.deviceWatts[index].toFixed(1) + " Watt" )
  }

  function kWhValue(index) {
    var result = 0
    switch ( app.kWhColumn )  {
      case app.kWhToday:
        result = (app.deviceKWH[index] - app.deviceKWHYesterday[index]).toFixed(app.kWhDecimals)
        break;
      case app.kWhWeek:
        result = (app.deviceKWH[index] - app.deviceKWHLastWeek[index]).toFixed(app.kWhDecimals)
        break;
      case app.kWhMonth:
        result = (app.deviceKWH[index] - app.deviceKWHLastMonth[index]).toFixed(app.kWhDecimals)
        break;
      case app.kWhMinOffset: // deviceKWHOffset
        result = (app.deviceKWH[index] - app.deviceKWHOffset[index]).toFixed(app.kWhDecimals)
        break;
      case app.kWhTotal:
        result = app.deviceKWH[index].toFixed(app.kWhDecimals)
    }
    // just after startup every app.deviceKWH[index] is 0 and calculated results are negative ;-)
    if ( result < 0 ) { result = 0 } 
    if ( index == 9 ) { result = (result * -1).toFixed(app.kWhDecimals) } // this is production to net
    return result + " kWh"
  }

  function updateScreenData() {

    if ( activeMe ) {

      setup_IP_0.buttonActiveColor = app.deviceOke[0] ? "#cdcdcd" : app.errorColor
      setup_IP_1.buttonActiveColor = app.deviceOke[1] ? "#cdcdcd" : app.errorColor
      setup_IP_2.buttonActiveColor = app.deviceOke[2] ? "#cdcdcd" : app.errorColor
      setup_IP_3.buttonActiveColor = app.deviceOke[3] ? "#cdcdcd" : app.errorColor
      setup_IP_4.buttonActiveColor = app.deviceOke[4] ? "#cdcdcd" : app.errorColor
      setup_IP_5.buttonActiveColor = app.deviceOke[5] ? "#cdcdcd" : app.errorColor
      setup_IP_6.buttonActiveColor = app.deviceOke[6] ? "#cdcdcd" : app.errorColor
      setup_IP_7.buttonActiveColor = app.deviceOke[7] ? "#cdcdcd" : app.errorColor
      setup_IP_8.buttonActiveColor = app.deviceOke[8] ? "#cdcdcd" : app.errorColor

      deviceOn_0.isSwitchedOn = app.deviceOn[0];
      deviceOn_1.isSwitchedOn = app.deviceOn[1];
      deviceOn_2.isSwitchedOn = app.deviceOn[2];
      deviceOn_3.isSwitchedOn = app.deviceOn[3];
      deviceOn_4.isSwitchedOn = app.deviceOn[4];
      deviceOn_5.isSwitchedOn = app.deviceOn[5];
      deviceOn_6.isSwitchedOn = app.deviceOn[6];
      deviceOn_7.isSwitchedOn = app.deviceOn[7];

      deviceWatts_0_Text.text = wattsNow(0)
      deviceWatts_1_Text.text = wattsNow(1)
      deviceWatts_2_Text.text = wattsNow(2)
      deviceWatts_3_Text.text = wattsNow(3)
      deviceWatts_4_Text.text = wattsNow(4)
      deviceWatts_5_Text.text = wattsNow(5)
      deviceWatts_6_Text.text = wattsNow(6)
      deviceWatts_7_Text.text = wattsNow(7)
      deviceWatts_8_Text.text = wattsNow(8)

      deviceKWH_0_Text.text = kWhValue(0)
      deviceKWH_1_Text.text = kWhValue(1)
      deviceKWH_2_Text.text = kWhValue(2)
      deviceKWH_3_Text.text = kWhValue(3)
      deviceKWH_4_Text.text = kWhValue(4)
      deviceKWH_5_Text.text = kWhValue(5)
      deviceKWH_6_Text.text = kWhValue(6)
      deviceKWH_7_Text.text = kWhValue(7)
      deviceKWH_8_Text.text = kWhValue(8)
      deviceKWH_export_9_Text.text = kWhValue(9)

      if ( app.wifidBm ) {
        device_wifi_0_Text.text = (app.device_wifi[0] / 2 - 100 )+" dBm"
        device_wifi_1_Text.text = (app.device_wifi[1] / 2 - 100 )+" dBm"
        device_wifi_2_Text.text = (app.device_wifi[2] / 2 - 100 )+" dBm"
        device_wifi_3_Text.text = (app.device_wifi[3] / 2 - 100 )+" dBm"
        device_wifi_4_Text.text = (app.device_wifi[4] / 2 - 100 )+" dBm"
        device_wifi_5_Text.text = (app.device_wifi[5] / 2 - 100 )+" dBm"
        device_wifi_6_Text.text = (app.device_wifi[6] / 2 - 100 )+" dBm"
        device_wifi_7_Text.text = (app.device_wifi[7] / 2 - 100 )+" dBm"
        device_wifi_8_Text.text = (app.device_wifi[8] / 2 - 100 )+" dBm"
      } else {
        device_wifi_0_Text.text = app.device_wifi[0]+" %"
        device_wifi_1_Text.text = app.device_wifi[1]+" %"
        device_wifi_2_Text.text = app.device_wifi[2]+" %"
        device_wifi_3_Text.text = app.device_wifi[3]+" %"
        device_wifi_4_Text.text = app.device_wifi[4]+" %"
        device_wifi_5_Text.text = app.device_wifi[5]+" %"
        device_wifi_6_Text.text = app.device_wifi[6]+" %"
        device_wifi_7_Text.text = app.device_wifi[7]+" %"
        device_wifi_8_Text.text = app.device_wifi[8]+" %"
      }
    }
  }

// ---- Screen

// --------- Device IP Setup Buttons

  YaLabel {
    id : setup_IP_0
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : parent.top
      left : parent.left
      topMargin : rowHeight / 2
      leftMargin : rowHeight
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(0) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
    }
  }

  YaLabel {
    id : setup_IP_1
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_0.bottom
      left : setup_IP_0.left
      topMargin : buttonmargin
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(1) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
    }
  }

  YaLabel {
    id : setup_IP_2
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_1.bottom
      left : setup_IP_1.left
      topMargin : buttonmargin
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(2) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
    }
  }

  YaLabel {
    id : setup_IP_3
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_2.bottom
      left : setup_IP_2.left
      topMargin : buttonmargin
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(3) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
    }
  }

  YaLabel {
    id : setup_IP_4
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_3.bottom
      left : setup_IP_3.left
      topMargin : buttonmargin
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(4) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
    }
  }

  YaLabel {
    id : setup_IP_5
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_4.bottom
      left : setup_IP_4.left
      topMargin : buttonmargin
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(5) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
    }
  }

  YaLabel {
    id : setup_IP_6
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_5.bottom
      left : setup_IP_5.left
      topMargin : buttonmargin
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(6) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
    }
  }

  YaLabel {
    id : setup_IP_7
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_6.bottom
      left : setup_IP_6.left
      topMargin : buttonmargin
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(7) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/energysocket.png"
    }
  }

  YaLabel {
    id : setup_IP_8
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "white"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      top : setup_IP_7.bottom
      left : setup_IP_7.left
      topMargin : buttonmargin
    }
    onClicked : { deviceSettingsPanel.editDeviceSettings(8) }
    Image {
    source : "file:///qmf/qml/apps/toonHomeWizard/drawables/p1meter.png"
    }
  }

// -------- Device Rows

// ------------ Device Row 0

  Rectangle {
    id : row_0
    anchors {
      verticalCenter : setup_IP_0.verticalCenter
      left : setup_IP_0.right
    }

    YaLabel {
      id : deviceName_0
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    OnOffToggle {
      id : deviceOn_0
      height : onOffToggleHeight
      backgroundColorRight : "#00DD00"
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_0.right
        leftMargin : buttonmargin
      }
      leftIsSwitchedOn : false
      onSelectedChangedByUser: {
        app.deviceOn[0] = isSwitchedOn
        isSwitchedOn = ! isSwitchedOn
        app.switchHomeWizard(0)
      }
    }

    Rectangle {
      id : deviceWatts_0
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceOn_0.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceWatts_0_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_0
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_0.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_0_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_0
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_0.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_0_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Device Row 1

  Rectangle {
    id : row_1
    anchors {
      verticalCenter : setup_IP_1.verticalCenter
      left : setup_IP_1.right
    }

    YaLabel {
      id : deviceName_1
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    OnOffToggle {
      id : deviceOn_1
      height : onOffToggleHeight
      backgroundColorRight : "#00DD00"
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_1.right
        leftMargin : buttonmargin
      }
      leftIsSwitchedOn : false
      onSelectedChangedByUser: {
        app.deviceOn[1] = isSwitchedOn
        isSwitchedOn = ! isSwitchedOn
        app.switchHomeWizard(1)
      }
    }

    Rectangle {
      id : deviceWatts_1
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceOn_1.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceWatts_1_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_1
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_1.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_1_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_1
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_1.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_1_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Device Row 2

  Rectangle {
    id : row_2
    anchors {
      verticalCenter : setup_IP_2.verticalCenter
      left : setup_IP_2.right
    }

    YaLabel {
      id : deviceName_2
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    OnOffToggle {
      id : deviceOn_2
      height : onOffToggleHeight
      backgroundColorRight : "#00DD00"
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_2.right
        leftMargin : buttonmargin
      }
      leftIsSwitchedOn : false
      onSelectedChangedByUser: {
        app.deviceOn[2] = isSwitchedOn
        isSwitchedOn = ! isSwitchedOn
        app.switchHomeWizard(2)
      }
    }

    Rectangle {
      id : deviceWatts_2
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceOn_2.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceWatts_2_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_2
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_2.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_2_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_2
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_2.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_2_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Device Row 3

  Rectangle {
    id : row_3
    anchors {
      verticalCenter : setup_IP_3.verticalCenter
      left : setup_IP_3.right
    }

    YaLabel {
      id : deviceName_3
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    OnOffToggle {
      id : deviceOn_3
      height : onOffToggleHeight
      backgroundColorRight : "#00DD00"
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_3.right
        leftMargin : buttonmargin
      }
      leftIsSwitchedOn : false
      onSelectedChangedByUser: {
        app.deviceOn[3] = isSwitchedOn
        isSwitchedOn = ! isSwitchedOn
        app.switchHomeWizard(3)
      }
    }

    Rectangle {
      id : deviceWatts_3
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceOn_3.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceWatts_3_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_3
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_3.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_3_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_3
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_3.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_3_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Device Row 4

  Rectangle {
    id : row_4
    anchors {
      verticalCenter : setup_IP_4.verticalCenter
      left : setup_IP_4.right
    }

    YaLabel {
      id : deviceName_4
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    OnOffToggle {
      id : deviceOn_4
      height : onOffToggleHeight
      backgroundColorRight : "#00DD00"
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_4.right
        leftMargin : buttonmargin
      }
      leftIsSwitchedOn : false
      onSelectedChangedByUser: {
        app.deviceOn[4] = isSwitchedOn
        isSwitchedOn = ! isSwitchedOn
        app.switchHomeWizard(4)
      }
    }

    Rectangle {
      id : deviceWatts_4
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceOn_4.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceWatts_4_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_4
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_4.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_4_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_4
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_4.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_4_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Device Row 5

  Rectangle {
    id : row_5
    anchors {
      verticalCenter : setup_IP_5.verticalCenter
      left : setup_IP_5.right
    }

    YaLabel {
      id : deviceName_5
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    OnOffToggle {
      id : deviceOn_5
      height : onOffToggleHeight
      backgroundColorRight : "#00DD00"
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_5.right
        leftMargin : buttonmargin
      }
      leftIsSwitchedOn : false
      onSelectedChangedByUser: {
        app.deviceOn[5] = isSwitchedOn
        isSwitchedOn = ! isSwitchedOn
        app.switchHomeWizard(5)
      }
    }

    Rectangle {
      id : deviceWatts_5
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceOn_5.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceWatts_5_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_5
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_5.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_5_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_5
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_5.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_5_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Device Row 6

  Rectangle {
    id : row_6
    anchors {
      verticalCenter : setup_IP_6.verticalCenter
      left : setup_IP_6.right
    }

    YaLabel {
      id : deviceName_6
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    OnOffToggle {
      id : deviceOn_6
      height : onOffToggleHeight
      backgroundColorRight : "#00DD00"
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_6.right
        leftMargin : buttonmargin
      }
      leftIsSwitchedOn : false
      onSelectedChangedByUser: {
        app.deviceOn[6] = isSwitchedOn
        isSwitchedOn = ! isSwitchedOn
        app.switchHomeWizard(6)
      }
    }

    Rectangle {
      id : deviceWatts_6
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceOn_6.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceWatts_6_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_6
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_6.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_6_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_6
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_6.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_6_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Device Row 7

  Rectangle {
    id : row_7
    anchors {
      verticalCenter : setup_IP_7.verticalCenter
      left : setup_IP_7.right
    }

    YaLabel {
      id : deviceName_7
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
        left : parent.left
        leftMargin : buttonmargin
      }
    }

    OnOffToggle {
      id : deviceOn_7
      height : onOffToggleHeight
      backgroundColorRight : "#00DD00"
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_7.right
        leftMargin : buttonmargin
      }
      leftIsSwitchedOn : false
      onSelectedChangedByUser: {
        app.deviceOn[7] = isSwitchedOn
        isSwitchedOn = ! isSwitchedOn
        app.switchHomeWizard(7)
      }
    }

    Rectangle {
      id : deviceWatts_7
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceOn_7.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceWatts_7_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_7
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_7.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_7_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_7
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_7.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_7_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ Device Row 8

  Rectangle {
    id : row_8
    anchors {
      verticalCenter : setup_IP_8.verticalCenter
      left : setup_IP_8.right
      leftMargin : buttonmargin
    }

    YaLabel {
      id : deviceName_8
      buttonBorderWidth : namebuttonborderwidth
      height : rowHeight
      width : name_width
      buttonActiveColor : "#cdcdcd"
      buttonHoverColor : buttonActiveColor
      buttonSelectedColor : buttonActiveColor
      hoveringEnabled : isNxt
      anchors {
        verticalCenter : parent.verticalCenter
      }
    }

// No OnOffToggle here because device 8 is p1Meter and has no switch

    Rectangle {
      id : deviceWatts_8
      height : rowHeight
      width : watts_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceName_8.right
        leftMargin : isNxt ? 67 : 54
      }
      Text {
        id : deviceWatts_8_Text
        width : watts_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "Watts field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_8
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceWatts_8.right
        leftMargin : buttonmargin
      }
      Text {
        id : deviceKWH_8_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : deviceKWH_export_8
      height : rowHeight
      width : kWh_width
      color : "#cdcdcd"
      radius : 5

      anchors {
        top : deviceKWH_8.bottom
        left : deviceKWH_8.left
        topMargin : buttonmargin
      }
      Text {
        id : deviceKWH_export_9_Text
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "kWh field"
        lineHeight : 1.0
        color : "black"
      }
    }

    Rectangle {
      id : device_wifi_8
      height : rowHeight
      width : wifi_width
      color : "#cdcdcd"
      radius : 5
      anchors {
        verticalCenter : parent.verticalCenter
        left : deviceKWH_8.right
        leftMargin : buttonmargin
      }
      Text {
        id : device_wifi_8_Text
        width : wifi_width
        horizontalAlignment : Text.AlignRight
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
          rightMargin : textmargin
        }
        font {
          family : qfont.semiBold.name
          pixelSize : isNxt ? 20 : 16
        }
        text : "WiFi field"
        lineHeight : 1.0
        color : "black"
      }
    }

  }

// ------------ APP Setup screen

// ------------ APP Setup screen Button

  YaLabel {
    id : toggleAppSetupScreen
    buttonBorderWidth : buttonborderwidth
    height : rowHeight
    width : rowHeight
    buttonActiveColor : "transparent"
    buttonHoverColor : buttonActiveColor
    buttonSelectedColor : buttonActiveColor
    hoveringEnabled : isNxt
    anchors {
      bottom : parent.bottom
      right : parent.right
      rightMargin : rowHeight
      bottomMargin : rowHeight / 2
    }

    onClicked : {
      app.settingsActive = true // block data collection
      appSetupScreen.visible = true
      deviceSettingsPanel.visible = false
      deviceSettingsPanelHelp.visible = false
      var today = new Date();
      var strTime=("00"+today.getHours()).slice(-2)+":"+("00"+(today.getMinutes())).slice(-2)
      var strDate=days[today.getDay()] + " "+("00"+today.getDate()).slice(-2)+"-"+("00"+(today.getMonth()+1)).slice(-2)+"-"+today.getFullYear()
      p2OptionText.text = strTime + " " + strDate
      handle.x =  (Number("0x"+app.tileRingColor.substring(3,5))/255)  * (slider.width - handle.width)
    }
    Image {
      id : toggleAppSetupScreenPicture
      source : "file:///qmf/qml/apps/toonHomeWizard/drawables/settings.png"
    }
  }

// ------------ APP Setup screen Rectangle

  Rectangle {
    id : appSetupScreen
    visible : false

    height : parent.height

    width : parent.width - 20
    color : "#dcdcdc"
    radius : 8
    border {
      width : 2
      color : "black"
    }

    anchors {
      top : parent.top
      horizontalCenter : parent.horizontalCenter
    }

    // block clicks to all items in the back
    MouseArea {
      anchors.fill : parent
      acceptedButtons : Qt.AllButtons
      propagateComposedEvents: false
    }

// ------------ Function appSettingsSave

    function appSettingsSave() {
      debug && app.log("Screen Save APP Settings")

      if ( r1.checked ) { app.tileFormat = app.tileFormatAlwaysRing }
      if ( r2.checked ) { app.tileFormat = app.tileFormatSegmentedRing }
      if ( r3.checked ) { app.tileFormat = app.tileFormatWholeRing }

      app.tileRingColor = handle.border.color

      if ( p0.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileLogo }
      if ( p1.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileText }
      if ( p2.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileNow }
      if ( p3.checked ) { app.homeWizardDataOnTile = app.homeWizardDataOnTileP1Meter }

      if ( k1.checked ) { app.kWhColumn = app.kWhToday }
      if ( k2.checked ) { app.kWhColumn = app.kWhWeek }
      if ( k3.checked ) { app.kWhColumn = app.kWhMonth }
      if ( k4.checked ) { app.kWhColumn = app.kWhMinOffset }
      if ( k5.checked ) { app.kWhColumn = app.kWhTotal }

      app.kWhDecimals = kWhDecimalsvalue.text

      app.wifidBm = w1.checked

      updateScreenConfiguration()
      app.saveSettings()

      appSetupScreen.visible = false
      updateScreenConfiguration()
      updateScreenData()
    }

// ---------------- Radio buttons tileFormat

    Rectangle {
      id : tileFormatRadioButtons
      width : 300
      height : isNxt ? 175 : 140 
      border.width : 0
      color : "#dcdcdc"
      anchors{
        left : appSetupScreen.left
        top : appSetupScreen.top
        leftMargin : rowHeight
        topMargin : rowHeight / 2
      }

      Column {

        spacing : isNxt ? 5 : 4
        Text {
          text : "Tile:"
          height : isNxt ? 40 : 32
          font.underline : true
        }

// ---- Radio 1

        Item {
          id : r1
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_1
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : r1.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "Ring"
              anchors {
                verticalCenter : rect_1.verticalCenter
              }
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              r1.checked = true
              r2.checked = false
              r3.checked = false
            }
          }
        }

// ---- Radio 2

        Item {
          id : r2
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_2
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : r2.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "1 Socket : 1 Ring Segment"
              anchors.verticalCenter : rect_2.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              r1.checked = false
              r2.checked = true
              r3.checked = false
            }
          }
        }

// ---- Radio 3

        Item {
          id : r3
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_3
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : r3.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "1 Socket : Ring"
              anchors.verticalCenter : rect_3.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              r1.checked = false
              r2.checked = false
              r3.checked = true
            }
          }

        } // end radio

      }   // end column

    }     // end item

// ---------------- Ring color slider

    Rectangle {

      id : slider
      width : 300
      height : isNxt ? 100 : 80
      border.width : 0
      color : "#dcdcdc"

      anchors {
        top : tileFormatRadioButtons.bottom
        left : tileFormatRadioButtons.left
        topMargin : rowHeight / 4
      }

      property real value : handle.x / (width - handle.width)

      Rectangle {
        id : track
        anchors {
          verticalCenter : handle.verticalCenter
        }
        width : parent.width
        height : 4
        radius : 2
        color : "#606060"
      }

      Rectangle {
        id : handle
        height : isNxt ? 50 : 40
        border.width : 10
        border.color : Qt.rgba(0, slider.value, 0, 1)
        width : height
        anchors {
          top : parent.top
        }
        radius : width / 2
        y : (parent.height - height) / 2

        // green intensity between 0 and 1 intensiteit tussen 0 en 1
        color : "transparent" // Qt.rgba(0, slider.value, 0, 1)

        MouseArea {
          anchors.fill : parent
          drag.target : parent
          drag.axis : Drag.XAxis
          drag.minimumX : 0
          drag.maximumX : slider.width - handle.width

// The next would immediate update. I kept it to remember 'onReleased'
//          onReleased: { app.tileRingColor = handle.color }

        }
      }

      Text {
        text : "Ring Color"
        height : isNxt ? 50 : 40
        anchors {
          top : handle.bottom
          horizontalCenter : handle.horizontalCenter
        }
        font.underline : true
      }
    }

// ---------------- Radio buttons data on Tile

    Rectangle {
      id : radioHomeWizardDataOnTile
      width : 300
      height : isNxt ? 175 : 140
      border.width : 0
      color : "#dcdcdc"
      anchors {
        left : slider.left
        top : slider.bottom
        topMargin : rowHeight * -0.4
      }

      Column {

        spacing : 5

        Text {
          text : "Tile Data:"
          height : isNxt ? 40 : 32
          font.underline : true
        }

// ---- Radio 0

        Item {
          id : p0
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p0
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p0.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "Logo"
              anchors.verticalCenter : rect_p0.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = true
              p1.checked = false
              p2.checked = false
              p3.checked = false
            }
          }
        }

// ---- Radio 1

        Item {
          id : p1
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p1
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p1.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "'HomeWizard'"
              anchors.verticalCenter : rect_p1.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = false
              p1.checked = true
              p2.checked = false
              p3.checked = false
            }
          }
        }

// ---- Radio 2

        Item {
          id : p2
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p2
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p2.checked ? "black" : "transparent"
              }
            }

            Text {
              id : p2OptionText
              text : "00:00: 99-99-9999"
              anchors.verticalCenter : rect_p2.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = false
              p1.checked = false
              p2.checked = true
              p3.checked = false
            }
          }

        }

// ---- Radio 3

        Item {
          id : p3
          width : 150
          height : isNxt ? 40 : 32

          visible : false

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_p3
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : p3.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "P1 Meter Watt"
              anchors.verticalCenter : rect_p3.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              p0.checked = false
              p1.checked = false
              p2.checked = false
              p3.checked = true
            }
          }

        } // end radio

      }   // end column

    }     // end item

// ---------------- Radio buttons kWhColumn

    Rectangle {
      id : kWhColumnRadioButtons

      width : 300
      height : isNxt ? 250 : 200
      border.width : 0
      color : "#dcdcdc"
      anchors.left : parent.horizontalCenter
      anchors.top : tileFormatRadioButtons.top

      Column {

        spacing : isNxt ? 5 : 4
        Text {
          text : "kWh:"
          height : isNxt ? 40 : 32
          font.underline : true
        }

// ---- Radio 1

        Item {
          id : k1
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing: 6

            Rectangle {
              id : rect_k1
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k1.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Dag"
              anchors.verticalCenter : rect_k1.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = true
              k2.checked = false
              k3.checked = false
              k4.checked = false
              k5.checked = false
            }
          }
        }

// ---- Radio 2

        Item {
          id : k2
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_k2
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k2.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Week"
              anchors.verticalCenter : rect_k2.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = false
              k2.checked = true
              k3.checked = false
              k4.checked = false
              k5.checked = false
            }
          }
        }

// ---- Radio 3

        Item {
          id : k3
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_k3
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k3.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Maand"
              anchors.verticalCenter : rect_k3.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = false
              k2.checked = false
              k3.checked = true
              k4.checked = false
              k5.checked = false
            }
          }
        }

// ---- Radio 4

        Item {
          id : k4
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_k4
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k4.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Start"
              anchors.verticalCenter : rect_k4.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = false
              k2.checked = false
              k3.checked = false
              k4.checked = true
              k5.checked = false
            }
          }
        }

// ---- Radio 5

        Item {
          id : k5
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_k5
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : k5.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "kWh Totaal"
              anchors.verticalCenter : rect_k5.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              k1.checked = false
              k2.checked = false
              k3.checked = false
              k4.checked = false
              k5.checked = true
            }
          }
        } // end radio

      }   // end column

    }     // end item

// ---------------- kWhDecimals

    Rectangle {
      id : kWhDecimalsRectangle
      width : 300
      height : rowHeight
      border.width : 0
      color : "#dcdcdc"
      anchors {
        top : kWhColumnRadioButtons.bottom
        left : kWhColumnRadioButtons.left
        topMargin : rowHeight / 2
      }
      Text {
        id : kWhDecimalsRectangleText
        text : "kWh Decimalen:"
        height : isNxt ? 40 : 32
        font.underline : true
      }

      Rectangle {
        id : kWhDecimalsMin
        width : rowHeight * 0.8
        height : width
        color : "#ababab"
        radius : 5
        border.width : 1
        anchors {
          left : kWhDecimalsRectangleText.right
          leftMargin : isNxt ? 20 : 16
        }
        Text {
          anchors {
            horizontalCenter : parent.horizontalCenter
            bottom : parent.bottom
            bottomMargin :  ( rowHeight / 3 )
          }
          text : "_"
          font.pixelSize : isNxt ? 40 : 32
        }
        MouseArea {
          anchors.fill : parent
          onClicked : {
            if ( kWhDecimalsvalue.text > 0 ) { kWhDecimalsvalue.text = kWhDecimalsvalue.text - 1}
          }
        }
      }

      Text {
        id : kWhDecimalsvalue
        height : isNxt ? 40 : 32
        anchors {
          left : kWhDecimalsMin.right
          leftMargin : isNxt ? 20 : 16
          bottom : kWhDecimalsMin.bottom
          bottomMargin : isNxt ? 5 : 4
        }
        text : "3"
        font.pixelSize : isNxt ? 40 : 32
      }

      Rectangle {
        id : kWhDecimalsPlus
        width : rowHeight  * 0.8
        height : width
        color : "#ababab"
        radius : 5
        border.width : 1
        anchors {
          left : kWhDecimalsvalue.right
          leftMargin : isNxt ? 20 : 16
        }
        Text {
          anchors {
            horizontalCenter : parent.horizontalCenter
            bottom : parent.bottom
            bottomMargin :  -0.1 * rowHeight
          }
          text : "+"
          font.pixelSize : isNxt ? 40 : 32
        }
        MouseArea {
          anchors.fill : parent
          onClicked : {
            if ( kWhDecimalsvalue.text < 3 ) { kWhDecimalsvalue.text = ( kWhDecimalsvalue.text * 1) + 1}
          }
        }
      }

    }

// ---------------- Radio buttons wifi dBm or

    Rectangle {
      id : wifidBmRadioButtons
      width : 300
      height : isNxt ? 130 : 104
      border.width : 0
      color : "#dcdcdc"
      anchors {
        left : kWhDecimalsRectangle.left
        top : kWhDecimalsRectangle.bottom
      }
      Column {

        spacing : isNxt ? 5 : 4
        Text {
          text : "WiFi:"
          height : isNxt ? 40 : 32
          font.underline : true
        }

// ---- Radio 1

        Item {
          id : w1
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_w1
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors{
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : w1.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "WiFi in dBm"
              anchors.verticalCenter : rect_w1.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              w1.checked = true
              w2.checked = false
            }
          }
        }

// ---- Radio 2

        Item {
          id : w2
          width : 150
          height : isNxt ? 40 : 32

          property bool checked : false

          Row {
            spacing : 6

            Rectangle {
              id : rect_w2
              width : 32
              height : 32
              radius : 16
              border.width : 1
              color : "transparent"

              Rectangle {
                anchors {
                  centerIn : parent
                }
                width : 16
                height : 16
                radius : 8
                color : w2.checked ? "black" : "transparent"
              }
            }

            Text {
              text : "WiFi in %"
              anchors.verticalCenter : rect_w2.verticalCenter
            }
          }

          MouseArea {
            anchors.fill : parent
            onClicked : {
              w1.checked = false
              w2.checked = true
            }
          }
        }
      }
    }

// ------------ appSetupScreen Quit, Save and Help ? Buttons

    Rectangle {
      id : saveButtonDP
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "green"
      anchors {
        right : helpButtonDP.left
        top : helpButtonDP.top
        rightMargin : 50
      }
      Text { anchors.centerIn : parent ; text : "Save" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          app.settingsActive = false
          appSetupScreen.appSettingsSave()
        }
      }
    }

    Rectangle {
      id : quitButtonDP
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "red"
      anchors {
        top : saveButtonDP.top
        right : saveButtonDP.left
        rightMargin : 50
      }
      Text { anchors.centerIn : parent ; text : "Quit" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          app.settingsActive = false
          updateScreenConfiguration()
          appSetupScreen.visible = false
        }
      }
    }

    Rectangle {
      id : helpButtonDP
      height : rowHeight
      width : rowHeight
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "blue"
      anchors {
        right : parent.right
        top : parent.top
        topMargin : isNxt ? 5 : 4
        rightMargin : isNxt ? 5 : 4
      }
      Text { anchors.centerIn : parent ; text : "?" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          Qt.inputMethod.hide()
          deviceSettingsPanelHelp.visible = true
        }
      }
    }

  }

// ---- deviceSettingsPanel

  Rectangle {
    id : deviceSettingsPanel

    visible : false

    property int deviceIndex : 0

    // used to show socket/p1 meter items and validate space in deviceKWHOffset
    property bool p1Meter : false

    anchors {
      top : parent.top
      horizontalCenter : parent.horizontalCenter
    }
    height : isNxt ? 290 : 232
    width : parent.width -20
    color : "#dcdcdc"
    radius : 8
    border {
      width : 2
      color : "black"
    }

    // block clicks to all items in the back
    MouseArea {
      anchors.fill : parent
      acceptedButtons : Qt.AllButtons
      propagateComposedEvents: false
    }

// -------- deviceSettingsPanel Functions

// ------------ Function editDeviceSettings

    function editDeviceSettings(index) {
      if ( ! deviceSettingsPanel.visible ) {
        app.settingsActive = true // block data collection
        deviceSettingsPanel.deviceIndex = index
        inputIP.color = "black"
        inputKWHOffset.color = "black"
        inputKWHOffset2.color = "black"

        deviceSettingsPanel.visible = true
      }
    }

// ------------ Function onVisibleChanged

    onVisibleChanged: {

      if (activeMe) {
        if (visible) {
          deviceSettingsPanel.loadDeviceSettingsPanelData()
        }
      }
    }

// ------------ Function loadDeviceSettingsPanelData

    function loadDeviceSettingsPanelData() {
      p1Meter = (deviceIndex == 8)

      deviceSettingsPanelTitle.text = p1Meter ? "P1 Meter Settings" : "Energy Socket " + (deviceIndex + 1) + " Settings"

      rectangleInputKWHOffset2.visible = p1Meter

      rectangleRingSegments.visible = ! p1Meter
      if (! p1Meter ) {
        mask_0.color = (deviceIndex == 0) ? "transparent" : "#505050cd"
        mask_1.color = (deviceIndex == 1) ? "transparent" : "#505050cd"
        mask_2.color = (deviceIndex == 2) ? "transparent" : "#505050cd"
        mask_3.color = (deviceIndex == 3) ? "transparent" : "#505050cd"
        mask_4.color = (deviceIndex == 4) ? "transparent" : "#505050cd"
        mask_5.color = (deviceIndex == 5) ? "transparent" : "#505050cd"
        mask_6.color = (deviceIndex == 6) ? "transparent" : "#505050cd"
        mask_7.color = (deviceIndex == 7) ? "transparent" : "#505050cd"
        mask_0_text.text  = (deviceIndex == 0) ? "1" : ""
        mask_1_text.text  = (deviceIndex == 1) ? "2" : ""
        mask_2_text.text  = (deviceIndex == 2) ? "3" : ""
        mask_3_text.text  = (deviceIndex == 3) ? "4" : ""
        mask_4_text.text  = (deviceIndex == 4) ? "5" : ""
        mask_5_text.text  = (deviceIndex == 5) ? "6" : ""
        mask_6_text.text  = (deviceIndex == 6) ? "7" : ""
        mask_7_text.text  = (deviceIndex == 7) ? "8" : ""
      }

      deviceSwitchEnableText.visible = ! p1Meter
      deviceSwitchEnableRectangle.visible = ! p1Meter

      inputIP.text = app.deviceIP[deviceIndex]
      inputName.text = app.deviceName[deviceIndex]

      inputKWHOffset.text = app.deviceKWHOffset[deviceIndex]
      if ( p1Meter ) { inputKWHOffset2.text = app.deviceKWHOffset[deviceIndex + 1] }

      deviceActive.font.strikeout = ! app.deviceActive[deviceIndex]
      deviceVisible.font.strikeout = ! app.deviceVisible[deviceIndex]

      deviceSwitchEnable.font.strikeout = ! app.deviceSwitchEnable[deviceIndex]
      rectangleDeviceVisible.visible = ! deviceActive.font.strikeout
      deviceSwitchEnableText.visible = ! deviceSettingsPanel.p1Meter && ! deviceVisible.font.strikeout && ! deviceActive.font.strikeout
      deviceSwitchEnableRectangle.visible = deviceSwitchEnableText.visible

      resetDayWeekCountersResetText.font.strikeout = true

    }

// ------------ Function deviceSettingsSave

    function deviceSettingsSave() {

      var validInput = true

      // Validate IP address input

      inputIP.color = "black"
      if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(inputIP.text))  {
        // Valid IP address
        if ( app.deviceIP[deviceIndex] != inputIP.text) {
          app.deviceIP[deviceIndex] = inputIP.text
        }
      } else {
        validInput = false
        inputIP.color = "red"
      }

      // Validate kWh Offset input

      inputKWHOffset.color = "black"
      if (/^[+-]?\d+(\.\d+)?$/.test(inputKWHOffset.text)) {
        app.deviceKWHOffset[deviceIndex] = inputKWHOffset.text * 1
      } else {
        validInput = false
        inputKWHOffset.color = "red"
      }

      // Validate kWh Offset output

      if (p1Meter) {
        inputKWHOffset2.color = "black"
        if (/^[+-]?\d+(\.\d+)?$/.test(inputKWHOffset2.text)) {
          app.deviceKWHOffset[deviceIndex+1] = inputKWHOffset2.text * 1
        } else {
          validInput = false
          inputKWHOffset2.color = "red"
        }
      }

      if (validInput) { // Save settings

        if ( p1Meter  && deviceActive.font.strikeout
          && ( app.homeWizardDataOnTile == app.homeWizardDataOnTileP1Meter ) ) {
          // p1 meter disabled & tile shows p1 meter data so reset to logo
          app.homeWizardDataOnTile = app.homeWizardDataOnTileLogo
        }

        if ( p1Meter  && ! deviceActive.font.strikeout && ! app.deviceActive[deviceIndex] ) {
          // p1 meter enabled during this setup so put p1 meter data on tile
          app.homeWizardDataOnTile = app.homeWizardDataOnTileP1Meter
        }

        app.deviceIP[deviceIndex] = inputIP.text
        app.deviceName[deviceIndex] = inputName.text
        app.deviceKWHOffset[deviceIndex] = inputKWHOffset.text * 1

        app.deviceSwitchEnable[deviceIndex] = ! deviceSwitchEnable.font.strikeout

        app.deviceActive[deviceIndex] = ! deviceActive.font.strikeout

        if (! app.deviceActive[deviceIndex] ) {
          app.deviceOn[deviceIndex] = false
        }

        app.deviceVisible[deviceIndex] = ! deviceVisible.font.strikeout

        if ( ! resetDayWeekCountersResetText.font.strikeout ) {
          // reset Day and Week counters by setting them to current values

          app.deviceKWHYesterday[deviceIndex] = app.deviceKWH[deviceIndex]
          app.deviceKWHLastWeek[deviceIndex] =  app.deviceKWH[deviceIndex]
          if (deviceIndex == 8) {
            app.deviceKWHYesterday[9] = app.deviceKWH[9]
            app.deviceKWHLastWeek[9] = app.deviceKWH[9]
          }
        }
        debug && app.log("Screen Save Device Settings")
        app.saveSettings()

        Qt.inputMethod.hide()
        visible = false
        updateScreenConfiguration()
        updateScreenData()
      }

    }

// -------- deviceSettingsPanel Title

    Text {
      id : deviceSettingsPanelTitle
      anchors {
        top : parent.top
        topMargin : isNxt ? 15 : 12
        left :  rectangleInputIP.left
      }
      text : "deviceSettingsPanelTitle"
      font.italic : true
    }

// ------------ deviceSettingsPanel IP

    Text {
      id : textIPAddress
      height : rowHeight
      text : "IP Adres: "
      anchors {
        top : deviceSettingsPanelTitle.bottom
        left : parent.left
        topMargin : isNxt ? 15 : 12
        leftMargin : isNxt ? 20 : 16
      }
    }

    Rectangle {
      id : rectangleInputIP
      height : rowHeight
      width : isNxt ? 220 : 176
      anchors {
        top : textIPAddress.top
        left : textIPAddress.right
        leftMargin : isNxt ? 5 : 4
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Rectangle {
        height : parent.height - 4
        width : parent.width - 10
        anchors.centerIn : parent
        TextInput {
          id : inputIP
          width : parent.width
          anchors.centerIn : parent
          text : "inputIP"
        }
      }
    }

// ------------ deviceSettingsPanel Name

    Text {
      id : textName
      height : rowHeight
      text : "Naam: "
      anchors {
        top : textIPAddress.bottom
        left : textIPAddress.left
        topMargin : 10
      }
    }

    Rectangle {
      id : rectangleInputName
      height : rowHeight
      width : isNxt ? 220 : 176
      anchors {
        top : textName.top
        left : rectangleInputIP.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Rectangle {
        height : parent.height - 4
        width : parent.width - 10
        anchors.centerIn : parent
        TextInput {
          id : inputName
          width : parent.width
          anchors.centerIn : parent
          text : "inputName"
        }
      }
    }

// ------------ deviceSettingsPanel Active and Visible

    Text {
      id : textDeviceActiveAndVisible
      height : rowHeight
      text : deviceSettingsPanel.p1Meter ? "P1 Meter:" : "Socket:"
      anchors {
        top : textName.bottom
        left : textName.left
        topMargin : 10
      }
    }

    Rectangle {
      id : rectangleDeviceActive
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : textDeviceActiveAndVisible.top
        left : rectangleInputName.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        id : deviceActive
        anchors.centerIn : parent
        text : "Active"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          deviceActive.font.strikeout = ! deviceActive.font.strikeout
          rectangleDeviceVisible.visible = ! deviceActive.font.strikeout
          deviceSwitchEnableText.visible =  ! deviceSettingsPanel.p1Meter && ! deviceVisible.font.strikeout && ! deviceActive.font.strikeout
          deviceSwitchEnableRectangle.visible = deviceSwitchEnableText.visible
        }
      }
    }

    Rectangle {
      id : rectangleDeviceVisible
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : textDeviceActiveAndVisible.top
        left : rectangleDeviceActive.right
        leftMargin : isNxt ? 5 : 4
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        id : deviceVisible
        anchors.centerIn : parent
        text : "Visible"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          deviceVisible.font.strikeout = ! deviceVisible.font.strikeout
          deviceSwitchEnableText.visible =  ! deviceSettingsPanel.p1Meter && ! deviceVisible.font.strikeout && ! deviceActive.font.strikeout
          deviceSwitchEnableRectangle.visible = deviceSwitchEnableText.visible
        }
      }
    }

// ------------ deviceSettingsPanel Enable

    Text {
      id : deviceSwitchEnableText
      height : rowHeight
      text : "Screen Switch: "
      anchors {
        top : textDeviceActiveAndVisible.bottom
        left : textDeviceActiveAndVisible.left
        topMargin : 10
      }
    }

    Rectangle {
      id : deviceSwitchEnableRectangle
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : deviceSwitchEnableText.top
        left : rectangleDeviceVisible.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        id : deviceSwitchEnable
        anchors.centerIn : parent
        text : "Enable"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          deviceSwitchEnable.font.strikeout = ! deviceSwitchEnable.font.strikeout
        }
      }
    }

// ------------ deviceSettingsPanel Start kWh

    Text {
      id : textkWhStart
      height : rowHeight
      text : "kWh Start:"
      anchors {
        top : textIPAddress.top
        left : rectangleInputIP.right
        leftMargin : rowHeight
      }
    }

    Rectangle {
      id : rectangleInputKWHOffset
      height : rowHeight
      width : isNxt ? 170 : 136
      anchors {
        top : textkWhStart.top
        left : resetDayWeekCountersText.right
        leftMargin : isNxt ? 10 : 8
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Rectangle {
        height : parent.height - 4
        width : parent.width - 10
        anchors.centerIn : parent
        TextInput {
          id : inputKWHOffset
          width : parent.width
          anchors.centerIn : parent
          text : "inputKWHOffset"
        }
      }
    }

    Rectangle {
      id : rectangleInputKWHOffset2
      height : rowHeight
      width : 170
      anchors {
        top : rectangleInputKWHOffset.top
        left : rectangleInputKWHOffset.right
        leftMargin : isNxt ? 5 : 4
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Rectangle {
        height : parent.height - 4
        width : parent.width - 10
        anchors.centerIn : parent
        TextInput {
          id : inputKWHOffset2
          width : parent.width
          anchors.centerIn : parent
          text : "inputKWHOffset"
        }
      }
    }

// ------------ deviceSettingsPanel Start kWh Presets

    Text {
      id : textKWHOffsetPreset0
      height : rowHeight
      text : "kWh Start Preset:"
      anchors {
        top : textkWhStart.bottom
        left : textkWhStart.left
        topMargin : 10
      }
    }

    Rectangle {
      id : kWhOffsetPresetsHomeZero
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : textKWHOffsetPreset0.top
        left : rectangleInputKWHOffset.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        anchors.centerIn : parent
        text : deviceSettingsPanel.p1Meter ? "0 0" : "0"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          inputKWHOffset.text = 0.0
          if (deviceSettingsPanel.deviceIndex == 8) {
            inputKWHOffset2.text = 0.0
          }
        }
      }
    }

    Text {
      id : textKWHOffsetPresetTotal
      height : rowHeight
      text : "kWh Start Preset:"
      anchors {
        top : textKWHOffsetPreset0.bottom
        left : textKWHOffsetPreset0.left
        topMargin : 10
      }
    }

    Rectangle {
      id : kWhOffsetPresetsHomeWizard
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : textKWHOffsetPresetTotal.top
        left : kWhOffsetPresetsHomeZero.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
        anchors.centerIn : parent
        text : deviceSettingsPanel.p1Meter ? "2 Totals" : "Total"
      }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          inputKWHOffset.text = app.deviceKWH[deviceSettingsPanel.deviceIndex]
          if (deviceSettingsPanel.deviceIndex == 8) {
            inputKWHOffset2.text = app.deviceKWH[deviceSettingsPanel.deviceIndex+1]
          }
        }
      }
    }

    Text {
      id : resetDayWeekCountersText
      height : rowHeight
      text : "Dag-Week-Maand:"
      anchors {
        top : textKWHOffsetPresetTotal.bottom
        left : textKWHOffsetPresetTotal.left
        topMargin : 10
      }
    }

    Rectangle {
      id : resetDayWeekCounters
      height : rowHeight
      width : buttonWidth
      color : "#ababab"
      anchors {
        top : resetDayWeekCountersText.top
        left : kWhOffsetPresetsHomeZero.left
      }
      radius : 8
      border {
        width : 2
        color : "black"
      }
      Text {
      id : resetDayWeekCountersResetText
        anchors.centerIn : parent
        text : "Reset"
        font.strikeout : true
      }
      MouseArea {
        anchors.fill : parent
        onClicked : { resetDayWeekCountersResetText.font.strikeout = ! resetDayWeekCountersResetText.font.strikeout }
      }
    }

// ------------ deviceSettingsPanel Segment Indicator

    Text {
      visible : ! deviceSettingsPanel.p1Meter
      anchors {
        horizontalCenter : rectangleRingSegments.horizontalCenter
        bottom : rectangleRingSegments.top
        bottomMargin : isNxt ? 5 : 4
      }
      text : "Segment"
    }

    Rectangle {
      id : rectangleRingSegments
      height : isNxt ? 150 : 120
      width : height
      color : "transparent"
      anchors {
        top : kWhOffsetPresetsHomeZero.top
        right : parent.right
        rightMargin : isNxt ? 25 : 20
      }
      border.width : 1
      Rectangle { // ring
        height : parent.height
        width : height
        color : "transparent"
        anchors.centerIn : parent
        radius : height / 2
        border {
          width : 10
          color : "#00ff00"
        }
      }

      Rectangle {
        id : mask_0
        height : parent.height / 3
        width : height
        color : "#cdcdcd"
        border.width : 0
        anchors {
          top : parent.top
          left : parent.left
        }
        Text {
          id : mask_0_text
          anchors.centerIn : parent
        }
      }

      Rectangle {
        id : mask_1
        height : parent.height / 3
        width : height
        color : "#cdcdcd"
        border.width : 0
        anchors {
          top : parent.top
          horizontalCenter : parent.horizontalCenter
        }
        Text {
          id : mask_1_text
          anchors.centerIn : parent
        }
      }

      Rectangle {
        id : mask_2
        height : parent.height / 3
        width : height
        color : "#cdcdcd"
        border.width : 0
        anchors {
          top : parent.top
          right : parent.right
        }
        Text {
          id : mask_2_text
          anchors.centerIn : parent
        }
      }

      Rectangle {
        id : mask_3
        height : parent.height / 3
        width : height
        color : "#cdcdcd"
        border.width : 0
        anchors {
          verticalCenter : parent.verticalCenter
          left : parent.left
        }
        Text {
          id : mask_3_text
          anchors.centerIn : parent
        }
      }

      Rectangle {
        id : mask_3_4
        height : parent.height / 3
        width : height
        color : "#505050cd"
        border.width : 0
        anchors.centerIn : parent
        Text {
          id : mask_3_4_text
          anchors.centerIn : parent
        }
      }

      Rectangle {
        id : mask_4
        height : parent.height / 3
        width : height
        color : "#cdcdcd"
        border.width : 0
        anchors {
          verticalCenter : parent.verticalCenter
          right : parent.right
        }
        Text {
          id : mask_4_text
          anchors.centerIn : parent
        }
      }

      Rectangle {
        id : mask_5
        height : parent.height / 3
        width : height
        color : "#cdcdcd"
        border.width : 0
        anchors {
          bottom : parent.bottom
          left : parent.left
        }
        Text {
          id : mask_5_text
          anchors.centerIn : parent
        }
      }

      Rectangle {
        id : mask_6
        height : parent.height / 3
        width : height
        color : "#cdcdcd"
        border.width : 0
        anchors {
          bottom : parent.bottom
          horizontalCenter : parent.horizontalCenter
        }
        Text {
          id : mask_6_text
          anchors.centerIn : parent
        }
      }

      Rectangle {
        id : mask_7
        height : parent.height / 3
        width : height
        color : "#cdcdcd"
        border.width : 0
        anchors {
          bottom : parent.bottom
          right : parent.right
        }
        Text {
          id : mask_7_text
          anchors.centerIn : parent
        }
      }

    }

// ------------ deviceSettingsPanel Quit, Save and Help ? Buttons

    Rectangle {
      id : helpButton
      height : rowHeight
      width : rowHeight
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "blue"
      anchors {
        right : parent.right
        top : parent.top
        topMargin : isNxt ? 5 : 4
        rightMargin : isNxt ? 5 : 4
      }
      Text { anchors.centerIn : parent ; text : "?" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          Qt.inputMethod.hide()
          deviceSettingsPanelHelp.visible = true
        }
      }
    }

    Rectangle {
      id : saveButton
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "green"
      anchors {
        right : helpButton.left
        top : helpButton.top
        rightMargin : 50
      }
      Text { anchors.centerIn : parent ; text : "Save" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          app.settingsActive = false
          deviceSettingsPanel.deviceSettingsSave()
        }
      }
    }

    Rectangle {
      id : quitButton
      height : rowHeight
      width : buttonWidth
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "red"
      anchors {
        top : saveButton.top
        right : saveButton.left
        rightMargin : 50
      }
      Text { anchors.centerIn : parent ; text : "Quit" }

      MouseArea {
        anchors.fill : parent
        onClicked : {
          app.settingsActive = false
          Qt.inputMethod.hide()
          deviceSettingsPanel.visible = false
        }
      }
    }

  }

// -------- deviceSettingsPanel Help / Info screen

  Rectangle {
    id : deviceSettingsPanelHelp
    visible : false

    anchors {
      top : deviceSettingsPanel.visible ? deviceSettingsPanel.bottom : parent.top
      horizontalCenter : parent.horizontalCenter
      topMargin : deviceSettingsPanel.visible ? 5 : 0
    }
    height :  deviceSettingsPanel.visible ? (parent.height - deviceSettingsPanel.height ) : parent.height
    width : parent.width - 20
    color : "#dcdcdc"
    radius : 8
    border {
      width : 2
      color : "black"
    }

    // block clicks to all items in the back
    MouseArea {
      anchors.fill : parent
      acceptedButtons : Qt.AllButtons
      propagateComposedEvents : false
    }

// ------------ deviceSettingsPanel Help / Info text

    Flickable {
      id : flick
      anchors.fill : parent
      contentWidth : width
      contentHeight : textItem.height + rowHeight
      clip : true

      Text {
        id : textItem
        anchors{
          top : parent.top
          left : parent.left
          topMargin : rowHeight / 2
          leftMargin : rowHeight
        }
        font.pixelSize : isNxt ? 20 : 16
        font.bold : true
        text :
          "Tot 8 HomeWizard Energy Sockets uitlezen en bedienen en 1 P1 Meter uitlezen."
        + "\n"
        + "\nOm een Energy Socket of je P1 meter module toe te voegen volg je deze stappen:"
        + "\n"
        + "\nIn de HomeWizard APP op je telefoon/tablet:"
        + "\n  - zoek in de settings naar je Energy Socket of P1 Meter en doe het volgende"
        + "\n  - ga naar {...}, activeer de schakelaar en vind its lager een IP-adres"
        + "\n  - dat IP-adres als '192.168.2.123' heb je nodig in de volgende stappen"
        + "\n"
        + "\nIn deze APP op je Toon:"
        + "\n  - verlaat dit scherm (>>), klik op een Energy Socket of de P1 Meter en..."
        + "\n  - met het vraagteken rechtsboven kun je dit informatie scherm weer oproepen"
        + "\n  - bij een Energy Socket staat rechts het tegel segment dat er bij hoort"
        + "\n  - vul het IP-adres in bij 'IP Adres' en wijzig de naam bij 'Naam'"
        + "\n  - klik op 'Active' om de doorhaling te verwijderen en de verbinding te maken"
        + "\n  - klik op 'Visible' om het apparaat op je scherm te tonen of te verbergen"
        + "\n"
        + "\nZonder 'Visible' wordt wel data verzameld maar zie je het niet op je scherm."
        + "\n    Het nut ? Stel je hebt 1 Socket, zet het IP-adres 4 x in de APP."
        + "\n    Dan kleuren 4 van de 8 segmenten op het tegeltje."
        + "\n"
        + "\nMet Screen Switch in de stand 'Enable' kun je de knop op het scherm bedienen."
        + "\nAls 'Enable' is doorgehaald wordt het knopje blauw en werkt het knopje niet meer."
        + "\nIn de telefoon/tablet HomeWizard APP werkt je knop nog wel. Op Toon niet meer."
        + "\n"
        + "\nWil je in de Toon HomeWizard APP de kWh zien sinds een bepaalde Start kWh?"
        + "\nVul dan het veld 'kWh Start' in."
        + "\nDe Presets knoppen vullen of '0' of het huidige totaal in."
        + "\n"
        + "\nNieuw apparaat aangesloten? Dan wil je de dag, week en maand tellers resetten."
        + "\nDeze beginnen op 0 na een reset en na het begin van een dag, week of maand."
        + "\nDeze tellers zijn dus pas correct na het begin van een nieuwe dag, week of maand."
        + "\n"
        + "\nOp het APP scherm staat rechtsonder een knop voor algemene APP settings."
        + "\nKies daar weergave settings voor het tegeltje en de kWh en WiFi signaalsterkte."
        + "\n"
        + "\n           >>> LET OP <<<"
        + "\n"
        + "\n    Als een HomeWizard niet kan worden uitlezen wordt de ring op het tegeltje rood."
        + "\n    Op het APP scherm krijgt het apparaat met het probleem een rood randje."
        + "\n    Vaak lost het zich binnen een minuut op. Duurt het langer?"
        + "\n    Is de schakelaar bij {...} in de settings in de telefoon/tablet app nog actief?"
        + "\n    Klopt het IP adres nog of is dat gewijzigd?"
        + "\n\n\n\n"
      }
    }

    ScrollBar {
      id : scrollbar
      container : flick
      laneColor : "#00FF00"
      alwaysShow : false

      property int scrollSkip : 75   // 75 pixels per click

      onNext :     flick.contentY = Math.min(flick.contentY + scrollSkip,
                                                flick.contentHeight - flick.height)

      onPrevious : flick.contentY = Math.max(flick.contentY - scrollSkip, 0)

      anchors {
        top : parent.top
        bottom : parent.bottom
        left : flick.left
      }
    }

// ------------ deviceSettingsPanel Help / Info Back Button

    Rectangle {
      height : rowHeight
      width : rowHeight
      radius : 8
      border {
        width : 2
        color : "black"
      }
      color : "blue"
      anchors {
        right : parent.right
        top : parent.top
        topMargin : isNxt ? 5 : 4
        rightMargin : isNxt ? 5 : 4
      }
      Text { anchors.centerIn : parent ; text : ">>" }
      MouseArea {
        anchors.fill : parent
        onClicked : {
          deviceSettingsPanelHelp.visible = false
        }
      }
    }

  }

}
