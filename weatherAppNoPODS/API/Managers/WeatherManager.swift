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
      
      guard let dateTime = weatherJSON["dt"] as? Double else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      guard let details = weatherJSON["weather"] as? [[String: Any]], !details.isEmpty else {
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
      
      guard let minTemperature = main["temp_min"] as? Double else{
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      guard let maxTemperature = main["temp_max"] as? Double else{
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      guard let cityName = weatherJSON["name"] as? String else{
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      let currentWeather = Weather(temperature: currentTemperature, minTemperature: minTemperature, maxTemperature: maxTemperature, dateTime: dateTime, cityName: cityName, description: description)
      
      onSuccess(currentWeather)
      
    }, onFailure: { error in onFailure(WeatherError(error?.localizedDescription ?? "Couldn't get weather data.")) })
  }
  
  func getWeatherForecast(withLatitude latitude: Double, longitude: Double, onSuccess: @escaping([Weather]?) -> Void, onFailure: @escaping(WeatherError?) -> Void) {
    weatherService.getWeatherForecast(withLatitude: latitude, longitude: longitude, onSuccess: { json in
      
      guard let weatherJSON = json else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      guard let city = weatherJSON["city"] as? [String: Any] else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      guard let cityName = city["name"] as? String else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      guard let list = weatherJSON["list"] as? [[String: Any]], !list.isEmpty else  {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      var fiveDayForecastWeathers = [Weather]()

      for i in stride(from: 0, to: list.count, by: 7) {
        
        let weather = list[i]
        
        guard let dateTime = weather["dt"] as? Double else {
          onFailure(WeatherError("Couldn't get weather data."))
          return
        }
        
        if(!self.isDateToday(from: dateTime)) {
          
          guard let details = weather["weather"] as? [[String: Any]], !details.isEmpty else {
            onFailure(WeatherError("Couldn't get weather data."))
            return
          }
          
          guard let description = details[0]["description"] as? String else {
            onFailure(WeatherError("Couldn't get weather data."))
            return
          }
          
          guard let main = weather["main"] as? [String: Any] else {
            onFailure(WeatherError("Couldn't get weather data."))
            return
          }
          
          guard let currentTemperature = main["temp"] as? Double else {
            onFailure(WeatherError("Couldn't get weather data."))
            return
          }
          
          guard let minTemperature = main["temp_min"] as? Double else {
            onFailure(WeatherError("Couldn't get weather data."))
            return
          }
          
          guard let maxTemperature = main["temp_max"] as? Double else {
            onFailure(WeatherError("Couldn't get weather data."))
            return
          }
          
          let currentWeather = Weather(temperature: currentTemperature, minTemperature: minTemperature, maxTemperature: maxTemperature, dateTime: dateTime, cityName: cityName, description: description)
          
          fiveDayForecastWeathers.append(currentWeather)
          
        }
        
      }
      
      onSuccess(fiveDayForecastWeathers)
      
    }, onFailure: { error in  })
  }
  
  func isDateToday(from interval : TimeInterval) -> Bool {
    let calendar = NSCalendar.current
    let date = Date(timeIntervalSince1970: interval)
    if calendar.isDateInToday(date) {
      return true
    }
    return false
  }
  
}

