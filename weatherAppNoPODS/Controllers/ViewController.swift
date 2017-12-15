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
  var currentWeather : Weather?
  
  @IBOutlet weak var weatherLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initLocationManager()
  }
  
  func loadData(parameters : [String : String]){
    APIManager.sharedInstance.getWeather(parameters : parameters, onSuccess : showWeatherData, onFailure: showWeatherDataErrors)
  }
  
  func showWeatherData(weather : Weather){
    currentWeather = weather
    DispatchQueue.main.async {
      let temperature = self.currentWeather?.temperature
      self.weatherLabel.text = "\(temperature ?? "0" ) °C"
    }
    
    print(weather)
  }
  
  func showWeatherDataErrors(error : Error){
    print(error)
    weatherLabel.text = error.localizedDescription
  }
  
  @IBAction func getWeatherButton(_ sender: Any) {
    locationManager.startUpdatingLocation()
  }
}

extension ViewController: CLLocationManagerDelegate {
  
  func initLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
  }
  
  //MARK: - Location Manager Delegate Methods
  /***************************************************************/
  
  //didUpdateLocations method
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[locations.count-1]
    
    if location.horizontalAccuracy>0 {
      locationManager.stopUpdatingLocation()
    }
    
    let lat = String(location.coordinate.latitude)
    let lon = String(location.coordinate.longitude)
    
    let params : [String : String] = ["lat" : lat, "lon" : lon ]
    loadData(parameters : params)
  }
  
  //didFailWithError method
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    weatherLabel.text = "We couldn't get your location"
  }
  
}
