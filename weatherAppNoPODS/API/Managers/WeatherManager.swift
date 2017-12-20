//
//  WeatherManager.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

class WeatherManager {
  
  let weatherService = WeatherService()
  
  func getWeather(withLatitude latitude: Double, longitude: Double, onSuccess: @escaping(Weather?) -> Void, onFailure: @escaping(WeatherError?) -> Void) {
    
    weatherService.getWeather(withLatitude: latitude, longitude: longitude, onSuccess: { json in
      
      guard let weatherJSON = json else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      guard let details = weatherJSON["weather"] as? [[String: Any]], !details.isEmpty else{
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      guard let description = details[0]["description"] as? String else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      guard let main = weatherJSON["main"] as? [String: Any] else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      guard let currentTemperature = main["temp"] as? Double else{
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      let currentWeather = Weather(temperature: currentTemperature, description: description)
      onSuccess(currentWeather)
      
    }, onFailure: { error in onFailure(WeatherError(error?.localizedDescription ?? "Couldn't get weather data.")) })
  }
}

