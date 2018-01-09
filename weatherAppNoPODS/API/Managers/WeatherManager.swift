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
      
      do {
        let currentWeather = try Weather(withJSON: weatherJSON)
        onSuccess(currentWeather)
      } catch {
        onFailure(WeatherError("Couldn't get weather data."))
      }

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
      /**
        Loop to filter the list that returns daily weather every 3 hours, requirements were one weather per day, grab the first weather of the day.
       **/
      for i in stride(from: 0, to: list.count, by: 7) {
        let weather = list[i]
        
        guard let dateTime = weather["dt"] as? Double else {
          onFailure(WeatherError("Couldn't get weather data."))
          return
        }
        
        let date = Date(timeIntervalSince1970: dateTime)
        
        if(!date.isToday) {
          let forecastWeather = try? Weather(withJSON: weather, cityName: cityName, countryName: countryName, dateTime: date)
          guard let currentWeather = forecastWeather else {
            return
          }
          
          fiveDayForecastWeathers.append(currentWeather)
        }
      }
      
      onSuccess(fiveDayForecastWeathers)
      
    }, onFailure: { error in  onFailure(WeatherError(error?.localizedDescription ?? "Couldn't get weather data."))})
  }
}

