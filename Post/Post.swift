//
//  Post.swift
//  Post
//
//  Created by Wesley Austin on 9/25/16.
//  Copyright © 2016 Wesley Austin. All rights reserved.
//

import Foundation

private let kUsername = "username"
private let kText = "text"
private let kTimestamp = "timestamp"
private let kID = "identifier"



struct Post {
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: String?
    
    init(username: String, text: String, timestamp: NSTimeInterval = NSDate().timeIntervalSince1970, identifier: String? = nil) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    init?(dictionary: [String: AnyObject], identifier: String?) {
        guard let username = dictionary[kUsername] as? String,
            let text = dictionary[kText] as? String,
            let timestamp = dictionary[kTimestamp] as? Double,
            let identifier = identifier else { return nil }
        
        self.init(username: username, text: text, timestamp: NSTimeInterval(floatLiteral: timestamp), identifier: identifier)
    }
    
    var jsonFormat: [String: AnyObject] {
        var json = [String: AnyObject]()
        json[kUsername] = username
        json[kText] = text
        json[kTimestamp] = timestamp
        json[kID] = identifier
        
        return json
    }
    
    var jsonData: NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(self.jsonFormat, options: .PrettyPrinted)

    }
    
    var queryTimestamp: NSTimeInterval {
        return timestamp - 0.000001
    }
}