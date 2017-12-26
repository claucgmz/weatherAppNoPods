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
  var minTemperature: Int
  var maxTemperature: Int
  var description: String
  var cityName: String
  
  init(temperature: Double, minTemperature: Double, maxTemperature: Double, cityName: String, description: String){
    self.temperature = Int(temperature)
    self.minTemperature = Int(minTemperature)
    self.maxTemperature = Int(maxTemperature)
    self.cityName = cityName
    self.description = description
  }
  
  func convertTemperatureToCelsius() -> Int {
    return self.temperature-273
  }
}

extension Int {
  func convertTemperatureToCelsius() -> Int {
    return self-273
  }
}

