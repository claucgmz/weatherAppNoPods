//
//  Weather.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

struct Weather {
  private var _temperatureInKelvin: Double
  private var _minTemperatureInKelvin: Double
  private var _maxTemperatureInKelvin: Double
  
  var temperatureInCelsius: Int {
    return convertKelvinToCelsius(temperature: self._temperatureInKelvin)
  }
  
  var minTemperatureInCelsius: Int {
    return convertKelvinToCelsius(temperature: self._minTemperatureInKelvin)
  }
  
  var maxTemperatureInCelsius: Int {
    return convertKelvinToCelsius(temperature: self._maxTemperatureInKelvin)
  }
  
  var dateTime: Date
  var description: String
  var cityName: String
  var countryName: String

  init (withJSON weatherJSON: JSONDictionary) throws {
    guard let dateTime = weatherJSON["dt"] as? Double else {
      throw WeatherDataError.invalidData
    }
    
    guard let details = weatherJSON["weather"] as? [[String: Any]], !details.isEmpty else {
      throw WeatherDataError.invalidData
    }
    
    guard let description = details[0]["description"] as? String else {
      throw WeatherDataError.invalidData
    }
    
    guard let main = weatherJSON["main"] as? [String: Any] else {
      throw WeatherDataError.invalidData
    }
    
    guard let currentTemperature = main["temp"] as? Double else {
      throw WeatherDataError.invalidData
    }
    
    guard let minTemperature = main["temp_min"] as? Double else {
      throw WeatherDataError.invalidData
    }
    
    guard let maxTemperature = main["temp_max"] as? Double else {
      throw WeatherDataError.invalidData
    }
    
    guard let cityName = weatherJSON["name"] as? String else {
      throw WeatherDataError.invalidData
    }
    
    guard let country = weatherJSON["sys"] as? [String: Any] else {
      throw WeatherDataError.invalidData
    }
    
    guard let countryName = country["country"] as? String else {
      throw WeatherDataError.invalidData
    }
    
    self._temperatureInKelvin = currentTemperature
    self._minTemperatureInKelvin = minTemperature
    self._maxTemperatureInKelvin = maxTemperature
    self.dateTime = Date(timeIntervalSince1970: dateTime)
    self.cityName = cityName
    self.countryName = countryName
    self.description = description
  }
  
  init(withJSON weatherJSON: JSONDictionary, cityName: String, countryName: String, dateTime: Date) throws {
    
    guard let details = weatherJSON["weather"] as? [[String: Any]], !details.isEmpty else {
      throw WeatherDataError.invalidData
    }
    
    guard let description = details[0]["description"] as? String else {
      throw WeatherDataError.invalidData
    }
    
    guard let main = weatherJSON["main"] as? [String: Any] else {
      throw WeatherDataError.invalidData
    }
    
    guard let currentTemperature = main["temp"] as? Double else {
      throw WeatherDataError.invalidData
    }
    
    guard let minTemperature = main["temp_min"] as? Double else {
      throw WeatherDataError.invalidData
    }
    
    guard let maxTemperature = main["temp_max"] as? Double else {
      throw WeatherDataError.invalidData
    }
    
    self._temperatureInKelvin = currentTemperature
    self._minTemperatureInKelvin = minTemperature
    self._maxTemperatureInKelvin = maxTemperature
    self.dateTime = dateTime
    self.cityName = cityName
    self.countryName = countryName
    self.description = description
  }
  
  private func convertKelvinToCelsius(temperature: Double) -> Int {
    return Int(temperature-273.15)
  }
}
