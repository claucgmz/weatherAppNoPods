//
//  ViewController.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
  
  let locationManager = CLLocationManager()
  let weatherManager = WeatherManager()
  
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var minTemperatureLabel: UILabel!
  @IBOutlet weak var maxTemperatureLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initLocationManager()
  }
  
  func getWeather(withLatitude latitude: Double, longitude: Double){
    weatherManager.getWeather(withLatitude: latitude, longitude: longitude, onSuccess: { weather in
      DispatchQueue.main.async {
        guard let currentWeather = weather else {
          self.updateWeatherTextLabel(text: "Couldn't get current weather.")
          return
        }
        
        self.updateCurrentWeatherData(weather: currentWeather)
      }
    }, onFailure: { error in
        DispatchQueue.main.async {
          guard let error = error else {
            self.updateWeatherTextLabel(text: "Couldn't not get current weather.")
            return
        }
          self.updateWeatherTextLabel(text: error.errorMessage)
      }
    })
  }
  
  func updateCurrentWeatherData(weather : Weather) {
    let temperature = weather.convertTemperatureToCelsius()
    updateWeatherTextLabel(text: "\(temperature) °")
    descriptionLabel.text = weather.description
  }
  
  func updateWeatherTextLabel(text: String) {
     currentTemperatureLabel.text = text
  }
  
  @IBAction func getWeatherButton(_ sender: Any) {
    updateWeatherTextLabel(text: "Updating...")
    descriptionLabel.text = ""
    locationManager.startUpdatingLocation()
  }
}

//MARK: - Extend for Initial Setup
/***************************************************************/
extension ViewController {
  func initLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
  }
}

extension ViewController: CLLocationManagerDelegate {
  
  //MARK: - Location Manager Delegate Methods
  /***************************************************************/
  
  //didUpdateLocations method
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    guard let lastLocation = locations.last else {
      updateWeatherTextLabel(text: "Couldn't get location")
      return
    }
    
    guard lastLocation.horizontalAccuracy>0 else {
      updateWeatherTextLabel(text: "Couldn't get accurate location")
      return
    }
    
    locationManager.stopUpdatingLocation()
    
    let currentLatitude = lastLocation.coordinate.latitude
    let currentLongitude = lastLocation.coordinate.longitude
    getWeather(withLatitude: currentLatitude, longitude: currentLongitude)
  }
  
  //didFailWithError method
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    updateWeatherTextLabel(text: "We couldn't get your location")
  }
  
}
