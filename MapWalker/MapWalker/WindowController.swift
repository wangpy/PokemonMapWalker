//
//  WindowController.swift
//  MapWalker
//
//  Created by Brian Wang on 8/7/16.
//  Copyright © 2016 MapWalker. All rights reserved.
//

import Cocoa

class WindowController : NSWindowController {
  
  override func keyDown(with event: NSEvent) {
    if let viewController = contentViewController as? ViewController {
      viewController.handleKeyDown(event: event)
      return
    }
    super.keyDown(with: event)
  }

  override func keyUp(with event: NSEvent) {
    if let viewController = contentViewController as? ViewController {
      viewController.handleKeyUp(event: event)
      return
    }
    super.keyUp(with: event)
  }
}
