### Toon HomeWizard APP

Monitor and control up to 8 HomeWizard Energy Sockets from your Toon 1 / Toon 2 and optionally show HomeWizard P1 Meter data like kWh usage and kWh production.

When you click on the app tile on your Toon and you have no device configured yet, you get an information screen explaining how to use the app. See first screenshot below.

When you click the blue button you go to the Toon app screen with 8 icons for 8 Energy Sockets and 1 for a  P1 Meter you can add. See screenshot 2 below.

For each HomeWizard device you want in this app :

    - start the offical HomeWizard app on your phone/tablet
    - click ⚙️ in the top right corner to see a menu
    - select "Aparaten" 
    - select your Energy Socket or P1 Meter
    - enable "Lokale API"
    - and find the IP address like 192.168.4.123 just below "Lokale API"

On the Toon app screen you click a setup button on the left to enter the IP address for each of your HomeWizard devices. Note that the optional P1 Meter module is at the bottom.

During entering a valid IP address you will be able to modify the default name of the device which appears and more.
See screenshot 3.

There is a setup button <img src='./drawables/settings.png' width="20" height="20"> on the right to access a screen with some app settings. See screenshot 4.

Screenshot 5 shows the app screen with 6 Energy Sockets and the P1 Meter. The Sreen Switch for 'Fietsen' is blue because it is disabled in its settings. Screenshot 6 is an example of what the tile looks like when you choose '1 Socket : 1 Segment' and switches 1,3,5 and 7 are on. The Watts in the center are as measured by the P1 Meter. A positive number means you use energy, a negative number means energy is leaving your house. 

When you do not have a P1 Meter you can select to show date and time, the word 'HomeWizard' or a logo.

### Install the app 

This app is/may become available in the Toon Store but when you want to do it manually :

    - on Toon create a folder /qmf/qml/apps/toonHomeWizard
    - put at least the qml files and the drawables folder in the toonHomeWizard folder
    - to prepare for future updates via the Toon Store also copy version.txt
    - restart the GUI / reboot your Toon
    - add a tile for 'HomeWizard' ( green slider switch )
    - for updates you copy the files again or start using the Toon Store
      (to switch from manual to Toon Store you use the Toon Store to uninstall and install again)

Thanks for reading and enjoy the HomeWizard app.

<table border = 1 bordercolor ="red" align = center>
<tr>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_1.png">
</td>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_2.png">
</td>
</tr>
<tr>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_3.png">
</td>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_4.png">
</td>
</tr>
<tr>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_5.png">
</td>
<td>
<img width="400" height="240" src="https://github.com/JackV2020/appData/blob/main/toonHomeWizardscreenshots/toonHomeWizard_screenshot_6.png">
</td>
</tr>
</table>
