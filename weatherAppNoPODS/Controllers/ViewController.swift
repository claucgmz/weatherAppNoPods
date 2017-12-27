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
  var currentLatitude: Double = 0.0
  var currentLongitude: Double = 0.0
  
  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var mainWeatherView: UIView!
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var minTemperatureLabel: UILabel!
  @IBOutlet weak var maxTemperatureLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initLocationManager()
    getWeatherUpdate()
  }
  
  //MARK: - Get weather Methods
  /***************************************************************/
  func getWeatherUpdate() {
    mainWeatherView.isHidden = true
    loadingLabel.isHidden = false
    locationManager.startUpdatingLocation()
  }
  
  func getWeather(withLatitude latitude: Double, longitude: Double) {
    weatherManager.getWeather(withLatitude: latitude, longitude: longitude, onSuccess: { weather in
      DispatchQueue.main.async {
        guard let currentWeather = weather else {
          self.updateLoadingTextLabel(text: "Couldn't get current weather.")
          return
        }
        self.updateCurrentWeatherData(weather: currentWeather)
      }
    }, onFailure: { error in
      DispatchQueue.main.async {
        guard let error = error else {
          self.updateLoadingTextLabel(text: "Couldn't not get current weather.")
          return
        }
        self.updateLoadingTextLabel(text: error.errorMessage)
      }
    })
  }
  
  //MARK: - View & Labels Update Methods
  /***************************************************************/
  func updateCurrentWeatherData(weather : Weather) {
    currentTemperatureLabel.text = "\(weather.temperature.convertTemperatureToCelsius())°"
    minTemperatureLabel.text = "\(weather.minTemperature.convertTemperatureToCelsius())°"
    maxTemperatureLabel.text = "\(weather.maxTemperature.convertTemperatureToCelsius())°"
    descriptionLabel.text = weather.description
    cityNameLabel.text = "\(weather.cityName), \(weather.countryName)"
    loadingLabel.isHidden = true
    mainWeatherView.isHidden = false
  }
  
  func updateLoadingTextLabel(text: String) {
    loadingLabel.text = text
    mainWeatherView.isHidden = true
    loadingLabel.isHidden = false
  }
}

//MARK: - Extend for Initial Setup & Segues
/***************************************************************/
extension ViewController {
  func initLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "weatherForecastSegue" {
      let DestViewController = segue.destination as! UINavigationController
      let targetController = DestViewController.topViewController as! WeatherForecastViewController
      targetController.currentLatitude = currentLatitude
      targetController.currentLongitude = currentLongitude
    }
  }
}

//MARK: - Location Manager Delegate Methods
/***************************************************************/
extension ViewController: CLLocationManagerDelegate {
  //didUpdateLocations method
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    guard let lastLocation = locations.last else {
      updateLoadingTextLabel(text: "Couldn't get location")
      return
    }
    
    guard lastLocation.horizontalAccuracy>0 else {
      updateLoadingTextLabel(text: "Couldn't get accurate location")
      return
    }
    
    locationManager.stopUpdatingLocation()
    
    currentLatitude = lastLocation.coordinate.latitude
    currentLongitude = lastLocation.coordinate.longitude
    
    getWeather(withLatitude: currentLatitude, longitude: currentLongitude)
  }
  
  //didFailWithError method
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    updateLoadingTextLabel(text: "We couldn't get your location")
  }
  
}
