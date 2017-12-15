//
//  APIManager.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]

class APIManager {
  
  static let sharedInstance = APIManager()
  
  let baseURL = "http://api.openweathermap.org/data/2.5"
  let key = "0d616c2ea47e334eec902903eca13e40"
  
  /* getWeather */
  func getWeather(parameters : JSONDictionary, onSuccess: @escaping(Weather) -> Void, onFailure: @escaping(Error) -> Void){
    let weatherServices = WeatherServices()
    let weatherURL = getWeatherURL(parameters : parameters)
    
    weatherServices.getAPIData(url: weatherURL, onSuccess : onSuccess, onFailure : onFailure)

  }
  
  /* Form getWeatherURL */
  func getWeatherURL(parameters : JSONDictionary) -> URL {
    let lat = parameters["lat"]
    let lon = parameters["lon"]
    
    return URL(string :"\(APIManager.sharedInstance.baseURL)/weather?lat=\(lat ?? "")&lon=\(lon ?? "")&appid=\(APIManager.sharedInstance.key)")!
  }
  
}
