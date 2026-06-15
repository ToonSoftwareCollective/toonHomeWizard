import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
  id : app

// ---- Properties

// -------- Define the tile and the screen

  property url titleURL : "ToonHomeWizardTile.qml"
  property ToonHomeWizardTile homeWizardTile

  property url homeWizardScreenURL : "ToonHomeWizardScreen.qml"
  property ToonHomeWizardScreen homeWizardScreen

// -------- Control properties

  // used to (de)activate app.log messages
  property bool debug : false     // Errors and testing
  property bool debugAll : false  // debugAll for all others

  // goes true when tile is installed and enables Timers
  property bool activeMe : false // Tile not installed -> use no CPU

// -------- Properties in userSettingsFile

// Location of settings file

  FileIO {
    id: userSettingsFile
    source : "file:///mnt/data/tsc/toonHomeWizard.userSettings.json"
   }

// Values fixed, collected, calculated or entered by you on the screen

  property variant deviceIP : []
  property variant deviceName : []
  property variant deviceActive : []
  property variant deviceVisible : []
  property variant deviceSwitchEnable : []
  property variant deviceKWHYesterday : [] // today=current-yesterday
  property variant deviceKWHLastWeek : []  // week=current-last week
  property variant deviceKWHLastMonth : []  // month=current-last mont
  property variant deviceKWHOffset : []
  property int kWhDecimals : 3 // 0..3 on APP setup screen

  property string deviceKWHYesterdayDate: "unknown" // detect day change

// Settings on the settings screen

  // Tile format options ( only selected option value is saved )
  property int tileFormatAlwaysRing : 0
  property int tileFormatSegmentedRing: 1
  property int tileFormatWholeRing : 2
  property int tileFormat : tileFormatSegmentedRing

  // Default ring color, change green intensity on the settings screen
  property string tileRingColor : "#00A000"

  // P1 Meter data on tile options (only selected option value is saved)

  property int homeWizardDataOnTileLogo : 0
  property int homeWizardDataOnTileText : 1
  property int homeWizardDataOnTileNow : 2
  property int homeWizardDataOnTileP1Meter: 3
  property int homeWizardDataOnTile : homeWizardDataOnTileLogo

  // kWh column options  ( only selected option value is saved )
  property int kWhToday : 1
  property int kWhWeek : 2 // week is monday..sunday
  property int kWhMonth : 3
  property int kWhMinOffset : 4
  property int kWhTotal : 5
  property int kWhColumn : kWhToday

  // Default signal strength, true = dBm, false = %
  property bool wifidBm : true

// User settings read from settings file

  property variant userSettingsJSON : {}

  // when more devices have the same IP address we only collect the first
  // afterwards we copy these values to the others with the same IP

  property int first_index

// -------- Fixed and live properties

  property string errorColor : "#FF0000"

// The data collection Timer interval is different for tile and screen

  property int syncSlow : 60  // fixed in seconds
  property int syncFast : 10  // fixed in seconds
  property int syncIntervalms // actual interval in ms

  property bool settingsActive : false // when active, timers do nothing
//  onSettingsActiveChanged: { log("New value settingsActive: "+settingsActive) }

  // The timers control which HomeWizard device is polled for data
  property int index_device_reading

// live data from the devices

  property variant dataFromDeviceJSON

  property variant deviceOke : []
  property variant deviceOn : []

  property variant deviceWatts : []
  property variant deviceKWH : []
  property variant device_wifi : [] // wifi_strength level in %

// ---- Functions General

// -------- A function to log to the console with timestamps

  function log(tolog) {

    var now    = new Date();
    var dateTime = now.getFullYear() + '-' +
        ('00'+(now.getMonth() + 1)   ).slice(-2) + '-' +
        ('00'+ now.getDate()         ).slice(-2) + ' ' +
        ('00'+ now.getHours()        ).slice(-2) + ":" +
        ('00'+ now.getMinutes()      ).slice(-2) + ":" +
        ('00'+ now.getSeconds()      ).slice(-2) + "." +
        ('000'+now.getMilliseconds() ).slice(-3);

// This is a line with the name of the app in it so I can filter the log
    console.log(dateTime+' toonHomeWizard : ' + tolog.toString())

  }

// -------- Handy debug function dumps object properties

function dumpProperties(obj, desc) {
    log("=== dumpProperties ===")
    for (var key in obj) {
        try {
            var value = obj[key]
            if (typeof value === "function") {
                log(desc + " : " + key + " = <functie>")
                log(desc + "    name   = " + value.name)
                log(desc + "    params = " + value.length)
                log(desc + "    source = " + value.toString())
            }
            else {
                log(desc + " : " + key + " type = " + typeof value)
                log(desc + " : " + key + " = " + value)
            }
        }
        catch(e) {
            log(desc + " : " + key + " = <error>")
        }
    }
    log("=== dump end ===")
}

// -------- Register the tile and the screen

  function init() {
    const args = {
      thumbCategory : "general",
      thumbLabel : "HomeWizard",
      thumbIcon : "qrc:/tsc/button_on.png",
      thumbIconVAlignment : "center",
      thumbWeight : 30
    }
    registry.registerWidget("tile", titleURL, this, "homeWizardTile", args);
    registry.registerWidget("screen", homeWizardScreenURL, this, "homeWizardScreen");
  }

// -------- At startup initialise data, read saved data and settings

  Component.onCompleted: {
    // init default values
    var ii = 0
    for (ii = 0; ii < 10 ; ii++) {
      deviceIP.push( "0.0.0.0" )
      if (ii < 8 ) {
        // 0..7 are for Energy Sockets
        deviceName.push( "Energy Socket " + ( ii + 1 ) ) // Default name
      } else {
        // 8 and 9 are for import and export of P1 Meter
        deviceName.push( "P1 Meter ")
      }
      deviceKWHYesterday.push( 0.0 )
      deviceKWHLastWeek.push( 0.0 )
      deviceKWHLastMonth.push( 0.0 )
      deviceKWHOffset.push( 0.0 )
      deviceKWH.push( 0.0 )             // we did not read anything yet
      deviceActive.push( false )        // no ip yet so not active
      deviceVisible.push( false )       // visible when true
      deviceSwitchEnable.push( true )   // disabled when false
      deviceOke.push( true )            // assume communication is oke
      deviceOn.push( false )            // assume devices are off
      deviceWatts.push( 0.0 )           // we did not read anything yet
      device_wifi.push( 0.0 )           // we did not read anything yet
    }
    // read user settings ( first time fails and we save defaults )
    try {
      userSettingsJSON = JSON.parse(userSettingsFile.read());

      if ('deviceIP' in userSettingsJSON ) { deviceIP = userSettingsJSON['deviceIP'] }
      if ('deviceName' in userSettingsJSON ) { deviceName = userSettingsJSON['deviceName'] }
      if ('deviceActive' in userSettingsJSON ) { deviceActive = userSettingsJSON['deviceActive'] }
      if ('deviceVisible' in userSettingsJSON ) { deviceVisible = userSettingsJSON['deviceVisible'] }
      if ('deviceSwitchEnable' in userSettingsJSON ) { deviceSwitchEnable = userSettingsJSON['deviceSwitchEnable'] }
      if ('tileFormat' in userSettingsJSON ) { tileFormat = userSettingsJSON['tileFormat'] }
      if ('tileRingColor' in userSettingsJSON ) { tileRingColor = userSettingsJSON['tileRingColor'] }
      if ('wifidBm' in userSettingsJSON ) { wifidBm = userSettingsJSON['wifidBm'] }
      if ('kWhColumn' in userSettingsJSON ) { kWhColumn = userSettingsJSON['kWhColumn'] }
      if ('deviceKWHYesterday' in userSettingsJSON ) { deviceKWHYesterday = userSettingsJSON['deviceKWHYesterday'] }
      if ('deviceKWHLastWeek' in userSettingsJSON ) { deviceKWHLastWeek = userSettingsJSON['deviceKWHLastWeek'] }
      if ('deviceKWHLastMonth' in userSettingsJSON ) { deviceKWHLastMonth = userSettingsJSON['deviceKWHLastMonth'] }
      if ('deviceKWHYesterdayDate' in userSettingsJSON ) { deviceKWHYesterdayDate = userSettingsJSON['deviceKWHYesterdayDate'] }
      if ('deviceKWHOffset' in userSettingsJSON ) { deviceKWHOffset = userSettingsJSON['deviceKWHOffset'] }
      if ('homeWizardDataOnTile' in userSettingsJSON ) { homeWizardDataOnTile = userSettingsJSON['homeWizardDataOnTile'] }
      if ('kWhDecimals' in userSettingsJSON ) { kWhDecimals = userSettingsJSON['kWhDecimals'] }
    } catch(e) {
      saveSettings()
    }
    syncIntervalms = syncSlow * 1000
    // Glonal XMLHttpRequest objects to work around qml memory leak
    initXMLHttpRequests()
  }

// -------- Functions to save data and user settings

  function saveDeviceKWHHistory(){
    // called by timer
    // checks if day and week totals have to be updated for save
    var today = new Date();
    var strDate=today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()
    if (strDate != deviceKWHYesterdayDate) {
// each new day save deviceKWHYesterday
      debugAll && log("Copy Day and Week Counters and save Data")
      deviceKWHYesterdayDate = strDate
      var ii = 0
      for (ii = 0; ii < 10 ; ii++) {
        deviceKWHYesterday[ii] = deviceKWH[ii]
        if (today.getDay() == 1 ) {
// each new monday also save deviceKWHLastWeek
          deviceKWHLastWeek[ii] = deviceKWH[ii]
        }
        if (today.getDate() == 1 ) {
// each new month also save deviceKWHLastMonth
          deviceKWHLastMonth[ii] = deviceKWH[ii]
        }
      }
      saveSettings()
    }
  }

  function saveSettings(){
    if (activeMe) {
      var tmpUserSettingsJSON = {
        "deviceIP" : deviceIP,
        "deviceName" : deviceName,
        "deviceActive" : deviceActive,
        "deviceVisible" : deviceVisible,
        "kWhColumn" : kWhColumn,
        "deviceKWHYesterday" : deviceKWHYesterday,
        "deviceKWHLastWeek" : deviceKWHLastWeek,
        "deviceKWHLastMonth" : deviceKWHLastMonth,
        "deviceKWHYesterdayDate" : deviceKWHYesterdayDate,
        "deviceKWHOffset" : deviceKWHOffset,
        "kWhDecimals" : kWhDecimals,
        "deviceSwitchEnable" : deviceSwitchEnable,
        "wifidBm" : wifidBm,
        "tileFormat" : tileFormat,
        "tileRingColor" : tileRingColor,
        "homeWizardDataOnTile" : homeWizardDataOnTile
      }
      var doc3 = new XMLHttpRequest();
      doc3.open("PUT", userSettingsFile.source);
      doc3.send(JSON.stringify(tmpUserSettingsJSON));
    }
  }

// ---- Functions for HomeWizard communication

// -------- Functions for XMLHttpRequests

  property variant xhrGetData
  property variant xhrGetDataJsonResponse
  property int xhrGetDataCurrentIndex
  property bool xhrGetDataBusy : false

  property variant xhrGetState
  property variant xhrGetStateJsonResponse
  property int xhrGetStateCurrentIndex
  property bool xhrGetStateBusy : false

  property variant xhrMoveSwitch
  property variant xhrMoveSwitchJsonResponse
  property int xhrMoveSwitchCurrentIndex
  property bool xhrMoveSwitchBusy : false

  Timer {
    id : getHomeWizardDataTimeoutTimer
    interval : 2000 // timeout of 2 seconds
    running : false
    repeat : false
    onTriggered: {
      deviceOke[xhrGetDataCurrentIndex] = false
      log("Error Timeout Get Data: " +
        xhrGetDataCurrentIndex + " " +
        deviceIP[xhrGetDataCurrentIndex] +
        " Device: " + deviceName[xhrGetDataCurrentIndex])
      xhrGetData.abort()
      Qt.callLater(function() { xhrGetDataBusy = false })
    }
  }

  Timer {
    id : getHomeWizardStateTimeoutTimer
    interval : 4000 // timeout of 4 seconds
    running : false
    repeat : false
    onTriggered: {
      deviceOke[xhrGetStateCurrentIndex] = false
      log("Error Timeout Get State: " +
        xhrGetStateCurrentIndex + " " +
        deviceIP[xhrGetStateCurrentIndex] +
        " Device: " + deviceName[xhrGetStateCurrentIndex])
      xhrGetState.abort()
      Qt.callLater(function() { xhrGetStateBusy = false })
    }
  }

  function initXMLHttpRequests() {
    // create 3 global objects : xhrGetData, xhrGetState and xhrMoveSwitch

    xhrGetData = new XMLHttpRequest();

    xhrGetData.onreadystatechange = function() {
      if( xhrGetData.readyState === 4){
        if (xhrGetData.status === 200 || xhrGetData.status === 300  || xhrGetData.status === 302) {
          // we got an answer in time so stop the timeout timer
          getHomeWizardDataTimeoutTimer.stop()
          xhrGetDataJsonResponse = JSON.parse(xhrGetData.responseText);
          try {
            deviceWatts[xhrGetDataCurrentIndex] = xhrGetDataJsonResponse['active_power_w']
            device_wifi[xhrGetDataCurrentIndex] = xhrGetDataJsonResponse['wifi_strength']
            deviceKWH[xhrGetDataCurrentIndex] = xhrGetDataJsonResponse['total_power_import_kwh']
            // when deviceKWHYesterday, LastWeek and Month are 0 they have to start from now
            if ( deviceKWHYesterday[xhrGetDataCurrentIndex] == 0 ) { deviceKWHYesterday[xhrGetDataCurrentIndex] = deviceKWH[xhrGetDataCurrentIndex] }
            if ( deviceKWHLastWeek[xhrGetDataCurrentIndex]  == 0 ) { deviceKWHLastWeek[xhrGetDataCurrentIndex]  = deviceKWH[xhrGetDataCurrentIndex] }
            if ( deviceKWHLastMonth[xhrGetDataCurrentIndex]  == 0 ){ deviceKWHLastMonth[xhrGetDataCurrentIndex]  = deviceKWH[xhrGetDataCurrentIndex] }

            if (xhrGetDataCurrentIndex == 8) {
              // this is the P1 Meter with a 2nd KWH field for export which is in 'xhrGetDataCurrentIndex + 1'
              deviceKWH[xhrGetDataCurrentIndex+1] = xhrGetDataJsonResponse['total_power_export_kwh']
              // when deviceKWHYesterday, LastWeek and Month are 0 they have to start from now
              if ( deviceKWHYesterday[xhrGetDataCurrentIndex + 1] == 0 ) { deviceKWHYesterday[xhrGetDataCurrentIndex + 1] = deviceKWH[xhrGetDataCurrentIndex + 1] }
              if (  deviceKWHLastWeek[xhrGetDataCurrentIndex + 1] == 0 ) { deviceKWHLastWeek[xhrGetDataCurrentIndex + 1] = deviceKWH[xhrGetDataCurrentIndex + 1] }
              if (  deviceKWHLastMonth[xhrGetDataCurrentIndex + 1] == 0 ){ deviceKWHLastMonth[xhrGetDataCurrentIndex + 1] = deviceKWH[xhrGetDataCurrentIndex + 1] }
            }
            deviceOke[xhrGetDataCurrentIndex] = true
          } catch(e) {
            log("Error Get Data: " + xhrGetDataCurrentIndex + " " + deviceIP[xhrGetDataCurrentIndex] + " Device: " + deviceName[xhrGetDataCurrentIndex]+" ; "+e);
            deviceOke[xhrGetDataCurrentIndex] = false
          }
        }else{
          log("xhrGetData fault response: " + xhrGetDataCurrentIndex + " " + deviceIP[xhrGetDataCurrentIndex] + " Device: " + deviceName[xhrGetDataCurrentIndex]+ " ; " + xhrGetData.status + " ; "  + xhrGetData.responseText)
        }
        Qt.callLater(function() { xhrGetDataBusy = false })
      }
    }

    xhrGetState = new XMLHttpRequest();

    xhrGetState.onreadystatechange = function() {
      if( xhrGetState.readyState === 4){
        if (xhrGetState.status === 200 || xhrGetState.status === 300  || xhrGetState.status === 302) {
          // we got an answer in time so stop the timeout timer
          getHomeWizardStateTimeoutTimer.stop()
          xhrGetStateJsonResponse= JSON.parse(xhrGetState.responseText)
          if ('power_on' in xhrGetStateJsonResponse ) {
            deviceOn[xhrGetStateCurrentIndex] = xhrGetStateJsonResponse['power_on']
          } else {
            log("xhrGetStateJsonResponse ERROR " + xhrGetStateCurrentIndex + " " + deviceIP[xhrGetStateCurrentIndex] + " Device: " + deviceName[xhrGetStateCurrentIndex])
          }
        }else{
          log("xhrGetState fault response: "  + xhrGetStateCurrentIndex + " " + deviceIP[xhrGetStateCurrentIndex] + " Device: " + deviceName[xhrGetStateCurrentIndex] + " ; " + xhrGetState.status + " ; "  + xhrGetState.responseText)
        }
        Qt.callLater(function() { xhrGetStateBusy = false })
      }
    }

    xhrMoveSwitch = new XMLHttpRequest();

    xhrMoveSwitch.onreadystatechange = function() {
      if( xhrMoveSwitch.readyState === 4){
        if (xhrMoveSwitch.status === 200 || xhrMoveSwitch.status === 300  || xhrMoveSwitch.status === 302) {
          xhrMoveSwitchJsonResponse= JSON.parse(xhrMoveSwitch.responseText)
          if ('power_on' in xhrMoveSwitchJsonResponse ) {
            deviceOn[xhrMoveSwitchCurrentIndex] = xhrMoveSwitchJsonResponse['power_on']
            homeWizardScreen.updateScreenData()
          } else {
            log("xhrMoveSwitchJsonResponse ERROR " + xhrMoveSwitchCurrentIndex + " " + deviceIP[xhrMoveSwitchCurrentIndex] + " Device: " + deviceName[xhrMoveSwitchCurrentIndex])
          }
        }else{
          log("xhrMoveSwitch fault response: "  + xhrMoveSwitchCurrentIndex + " " + deviceIP[xhrMoveSwitchCurrentIndex] + " Device: " + deviceName[xhrMoveSwitchCurrentIndex] + " ; "  + xhrMoveSwitch.status + " ; "  + xhrMoveSwitch.responseText)
        }
        Qt.callLater(function() {xhrMoveSwitchBusy = false })
      }
    }

  }

// -------- Function getHomeWizard

  function getHomeWizardData(index_device) {
    // get the data

    // find first active device for this IP address
    first_index = deviceIP.indexOf(deviceIP[index_device])
    while ( ( ! deviceActive[first_index] )  && (first_index > -1 ) ) {
      first_index = deviceIP.indexOf(deviceIP[index_device], first_index + 1)
    }

    if ( ( first_index < index_device ) && deviceActive[first_index] ) {
      // we leave this function and copy the data later from first_index
      debugAll && log("Skip Extra Data Collection for: "+index_device)
    } else {
      if (xhrGetDataBusy) {
        debug && log("xhrGetData  is busy for device: "+xhrGetDataCurrentIndex+" "+deviceIP[xhrGetDataCurrentIndex] + "  " + deviceName[xhrGetDataCurrentIndex])
      } else {
        xhrGetDataBusy = true
        // tell index_device to xhrGetData.onreadystatechange
        xhrGetDataCurrentIndex = index_device
        xhrGetData.open("GET", "http://"+deviceIP[index_device]+"/api/v1/data", true);
        xhrGetData.send();
        // we may not get an answer in time so start the timeout timer
        getHomeWizardDataTimeoutTimer.start()
      }
    }
  }

  function getHomeWizardState(index_device) {
    // get power switch state

    // find first active device for this IP address
    if ( deviceOke[xhrGetDataCurrentIndex] ) {
      first_index = deviceIP.indexOf(deviceIP[index_device])
      if ( ( first_index < index_device ) && deviceActive[first_index] ) {
      // we leave this function and copy the data later from first_index
        debugAll && log("Skip Extra State Collection for: "+index_device)
      } else {
        if (xhrGetStateBusy) {
            debug && log("xhrGetState is busy for device: "+xhrGetStateCurrentIndex+" "+deviceIP[xhrGetStateCurrentIndex] + "  " + deviceName[xhrGetStateCurrentIndex])
        } else {
          xhrGetStateBusy = true
          xhrGetStateCurrentIndex = index_device
          xhrGetState.open("GET", "http://"+deviceIP[index_device]+"/api/v1/state", true);
          xhrGetState.send();
        // we may not get an answer in time so start the timeout timer
          getHomeWizardStateTimeoutTimer.start()
        }
      }
    }
  }

// -------- Function switchHomeWizard

  function switchHomeWizard(index_device) {
    if (xhrMoveSwitchBusy) {
        debug && log("xhrMoveSwitch is busy for device: "+xhrMoveSwitchCurrentIndex+" "+deviceIP[xhrMoveSwitchCurrentIndex] + "  " + deviceName[xhrMoveSwitchCurrentIndex])
    } else {
      xhrMoveSwitchCurrentIndex = index_device
      xhrMoveSwitchBusy = true
      xhrMoveSwitch.open("PUT", "http://"+deviceIP[index_device]+"/api/v1/state", true);
      xhrMoveSwitch.setRequestHeader("Content-Type", "application/json");
      xhrMoveSwitch.send(JSON.stringify({ "power_on": deviceOn[index_device] }));
    }
  }

// ---- Timers and function to change Main Timer interval

// -------- Data collection Timer, started by Main Timer, stops itself

//  activated each syncIntervalms by startGetHomeWizardsTimerTimer

  property bool ignoringErrors : true

  Timer {
    id : getHomeWizardsTimer
    interval : 500
    running : false
    repeat : true
    triggeredOnStart : true
    onTriggered: {

      // NOTE: to allow XMLHttpRequest to finish it runs 15 times.

      if ( settingsActive ) { index_device_reading = 15 } // force data collection stop

      // skip inactive devices
      while ( ( ! deviceActive[index_device_reading] ) && (index_device_reading < 9)  ) {
        index_device_reading = index_device_reading + 1 ;
      }

      // Only devices 0..8, not 9 which is P1 Meter export which comes with 8
      if (index_device_reading < 9) {

        if (deviceOke[index_device_reading] || ignoringErrors) {
          // ignoringErrors is true every other run to allow devices which
          //   are not oke to retry and become ok
          getHomeWizardData(index_device_reading)
          // 9 is a P1 Meter and has no power button
          if (index_device_reading < 8 ) {
            getHomeWizardState(index_device_reading)
          }
        }
      } else {
        // All device data requests are running but maybe not completed
        // so I loop some more before I process data and stop myself.
        if (index_device_reading == 15) {

          var index_device
          for (index_device = 1 ; index_device < 8; index_device++ ) {
            if (deviceActive[index_device]) {
              first_index = deviceIP.indexOf(deviceIP[index_device])
              while ( ( ! deviceActive[first_index] )  && (first_index > -1 ) ) {
                first_index = deviceIP.indexOf(deviceIP[index_device], first_index + 1)
              }
              if ( first_index > -1 ) {
                if ( ( first_index < index_device ) && deviceActive[first_index] ) {
                  debugAll && log("Copy Data from: "+first_index+ " to: "+index_device)
                  deviceWatts[index_device] = deviceWatts[first_index]
                  device_wifi[index_device] = device_wifi[first_index]
                  deviceKWH[index_device] = deviceKWH[first_index]
                  deviceKWHYesterday[index_device] = deviceKWHYesterday[first_index]
                  deviceKWHLastWeek[index_device] = deviceKWHLastWeek[first_index]
                  deviceKWHLastMonth[index_device] = deviceKWHLastMonth[first_index]
                  deviceOn[index_device] = deviceOn[first_index]
                }
              }
            }
          }
          homeWizardTile.updateTileData()
          homeWizardScreen.updateScreenData()
          saveDeviceKWHHistory()
          getHomeWizardsTimer.stop() // stop myself
          debug && log("Stopped getHomeWizardsTimer")
        }
      }
      index_device_reading = index_device_reading + 1 ;
    }
  }

// -------- Main Timer to start data collection Timer each interval

// Main Timer in ms syncIntervalms

  Timer {
    id: startGetHomeWizardsTimerTimer
    interval: syncIntervalms
    running: activeMe // Tile not installed -> do not run -> no CPU waste
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      if ( ! settingsActive ) {
        if (getHomeWizardsTimer.running) {
          debug && log("Skip getHomeWizardsTimer")
        } else {
          ignoringErrors = ! ignoringErrors
          index_device_reading = 0 ;
          getHomeWizardsTimer.start()
          debug && log("Started getHomeWizardsTimer")
        }
      }
    }
  }

// -------- Function to change Main Timer interval

  function startGetHomeWizardsTimerTimerSpeed(NewInterval) {
    startGetHomeWizardsTimerTimer.stop()
    syncIntervalms = NewInterval * 1000
    startGetHomeWizardsTimerTimer.start()
  }

}
