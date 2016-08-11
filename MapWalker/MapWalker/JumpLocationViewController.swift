//
//  JumpLocationViewController.swift
//  MapWalker
//
//  Created by Johnny on 8/11/16.
//  Copyright © 2016 MapWalker. All rights reserved.
//

import Foundation
import MapKit
import Cocoa

protocol JumpLocationProtocol {
  func returnMarkItLocation (coordinate:CLLocationCoordinate2D)
  func returnJumpToLocation (coordinate:CLLocationCoordinate2D)
  func getuserLocation () -> CLLocationCoordinate2D?
}

class JumpLocationViewController: NSViewController, NSWindowDelegate {
  @IBOutlet weak var textFieldLat: NSTextField!
  @IBOutlet weak var textFieldLng: NSTextField!
  
  var delegate:JumpLocationProtocol?

  override func viewDidLayout() {
    view.window?.delegate = self
  }
  
  func windowWillClose(notification: NSNotification) {
    let application = NSApplication.sharedApplication()
    application.stopModal()
  }
  
  @IBAction func buttonFillGPSLocationClick(sender: AnyObject) {
    if let coordinate = delegate?.getuserLocation() {
      setCoordinate(coordinate)
    }
  }
  
  @IBAction func buttonMarkItClick(sender: AnyObject) {
    view.window?.close()
    delegate?.returnMarkItLocation(getInputCoordinate())
  }
  
  @IBAction func buttonJumpToClick(sender: AnyObject) {
    view.window?.close()
    delegate?.returnJumpToLocation(getInputCoordinate())
  }
  
  func getInputCoordinate() -> CLLocationCoordinate2D {
    let lat:Double = (Double(textFieldLat.stringValue) == nil) ? 0.0 : Double(textFieldLat.stringValue)!
    let lng:Double = (Double(textFieldLng.stringValue) == nil) ? 0.0 : Double(textFieldLng.stringValue)!
    return CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
  }
  
  func setCoordinate(coordinate:CLLocationCoordinate2D) {
    textFieldLat.stringValue = String(coordinate.latitude)
    textFieldLng.stringValue = String(coordinate.longitude)
  }
}