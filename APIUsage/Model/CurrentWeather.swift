//
//  CurrentWeather.swift
//  APIUsage
//
//  Created by wtildestar on 19/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    let temperature: Double
    let appearentTemperature: Double
    let humidity: Double
    let pressure: Double
    let icon: UIImage
}

extension CurrentWeather {
    var pressureString: String {
        return "\(Int(pressure)) mm"
    }
    
    var humidityString: String {
        return "\(Int(humidity)) %"
    }
    
    var temperatureString: String {
       return "\(Int(temperature))ºC"
   }
    var appearentTemperatureString: String {
        return "\(Int(appearentTemperature))ºC"
    }
}
