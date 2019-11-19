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

enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    // пишем интерфейс
    func JSONTaskWith(request: URLRequest, completionHandler: JSONCompletionHandler) -> JSONTask
    func fetch<T>(request: URLRequest, parse: ([String: AnyObject]) -> T?, completionHandler: (APIResult<T>) -> Void)
    
    // можно указать не .default сессию а свою
    init(sessionConfiguration: URLSessionConfiguration)
}
