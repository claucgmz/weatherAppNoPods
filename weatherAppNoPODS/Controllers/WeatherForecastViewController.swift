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
  let weatherManager = WeatherManager()
  var currentLatitude = 0.0
  var currentLongitude = 0.0
  
  var weathers = [Weather]()

  override func viewDidLoad() {
    super.viewDidLoad()
    weatherForecastTableView.delegate = self
    weatherForecastTableView.dataSource = self
    getWeatherForecast(withLatitude: currentLatitude, longitude: currentLongitude)
  }
  
  func getWeatherForecast(withLatitude latitude: Double, longitude: Double) {
    weatherManager.getWeatherForecast(withLatitude: latitude, longitude: longitude, onSuccess: { fiveDayWeatherForecast in
      
      DispatchQueue.main.async {
        guard let fiveDayWeatherForecast = fiveDayWeatherForecast else {
          
          return
        }
        
        self.weathers = fiveDayWeatherForecast
        self.weatherForecastTableView.reloadData()
        
      }
    }, onFailure: { error in
     
    })
  }

}

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
      //weatherCell.dayLabel.text = getFormattedDate(dateTime: weather.dateTime)
      weatherCell.dayLabel.text = getDayOfWeek(dateTime: weather.dateTime)
      
    }
    
    return cell
  }

}

extension WeatherForecastViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return 68.0
  }
}
