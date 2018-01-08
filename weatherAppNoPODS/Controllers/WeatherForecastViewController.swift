//
//  WeatherForecastViewController.swift
//  weatherAppNoPODS
//
//  Created by Caludia Carrillo on 12/26/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import UIKit

class WeatherForecastViewController: UIViewController {
  @IBOutlet weak var weatherForecastTableView: UITableView!
  @IBOutlet weak var loadingLabel: UILabel!
  
  let tealBlue = UIColor(red: 90/255, green: 200/255, blue: 1.0, alpha: 0.6)
  let blue = UIColor(red: 0, green: 122/255, blue: 1.0, alpha: 0.6)
  let weatherManager = WeatherManager()
  var currentLocation: Location?
  
  var weathers = [Weather]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    weatherForecastTableView.delegate = self
    weatherForecastTableView.dataSource = self
    registerNibs()
    
    guard let location = currentLocation else {
      updateLoadingTextLabel(text: "Couldn't get current location")
      return
    }
    
    getWeatherForecast(withLocation: location)
  }
  
  func getWeatherForecast(withLocation location: Location) {
    loadingLabel.text = "Getting 5 day forecast..."
    weatherForecastTableView.isHidden = true
    loadingLabel.isHidden = false
    
    weatherManager.getWeatherForecast(withLocation: location, onSuccess: { fiveDayWeatherForecast in
      DispatchQueue.main.async {
        guard let fiveDayWeatherForecast = fiveDayWeatherForecast else {
          self.updateLoadingTextLabel(text: "Couldn't get forecast weather data.")
          return
        }
        
        self.weathers = fiveDayWeatherForecast
        self.loadingLabel.isHidden = true
        self.weatherForecastTableView.isHidden = false
        self.weatherForecastTableView.reloadData()
      }
    }, onFailure: { error in
      guard let error = error else {
        self.updateLoadingTextLabel(text: "Couldn't get forecast weather data.")
        return
      }
      self.updateLoadingTextLabel(text: error.errorMessage)
    })
  }
  
  func updateLoadingTextLabel(text: String) {
    loadingLabel.text = text
    weatherForecastTableView.isHidden = true
    loadingLabel.isHidden = false
  }
}

//MARK: - Initial Setup
/***************************************************************/
extension WeatherForecastViewController {
  func registerNibs() {
    weatherForecastTableView.register(UINib(nibName: "WeatherForecastCell", bundle: nil), forCellReuseIdentifier: "WeatherForecastCell")
    weatherForecastTableView.register(UINib(nibName: "WeatherForecastHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "WeatherForecastHeaderCell")
  }
}

//MARK: - TableView DataSource Methods
/***************************************************************/
extension WeatherForecastViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weathers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastCell") as? WeatherForecastCell
    let weather = weathers[indexPath.row]
    
    if let weatherCell = cell {
      weatherCell.configure(withWeather: weather, color: indexPath.row % 2 == 0 ? tealBlue : blue)
      return weatherCell
    }
   
    return cell!
  }
}

//MARK: - TableView Delegate Methods
/***************************************************************/
extension WeatherForecastViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 68.0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeatherForecastHeaderCell")
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 44
  }
}
