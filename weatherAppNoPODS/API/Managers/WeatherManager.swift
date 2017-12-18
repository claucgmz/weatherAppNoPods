//
//  WeatherManager.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

class WeatherManager {
  
  let weatherServices = WeatherServices()
  
  func getWeatherByLatLon(lat: Double, lon: Double, completion: @escaping(Weather?, Error?) -> Void) {
    weatherServices.getWeatherByLatLonFromOpenWeather(lat: lat, lon: lon) { json, error in
      guard let weatherJSON = json else {
        completion(nil, error)
        return
      }
      
      guard let main = weatherJSON["main"] as? [String: Any] else {
        completion(nil, error)
        return
      }
      
      guard let currentTemperature = main["temp"] as? Double else{
        completion(nil, error)
        return
      }
      
      let currentWeather = Weather(temp: currentTemperature)
      completion(currentWeather, nil)
    }
  }
}

