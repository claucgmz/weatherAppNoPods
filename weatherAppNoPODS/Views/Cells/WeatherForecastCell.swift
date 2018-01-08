//
//  WeatherForecastCell.swift
//  weatherAppNoPODS
//
//  Created by Caludia Carrillo on 1/8/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class WeatherForecastCell: UITableViewCell {
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var maxTemperatureLabel: UILabel!
  @IBOutlet weak var minTemperatureLabel: UILabel!
  
  func configure(withWeather weather: Weather, color: UIColor) {
    self.maxTemperatureLabel.text = "\(weather.maxTemperatureInCelsius)°"
    self.minTemperatureLabel.text = "\(weather.maxTemperatureInCelsius)°"
    self.dateLabel.text = weather.dateTime.dateString(withFormat: "MMMM, dd YYYY")
    self.dayLabel.text = weather.dateTime.dayOfWeek
    self.backgroundColor = color
  }
}
