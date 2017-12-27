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
  
  let weatherManager = WeatherManager()
  var currentLatitude = 0.0
  var currentLongitude = 0.0
  
  var weathers = [Weather]()

  override func viewDidLoad() {
    super.viewDidLoad()
    weatherForecastTableView.delegate = self
    weatherForecastTableView.dataSource = self
    
    loadingLabel.text = "Getting 5 day forecast..."
    weatherForecastTableView.isHidden = true
    loadingLabel.isHidden = false
    
    getWeatherForecast(withLatitude: currentLatitude, longitude: currentLongitude)
  }
  
  func getWeatherForecast(withLatitude latitude: Double, longitude: Double) {
    weatherManager.getWeatherForecast(withLatitude: latitude, longitude: longitude, onSuccess: { fiveDayWeatherForecast in
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
  
  //MARK: - View & Labels Update Methods
  /***************************************************************/
  func updateLoadingTextLabel(text: String) {
    loadingLabel.text = text
    weatherForecastTableView.isHidden = true
    loadingLabel.isHidden = false
  }
  
  
  @IBAction func back(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: - TableView DataSource Methods
/***************************************************************/
extension WeatherForecastViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weathers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
    let weather = weathers[indexPath.row]
    
    if let weatherCell = cell as? WeatherTableViewCell {
      weatherCell.maxTemperatureLabel.text = "\(weather.maxTemperature.convertTemperatureToCelsius())°"
      weatherCell.minTemperatureLabel.text = "\(weather.minTemperature.convertTemperatureToCelsius())°"
      weatherCell.dateLabel.text = getFormattedDate(dateTime: weather.dateTime)
      weatherCell.dayLabel.text = getDayOfWeek(dateTime: weather.dateTime)
    }
    
    return cell
  }
}

//MARK: - TableView Delegate Methods
/***************************************************************/
extension WeatherForecastViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 68.0
  }
}
