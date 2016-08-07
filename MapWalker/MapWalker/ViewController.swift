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

  let headingDelta:CLLocationDirection = 15.0
  let moveDelta:CLLocationDegrees = 0.0001
  
  var heading:CLLocationDirection = 0.0
  var centerCoordinate = CLLocationCoordinate2D()

  let locationManager = CLLocationManager()
  
  var keyDownList = Set<Int>(minimumCapacity: 10)
  var keyHandlerDispatched:Bool = false
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    // Get user location
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    
    mapView.showsBuildings = true
    mapView.mapType = .Standard
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }

  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    locationManager.stopUpdatingLocation()

    centerCoordinate = newLocation.coordinate
    /*
    let viewRegion = MKCoordinateRegionMake(centerCoordinate, MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    let adjustedRegion = mapView.regionThatFits(viewRegion)
    mapView.setRegion(adjustedRegion, animated: true)
 */
    updateCamera()
    let url = NSURL(fileURLWithPath: "MapWalker.gpx")
    let folderUrl = url.URLByDeletingLastPathComponent
    NSWorkspace.sharedWorkspace().openURL(folderUrl!)
  }

  func updateCamera() {
    let camera = MKMapCamera(lookingAtCenterCoordinate: centerCoordinate, fromDistance: 500, pitch: 45, heading: heading)
    mapView.camera = camera
    makeGPXFile()
  }

  func executeApplyGPXScript() {
    let path = NSBundle.mainBundle().pathForResource("ApplyGPX", ofType: "scpt")
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
  
  override func keyDown(event: NSEvent) {
    guard let characters = event.charactersIgnoringModifiers else {
      super.keyDown(event)
      return
    }
    guard let keyValue = characters.unicodeScalars.first?.value else {
      super.keyDown(event)
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
    default:
      super.keyDown(event)
      return
    }
    dispatchKeyHandler()
  }
  
  override func keyUp(event: NSEvent) {
    guard let characters = event.charactersIgnoringModifiers else {
      super.keyUp(event)
      return
    }
    guard let keyValue = characters.unicodeScalars.first?.value else {
      super.keyUp(event)
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
    default:
      super.keyUp(event)
    }
  }
  
  override func moveUp(sender: AnyObject?) {
    centerCoordinate.longitude += moveDelta * sin(Double(heading)*M_PI/180.0)
    centerCoordinate.latitude += moveDelta * cos(Double(heading)*M_PI/180.0)
    updateCamera()
  }

  override func moveDown(sender: AnyObject?) {
    centerCoordinate.longitude -= moveDelta * sin(Double(heading)*M_PI/180.0)
    centerCoordinate.latitude -= moveDelta * cos(Double(heading)*M_PI/180.0)
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
}

