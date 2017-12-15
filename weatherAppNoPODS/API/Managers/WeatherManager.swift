//
//  WeatherManager.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

class WeatherManager {
  
  func getWeatherManager(weather : JSONDictionary, updateWeather: @escaping(Weather) -> Void) {
    var setWeather : Weather = Weather(temperature: "", description: "")
    setWeather.temperature = setTemperatureToCelsius(temperature: (weather["temperature"] as? Double)!)
    setWeather.description = "\(weather["description"] ?? "")"
    print("weather setteado")
    print(setWeather)
    updateWeather(setWeather)
  }
  
  func setTemperatureToCelsius(temperature : Double) -> String{
    return String(temperature-273.15)
  }
}

