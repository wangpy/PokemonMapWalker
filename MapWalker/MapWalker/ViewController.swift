//
//  ViewController.swift
//  MapWalker
//
//  Created by Brian Wang on 8/7/16.
//  Copyright © 2016 MapWalker. All rights reserved.
//

import Cocoa
import MapKit
import Dispatch

class ViewController: NSViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  internal let defaultLocationCoordinate = CLLocationCoordinate2D(latitude: 25.033680, longitude: 121.564548) // Location of Taipei 101
  let headingDelta:CLLocationDirection = 3.0
  let moveDelta:CLLocationDegrees = 0.0001
  
  var heading:CLLocationDirection = 0.0
  internal var centerCoordinate = CLLocationCoordinate2D()
  internal var userLocationCoordinate = CLLocationCoordinate2D()
    
  let locationManager = CLLocationManager()
  
  var keyDownList = Set<Int>(minimumCapacity: 10)
  var keyHandlerDispatched:Bool = false
    
  var timer:NSTimer?
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    // Get user location
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    
    timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(ViewController.applyDefaultCoordinate), userInfo: nil, repeats: false)
    
    mapView.showsBuildings = true
    mapView.mapType = .Standard
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
    
  func applyDefaultCoordinate() {
    locationManager.stopUpdatingLocation()
    centerCoordinate = defaultLocationCoordinate
    userLocationCoordinate = defaultLocationCoordinate
    print("applyDefaultCoordinate lat:\(centerCoordinate.latitude) lng:\(centerCoordinate.longitude)")
    initializeMap()
  }

  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    locationManager.stopUpdatingLocation()

    timer?.invalidate()
    userLocationCoordinate = newLocation.coordinate
    centerCoordinate = newLocation.coordinate
    /*
    let viewRegion = MKCoordinateRegionMake(centerCoordinate, MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    let adjustedRegion = mapView.regionThatFits(viewRegion)
    mapView.setRegion(adjustedRegion, animated: true)
 */
     initializeMap()
  }
    
  func initializeMap() {
    updateCamera(false)
    let url = NSURL(fileURLWithPath: "MapWalker.gpx")
    let folderUrl = url.URLByDeletingLastPathComponent
    NSWorkspace.sharedWorkspace().openURL(folderUrl!)
  }

  func updateCamera(mapInitialized:Bool = true) {
    var distance = 500.0
    if mapInitialized {
        distance = mapView.camera.altitude / cos(M_PI*(Double(mapView.camera.pitch)/180.0))
    }
    let camera = MKMapCamera(lookingAtCenterCoordinate: centerCoordinate,
                             fromDistance: distance,
                             pitch: 45,
                             heading: heading)
    mapView.camera = camera
    makeGPXFile()
  }

  func executeApplyGPXScript() {
    let path = NSBundle.mainBundle().pathForResource("ApplyGPX", ofType: "scpt")
    if path == nil {
      print("Script not found.")
      return
    }
    let url = NSURL(fileURLWithPath: path!)
    var errorDict:NSDictionary? = nil
    let appleScript = NSAppleScript(contentsOfURL: url, error: &errorDict)
    if errorDict != nil {
      print("Error creating AppleScript: \(errorDict?.description)")
      return
    }
    appleScript?.executeAndReturnError(&errorDict)
    if errorDict != nil {
      print("Error executing AppleScript: \(errorDict?.description)")
      return
    }
  }
  
  func makeGPXFile() {
    let fileContent = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><gpx version=\"1.0\"><name>Example gpx</name><wpt lat=\"\(centerCoordinate.latitude)\" lon=\"\(centerCoordinate.longitude)\"><name>WP</name></wpt></gpx>"
    do {
      try fileContent.writeToFile("MapWalker.gpx", atomically: true, encoding: NSUTF8StringEncoding)
      executeApplyGPXScript()
    } catch {
      // do nothing
      print("error writing file")
    }
  }
  
  func keyHandler() {
    if keyDownList.count == 0 {
      keyHandlerDispatched = false
      return
    }
    
    if (keyDownList.contains(NSUpArrowFunctionKey)) {
      moveUp(nil)
    }
    if (keyDownList.contains(NSDownArrowFunctionKey)) {
      moveDown(nil)
    }
    if (keyDownList.contains(NSLeftArrowFunctionKey)) {
      moveLeft(nil)
    }
    if (keyDownList.contains(NSRightArrowFunctionKey)) {
      moveRight(nil)
    }
    if (keyDownList.contains(Int((String(" ").unicodeScalars.first?.value)!))) {
      updateCamera()
    }
    
    dispatch_async(dispatch_get_main_queue()) { 
      self.keyHandler()
    }
  }
  
  func dispatchKeyHandler() {
    if keyHandlerDispatched {
      return
    }
    keyHandlerDispatched = true
    dispatch_async(dispatch_get_main_queue()) {
      self.keyHandler()
    }
  }
    
  func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    if (abs(mapView.centerCoordinate.latitude - centerCoordinate.latitude) > 0.00001
       || abs(mapView.centerCoordinate.longitude - centerCoordinate.longitude) > 0.00001) {
      centerCoordinate = mapView.centerCoordinate
      updateCamera()
    }
  }
  
  func handleKeyDown(event: NSEvent) {
    
    guard let characters = event.charactersIgnoringModifiers else {
      return
    }
    guard let keyValue = characters.unicodeScalars.first?.value else {
      return
    }
    switch (Int(keyValue)) {
    case NSUpArrowFunctionKey:
      keyDownList.insert(NSUpArrowFunctionKey)
    case NSDownArrowFunctionKey:
      keyDownList.insert(NSDownArrowFunctionKey)
    case NSLeftArrowFunctionKey:
      keyDownList.insert(NSLeftArrowFunctionKey)
    case NSRightArrowFunctionKey:
      keyDownList.insert(NSRightArrowFunctionKey)

    case Int((String("w").unicodeScalars.first?.value)!):
      keyDownList.insert(NSUpArrowFunctionKey)
    case Int((String("s").unicodeScalars.first?.value)!):
      keyDownList.insert(NSDownArrowFunctionKey)
    case Int((String("a").unicodeScalars.first?.value)!):
      keyDownList.insert(NSLeftArrowFunctionKey)
    case Int((String("d").unicodeScalars.first?.value)!):
      keyDownList.insert(NSRightArrowFunctionKey)

    case Int((String("=").unicodeScalars.first?.value)!):
      keyDownList.insert(Int((String("=").unicodeScalars.first?.value)!))
    case Int((String("-").unicodeScalars.first?.value)!):
      keyDownList.insert(Int((String("+").unicodeScalars.first?.value)!))
        
    case Int((String(" ").unicodeScalars.first?.value)!):
      keyDownList.insert(Int((String(" ").unicodeScalars.first?.value)!))
    default:
      return
    }
    dispatchKeyHandler()
  }
  
  func handleKeyUp(event: NSEvent) {
    guard let characters = event.charactersIgnoringModifiers else {
      return
    }
    guard let keyValue = characters.unicodeScalars.first?.value else {
      return
    }
    switch (Int(keyValue)) {
    case NSUpArrowFunctionKey:
      keyDownList.remove(NSUpArrowFunctionKey)
    case NSDownArrowFunctionKey:
      keyDownList.remove(NSDownArrowFunctionKey)
    case NSLeftArrowFunctionKey:
      keyDownList.remove(NSLeftArrowFunctionKey)
    case NSRightArrowFunctionKey:
      keyDownList.remove(NSRightArrowFunctionKey)
      
    case Int((String("w").unicodeScalars.first?.value)!):
      keyDownList.remove(NSUpArrowFunctionKey)
    case Int((String("s").unicodeScalars.first?.value)!):
      keyDownList.remove(NSDownArrowFunctionKey)
    case Int((String("a").unicodeScalars.first?.value)!):
      keyDownList.remove(NSLeftArrowFunctionKey)
    case Int((String("d").unicodeScalars.first?.value)!):
      keyDownList.remove(NSRightArrowFunctionKey)
      
    case Int((String("=").unicodeScalars.first?.value)!):
      keyDownList.remove(Int((String("=").unicodeScalars.first?.value)!))
    case Int((String("-").unicodeScalars.first?.value)!):
      keyDownList.remove(Int((String("+").unicodeScalars.first?.value)!))
        
    case Int((String(" ").unicodeScalars.first?.value)!):
      keyDownList.remove(Int((String(" ").unicodeScalars.first?.value)!))
    default:
      break;
    }
  }
    
  internal func handleJumpToLocation(coordinate: CLLocationCoordinate2D) {
    centerCoordinate = coordinate
    updateCamera()
  }
    
  internal func handleMarkItLocation(coordinate: CLLocationCoordinate2D) {
    let num = mapView.annotations.count + 1
    let mapPin = MapPin.init(coordinate: coordinate, title: "Location \(num)", subtitle: "Latitude:\(centerCoordinate.latitude)\nLongitude:\(centerCoordinate.longitude)")
    mapView.addAnnotation(mapPin)
  }
    
  internal func handleRemoveAllPins() {
    mapView.removeAnnotations(mapView.annotations)
  }
  
  override func moveUp(sender: AnyObject?) {
    let scaleFactor = 1500.0 / mapView.camera.altitude
    centerCoordinate.longitude += moveDelta * sin(Double(heading)*M_PI/180.0) / scaleFactor
    centerCoordinate.latitude += moveDelta * cos(Double(heading)*M_PI/180.0) / scaleFactor
    updateCamera()
  }

  override func moveDown(sender: AnyObject?) {
    let scaleFactor = 1500.0 / mapView.camera.altitude
    centerCoordinate.longitude -= moveDelta * sin(Double(heading)*M_PI/180.0) / scaleFactor
    centerCoordinate.latitude -= moveDelta * cos(Double(heading)*M_PI/180.0) / scaleFactor
    updateCamera()
  }

  override func moveLeft(sender: AnyObject?) {
    heading -= headingDelta
    updateCamera()
  }

  override func moveRight(sender: AnyObject?) {
    heading += headingDelta
    updateCamera()
  }
  
  @IBAction func roundButtonClick(sender: AnyObject) {
    updateCamera()
  }
}

