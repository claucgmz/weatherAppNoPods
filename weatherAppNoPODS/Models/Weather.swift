//
//  Weather.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

struct Weather {
  private var temperature: Int
  var description: String
  
  init(temperature: Double, description: String){
    self.temperature = Int(temperature)
    self.description = description
  }
  
  func convertTemperatureToCelsius() -> Int {
    return self.temperature-273
  }
}

