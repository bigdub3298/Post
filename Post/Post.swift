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

struct Post {
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let identifier: NSUUID
    
    init(username: String, text: String, timestamp: NSTimeInterval = NSDate().timeIntervalSince1970, identifier: NSUUID = NSUUID()) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    init?(dictionary: [String: AnyObject], identifier: String) {
        guard let username = dictionary[kUsername] as? String,
            let text = dictionary[kText] as? String,
            let timestamp = dictionary[kTimestamp] as? Double,
            let identifier = NSUUID(UUIDString: identifier) else { return nil }
        
        self.init(username: username, text: text, timestamp: NSTimeInterval(floatLiteral: timestamp), identifier: identifier)
    }
}