//
//  URLBuilder.swift
//  ScratchApp
//
//  Created by Sean Goldsborough on 1/3/20.
//  Copyright © 2020 Sean Goldsborough. All rights reserved.
//

import Foundation

extension APIClient {
    
    func soURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.soURL.APIScheme
        components.host = Constants.soURL.APIHost
        components.path = Constants.soURL.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
