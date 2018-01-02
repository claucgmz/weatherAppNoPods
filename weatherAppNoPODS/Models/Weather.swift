//
//  Weather.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

struct Weather {
  
  var dateTime: Double
  var temperature: Int
  var minTemperature: Int
  var maxTemperature: Int
  var description: String
  var cityName: String
  var countryName: String
  
  init(temperature: Double, minTemperature: Double, maxTemperature: Double, dateTime: Double, cityName: String, countryName: String, description: String) {
    self.temperature = Int(temperature)
    self.minTemperature = Int(minTemperature)
    self.maxTemperature = Int(maxTemperature)
    self.dateTime = dateTime
    self.cityName = cityName
    self.countryName = countryName
    self.description = description
  }
}

extension Int {
  func convertTemperatureToCelsius() -> Int {
    return self-273
  }
}

