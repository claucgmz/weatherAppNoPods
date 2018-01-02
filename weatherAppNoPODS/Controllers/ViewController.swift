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
  var currentLocation: Location?
  
  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var mainWeatherView: UIStackView!
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
  
  func getWeather(withLocation location: Location) {
    weatherManager.getWeather(withLocation: location, onSuccess: { weather in
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
  
  override public var traitCollection: UITraitCollection {
    if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
      return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)])
    }
    return super.traitCollection
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
    
    guard let segueIdentifier = segue.identifier else {
      return
    }
    
    if segueIdentifier == "weatherForecastSegue" {
      let DestViewController = segue.destination as! UINavigationController
      let targetController = DestViewController.topViewController as! WeatherForecastViewController
      targetController.currentLocation = currentLocation
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
    currentLocation = Location(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
    
    guard let location = currentLocation else {
      updateLoadingTextLabel(text: "Couldn't get current location")
      return
    }
    
    getWeather(withLocation: location)
  }
  
  //didFailWithError method
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    updateLoadingTextLabel(text: "We couldn't get your location")
  }
  
}
