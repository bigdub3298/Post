//
//  NetworkController.swift
//  Post
//
//  Created by Wesley Austin on 9/25/16.
//  Copyright © 2016 Wesley Austin. All rights reserved.
//

import Foundation


class NetworkController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    static func performRequestForURL(baseURL: NSURL, httpMethod: HTTPMethod, urlParameters: [String: String]? = nil, body: NSData? = nil, completion: ((data: NSData?, error: NSError?) -> Void)?) {
        
        let completeURL = urlFromURLParameters(baseURL, urlParameters: urlParameters)
        
        let request = NSMutableURLRequest(URL: completeURL)
        request.HTTPMethod = httpMethod.rawValue
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            completion?(data: data, error: error)
        }
        
        task.resume()
    }
    
    static func jsonFromData(data: NSData) -> [String: [String: AnyObject]]? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: [String: AnyObject]]
            return json
        } catch {
            return nil
        }
    }
    
    static func urlFromURLParameters(url: NSURL, urlParameters: [String: String]?) -> NSURL {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        components?.queryItems = urlParameters?.flatMap({NSURLQueryItem(name: $0.0, value: $0.1)})
        
        if let url = components?.URL {
            return url
        } else {
            fatalError("URL optional is nil")
        }
    }
}