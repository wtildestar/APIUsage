//
//  APIManager.swift
//  APIUsage
//
//  Created by wtildestar on 19/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

protocol JSONDecodable {
    // пишем проваливающийся failable инициализатор для fetch<T> который может вернуть nil
    init?(JSON: [String: AnyObject])
}

protocol FinalURLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

// перечисление которое лежит в closure нашего completionHandler
enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    // пишем интерфейс
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
}

extension APIManager {
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: WTSNetworkingErrorDomain, code: 100, userInfo: userInfo)
                
                completionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    // @escaping устанавливается когда мы передаем что-либо в наш closure
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        // вызываем первый метод JSONTaskWith(request:)
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async {
                // проверяем получился json либо же nil
                guard let json = json else {
                    if let error = error {
                        completionHandler(.Failure(error))
                    }
                    return
                }
                // проверяем получилось ли получить опциональный T через parse(json)
                if let value = parse(json) {
                    completionHandler(.Success(value))
                } else {
                    let error = NSError(domain: WTSNetworkingErrorDomain, code: 200, userInfo: nil)
                    completionHandler(.Failure(error))
                }
            }
            
        }
        dataTask.resume()
    }
}
