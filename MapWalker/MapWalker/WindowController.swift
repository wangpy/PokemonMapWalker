//
//  WindowController.swift
//  MapWalker
//
//  Created by Brian Wang on 8/7/16.
//  Copyright © 2016 MapWalker. All rights reserved.
//

import Cocoa

class WindowController : NSWindowController {
  
  override func keyDown(event: NSEvent) {
    if let viewController = contentViewController as? ViewController {
      viewController.keyDown(event)
      return
    }
    super.keyDown(event)
  }

  override func keyUp(event: NSEvent) {
    if let viewController = contentViewController as? ViewController {
      viewController.keyUp(event)
      return
    }
    super.keyUp(event)
  }
}
