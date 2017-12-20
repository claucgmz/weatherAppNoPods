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
  private func getWeatherUrl(withLatitude latitude: Double, longitude: Double) -> URL? {
    if let url = URL(string: "\(apiManager.baseURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiManager.key)") {
      return url
    }
    return nil
  }
  
  /* Go fetch data */
  func getWeather(withLatitude latitude: Double, longitude: Double, onSuccess: @escaping (JSONDictionary?) -> Void, onFailure: @escaping (Error?) -> Void) {

    guard let weatherURL = getWeatherUrl(withLatitude: latitude, longitude: longitude) else {
      onFailure(WeatherError("Couldn't get weather url."))
      return
    }
    
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
  
  func jsonTask(request: URLRequest, onSuccess: @escaping (JSONDictionary?) -> Void, onFailure: @escaping (Error?) -> Void) -> URLSessionDataTask {
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: request) { (data, response, error) in
      
      guard let data = data else{
        onFailure(nil)
        return
      }
      
      do{
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        onSuccess(json)
      }
      catch{
        onFailure(nil)
      }
    }
    
    return task
  }
  
}
