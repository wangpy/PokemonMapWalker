//
//  MyAnnotation.swift
//  MapWalker
//
//  Created by Johnny on 8/11/16.
//  Copyright © 2016 MapWalker. All rights reserved.
//

import Foundation
import MapKit

class MapPin : NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
  }
}