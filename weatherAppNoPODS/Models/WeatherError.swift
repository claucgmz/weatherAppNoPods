//
//  WeatherError.swift
//  weatherAppNoPODS
//
//  Created by Caludia Carrillo on 12/20/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

struct WeatherError: Error {
  var errorMessage: String
  
  init(_ errorDescription: String){
    self.errorMessage = errorDescription
  }
}
