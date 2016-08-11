//
//  AppDelegate.swift
//  MapWalker
//
//  Created by Brian Wang on 8/7/16.
//  Copyright © 2016 MapWalker. All rights reserved.
//

import Cocoa
import MapKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, JumpLocationProtocol {
    
  func applicationDidFinishLaunching(notification: NSNotification) {
    // Insert code here to initialize your application
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }

  @IBAction func menuJumpToLocationClick(sender: AnyObject) {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let jumpLocationWindowController = storyboard.instantiateControllerWithIdentifier("JumpLocation") as! NSWindowController
    
    if let jumpLocationWindow = jumpLocationWindowController.window {
      let jumpLocationViewController = jumpLocationWindow.contentViewController as! JumpLocationViewController
      jumpLocationViewController.delegate = self
      if let coordinate = getCoordinateFromViewController() {
        jumpLocationViewController.setCoordinate(coordinate)
        let application = NSApplication.sharedApplication()
        application.runModalForWindow(jumpLocationWindow)
      }
    }
  }
    
  @IBAction func menuRemoveAllPinsClick(sender: AnyObject) {
    getMapViewController()?.handleRemoveAllPins()
  }
  
  func returnJumpToLocation(coordinate: CLLocationCoordinate2D) {
    getMapViewController()?.handleJumpToLocation(coordinate)
  }
  
  func returnMarkItLocation(coordinate: CLLocationCoordinate2D) {
    getMapViewController()?.handleMarkItLocation(coordinate)
  }
  
  func getuserLocation() -> CLLocationCoordinate2D? {
    return getMapViewController()?.userLocationCoordinate;
  }
  
  func getMapViewController() -> ViewController? {
    for window in NSApplication.sharedApplication().windows {
      if let viewController:ViewController = window.contentViewController as? ViewController {
          return viewController
      }
    }
    return nil
  }
    
  func getCoordinateFromViewController() -> CLLocationCoordinate2D? {
    return getMapViewController()?.centerCoordinate;
  }
}

