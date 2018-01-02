//
//  WeatherServices.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

class WeatherService {

  private let apiManager = APIManager.sharedInstance
  
  /* Form getWeatherURL */
  private func getWeatherUrl(withLocation location: Location, endpoint: Endpoint) -> URL? {
    if let url = URL(string: "\(apiManager.baseURL)/\(endpoint.rawValue)?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiManager.key)") {
      return url
    }
    return nil
  }
  
  func getWeather(withLocation location: Location, onSuccess: @escaping JSONSuccessHandler, onFailure: @escaping ErrorHandler) {
    guard let weatherURL = getWeatherUrl(withLocation: location, endpoint: .Weather) else {
      onFailure(WeatherError("Couldn't get weather url."))
      return
    }
    
    requestWeatherData(weatherURL: weatherURL, onSuccess: onSuccess, onFailure: onFailure)
  }
  
  func getWeatherForecast(withLocation location: Location, onSuccess: @escaping JSONSuccessHandler, onFailure: @escaping ErrorHandler) {
    guard let weatherURL = getWeatherUrl(withLocation: location, endpoint: .Forecast) else {
      onFailure(WeatherError("Couldn't get weather forecast url."))
      return
    }
    
    requestWeatherData(weatherURL: weatherURL, onSuccess: onSuccess, onFailure: onFailure)
  }
  
  func requestWeatherData(weatherURL: URL, onSuccess: @escaping JSONSuccessHandler, onFailure: @escaping ErrorHandler) {
    let request = URLRequest(url: weatherURL)
    let task = jsonTask(request: request, onSuccess: { json in
      guard let currentWeatherJSON = json else {
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      onSuccess(currentWeatherJSON)
    }, onFailure: { error in onFailure(error) })

    task.resume()
  }
  
  func jsonTask(request: URLRequest, onSuccess: @escaping JSONSuccessHandler, onFailure: @escaping ErrorHandler) -> URLSessionDataTask {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: request) { (data, response, error) in
      
      guard let data = data else{
        onFailure(WeatherError("Couldn't get weather data."))
        return
      }
      
      do{
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        onSuccess(json)
      }
      catch{
        onFailure(WeatherError("Couldn't get weather data."))
      }
    }
    
    return task
  }
}
