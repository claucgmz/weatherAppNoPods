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
  
  @IBOutlet weak var weatherLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initLocationManager()
  }
  
  func getWeatherByLatLon(lat: Double, lon: Double){
    weatherManager.getWeatherByLatLon(lat: lat, lon: lon) { weather, error in
      DispatchQueue.main.async {
        guard let currentWeather = weather else {
          self.updateWeatherTextLabel(text: error?.localizedDescription ?? "Could not get current weather.")
          return
        }
        
        self.updateCurrentWeatherData(weather: currentWeather)
      }
    }
  }
  
  func updateCurrentWeatherData(weather : Weather) {
    let temperature = weather.convertTemperatureToCelsius()
    updateWeatherTextLabel(text: "\(temperature) °C")
  }
  
  func updateWeatherTextLabel(text: String) {
     weatherLabel.text = text
  }
  
  @IBAction func getWeatherButton(_ sender: Any) {
    updateWeatherTextLabel(text: "Updating...") 
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
    
    let currentLat = lastLocation.coordinate.latitude
    let currentLon = lastLocation.coordinate.longitude
    getWeatherByLatLon(lat: currentLat, lon: currentLon)
  }
  
  //didFailWithError method
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    updateWeatherTextLabel(text: "We couldn't get your location")
  }
  
}
