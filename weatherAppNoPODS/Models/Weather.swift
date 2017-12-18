//
//  Weather.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

struct Weather {
  var temperature: Int
  var description: String
  
  init(temp: Double){
    self.temperature = Int(temp)
    self.description = ""
  }
  
  func convertTemperatureToCelsius() -> Int {
    return self.temperature-273
  }
}

