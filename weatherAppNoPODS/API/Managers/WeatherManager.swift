//
//  WeatherManager.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

typealias WeatherSuccessHandler = (Weather?) -> Void
typealias WeatherArraySuccessHandler = ([Weather]?) -> Void
typealias WeatherErrorHandler = (WeatherError?) -> Void

class WeatherManager {
  
  let weatherService = WeatherService()

  func getWeather(withLocation location: Location, onSuccess: @escaping WeatherSuccessHandler, onFailure: @escaping WeatherErrorHandler) {
    
    weatherService.getWeather(withLocation: location, onSuccess: { json in
      
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
      
      guard let country = weatherJSON["sys"] as? [String: Any] else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      guard let countryName = country["country"] as? String else{
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      let currentWeather = Weather(temperature: currentTemperature, minTemperature: minTemperature, maxTemperature: maxTemperature, dateTime: dateTime, cityName: cityName, countryName: countryName, description: description)
      
      onSuccess(currentWeather)
      
    }, onFailure: { error in onFailure(WeatherError(error?.localizedDescription ?? "Couldn't get weather data.")) })
  }
  
  func getWeatherForecast(withLocation location: Location, onSuccess: @escaping WeatherArraySuccessHandler, onFailure: @escaping WeatherErrorHandler) {
    
    weatherService.getWeatherForecast(withLocation: location, onSuccess: { json in
      
      var fiveDayForecastWeathers = [Weather]()
      
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
      
      guard let countryName = city["country"] as? String else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      guard let list = weatherJSON["list"] as? [[String: Any]], !list.isEmpty else  {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }

      for i in stride(from: 0, to: list.count, by: 7) {
        let weather = list[i]

        guard let dateTime = weather["dt"] as? Double else {
          onFailure(WeatherError("Couldn't get weather data."))
          return
        }
        
        if(!isDateToday(from: dateTime)) {
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
          
          let currentWeather = Weather(temperature: currentTemperature, minTemperature: minTemperature, maxTemperature: maxTemperature, dateTime: dateTime, cityName: cityName, countryName: countryName, description: description)
          fiveDayForecastWeathers.append(currentWeather)
        }
      }
      
      onSuccess(fiveDayForecastWeathers)
      
    }, onFailure: { error in  onFailure(WeatherError(error?.localizedDescription ?? "Couldn't get weather data."))})
  }
}

