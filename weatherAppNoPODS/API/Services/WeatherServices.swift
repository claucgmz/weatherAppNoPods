//
//  WeatherServices.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

class WeatherServices {
  
  let apiManager = APIManager.sharedInstance
  
  /* Form getWeatherURL */
  func getWeatherByLatLonURL(lat: Double, lon: Double) -> URL {
    return URL(string :"\(apiManager.baseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(apiManager.key)")!
  }
  
  /* Go fetch data */
  func getWeatherByLatLonFromOpenWeather(lat: Double, lon: Double, completion: @escaping (JSONDictionary?, Error?) -> Void) {

    let weatherURL = getWeatherByLatLonURL(lat: lat, lon: lon)
    let request = URLRequest(url: weatherURL)
    let task = jsonTask(request: request) { json, error in
        DispatchQueue.main.async {
          guard let currentWeatherJSON = json else {
            completion(nil, error)
            return
          }
          
          completion(currentWeatherJSON, nil)
      }
    }
    
    task.resume()
  }
  
  func jsonTask(request: URLRequest, completion: @escaping (JSONDictionary?, Error?) -> Void) -> URLSessionDataTask {
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: request) { (data, response, error) in
      
      guard let data = data else{
        completion(nil, error)
        return
      }
      
      do{
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        completion(json, nil)
      }
      catch{
        completion(nil, error)
      }
    }
    
    return task
  }
  
}
