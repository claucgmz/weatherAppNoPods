//
//  APIManager.swift
//  weatherApp_noPODS
//
//  Created by Caludia Carrillo on 12/13/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]
typealias JSONSuccessHandler = (JSONDictionary?) -> Void
typealias ErrorHandler = (Error?) -> Void

class APIManager {
  static let sharedInstance = APIManager()
  let baseURL = "http://api.openweathermap.org/data/2.5"
  let key = "0d616c2ea47e334eec902903eca13e40"
}
