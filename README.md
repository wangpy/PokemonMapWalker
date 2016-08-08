# PokemonMapWalker
PokemonMapWalker is a Cocoa app to walk on map using keyboard arrow keys.

This project is inspired from kahopoon's [Pokemon-Go-Controller](https://github.com/kahopoon/Pokemon-Go-Controller) project but I made my own version because I feel it should be done in a simpler way.

  - Controller app (MapWalker) is made as an Cocoa app so only a Mac is necessary other than your iOS game device.
  - Xcode is still needed for location simulation.
  - AppleScript (ApplyGPX.scpt) is used to apply GPX script to location simulator.

### How to use it
  - Move by keyboard
    - https://www.youtube.com/watch?v=Xvyb-MKgKq0
  - Move by dragging - Thanks to Johnny Sung (j796160836)[https://github.com/j796160836]
    - https://www.youtube.com/watch?v=TjmW9-Vz7TI

### How to set up
  - Download **Xcode** from Mac App Store
  - Download the project as zip and extract
  - Open `MapWalker/MapWalker.xcodeproj` and **Run** the project
  - Allow location access when prompted. 
    - After approval, a **Finder** window will be opened with `MapWalker.gpx` inside. Don't close this Finder window, you will need it later
  - Open **Settings** -> **Security & Privacy** -> **Accessibility** -> (Click the lock to make changes) -> Allow **Xcode** to control your computer
  - In **Xcode** menu bar, click **Preferences** -> **Accounts** -> **Press +** -> **Add Apple ID...** -> (Add your Apple ID to Xcode)
  - Connect your iOS game device (with **Pokemon Go** installed) to your Mac
    - Allow your computer to access your device when prompted, and also trust the computer when prompted on your device.
  - Open **LocationSimulation/LocationSimulation.xcodeproj** 
  - in **Xcode** menu bar, click **Product** -> **Destination** -> **(Choose Your connected iOS device)**
  - **Run** the project
  - Switch to the **Finder** window which is opened when you allow location access to **MapWalker** app. 
  - Drag **MapWalker.gpx** to your project.
    - **Remember to uncheck "Copy file to project" !!!**
  - On your iOS device, press home and open **Maps** app for verification
  - in **Xcode** menu bar, click **Debug** -> **Simulate Location** -> Select **MapWalker**. Your location in **Maps** app should be moved to the latest location in MapWalker app.
    - If nothing can be selected in **Simulate Location** menu, make sure you are switched to "LocationSimulation" project window in Xcode and the app is running and is run from Xcode.
  - Switch back to **MapWalker** app, use arrow keys to move on the maps and see if your location in Maps app on iOS device is also moved.
    - If your location in **Maps** app is not moved, check the following **Troubleshooting** part.

Troubleshooting
----
  - Make sure your active window in Xcode is LocationSimulation project window
    - When you click on Xcode app icon, the top-most window should be locationSimulation project. If not, switch to it using Xcode **Window** menu. 
  - And also make sure the active document in the window is LocationSimulation project file
    - Single-click on the first item in project navigator
  - Make sure Xcode is allowed to control your computer in **Settings** -> **Security & Privacy** -> **Accessibility**.
  - Make sure LocationSimulation project is running on your device and **is run from Xcode**
  - Try to activate location yourself in Location Simulation project, then switch back to MapWalker app
    - In Xcode LocationSimulation project window, click **Debug** -> **Simulate Location** -> Select **MapWalker**
  - Try to delete MapWalker.gpx in LocationSimulation project (click "Remove Reference") and add again.

License
----

GPL v3
