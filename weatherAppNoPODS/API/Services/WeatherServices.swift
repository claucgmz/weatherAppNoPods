//
//  WeatherServices.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

class WeatherServices{
  
  let apiManager = APIManager.sharedInstance
  let weatherManager = WeatherManager()
  
  
  /* Go fetch data */
  func getAPIData(url : URL, onSuccess: @escaping(Weather) -> Void, onFailure: @escaping(Error) -> Void){
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print(error)
        onFailure(error)
      } else {
        
        let metaData = self.parseToJSON(data: data!)
        self.weatherManager.getWeatherManager(weather : metaData, updateWeather : onSuccess)
      }
    }
    task.resume()
    
  }
  
  /* Parse JSON*/
  func parseToJSON(data: Data) ->JSONDictionary{
    do {
      guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
        print("error trying to convert data to JSON")
        return ["error" : "Trying to convert data to JSON"]
      }

      guard let main = json["main"] else {
        print("Could not get todo main from from JSON")
        return ["error" : "Could not get todo main from from JSON"]
      }
      
      guard let currentTemperature = main["temp"] as? Double else{
        print("Could not get temperature from from JSON")
        return ["error" : "Could not get temperature from from JSON"]
      }
      
      return ["temperature" : currentTemperature]
      
    } catch let error as NSError {
      print("Failed to load: \(error.localizedDescription)")
      return ["error" : "Failed to load: \(error.localizedDescription)"]
    }
    
  }
  
}
