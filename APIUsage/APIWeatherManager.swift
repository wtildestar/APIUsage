//
//  APIWeatherManager.swift
//  APIUsage
//
//  Created by wtildestar on 20/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum ForecastType: FinalURLPoint {
    case Current(apiKey: String, coordinates: Coordinates)
    var baseURL: URL {
        return URL(string: "https://api.darksky.net")! // https://api.darksky.net/
    }
    var path: String {
        switch self {
        case .Current(let apiKey, let coordinates):
            return "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)"
        }
    }
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}

final class APIWeatherManager: APIManager {
    
    let sessionConfiguration: URLSessionConfiguration
    // сессия будет создаваться только когда будем к ней обращаться
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    let apiKey: String
    
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    // метод позволяющий вернуть текущую погоду, функция работает в фоновом потоке
    func fetchCurrentWeatherWith(coordinates: Coordinates, completionHandler: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates).request // .request пишем чтобы переопределить там request: ForecastType на request: URLRequest
        
        // вызываем fetch<T> который реализовывали в расширении
        fetch(request: request, parse: { (json) -> CurrentWeather? in
            // получаем словарь
            if let dictionary = json["currently"] as? [String: AnyObject] {
                return CurrentWeather(JSON: dictionary)
            } else {
                return nil
            }
        }, completionHandler: completionHandler)
    }
    
}
