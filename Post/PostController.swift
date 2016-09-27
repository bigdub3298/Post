//
//  PostController.swift
//  Post
//
//  Created by Wesley Austin on 9/25/16.
//  Copyright © 2016 Wesley Austin. All rights reserved.
//

import Foundation

class PostController {
    static let baseURL = NSURL(string: "https://post-d680c.firebaseio.com/")!
    static let endpoint = PostController.baseURL.URLByAppendingPathComponent("Posts").URLByAppendingPathExtension("json")
    
    var delegate: PostControllerDelegate?
    var initialContactWithServer = true
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts(completion: ((posts: [Post]) -> Void)? = nil) {
        
        NetworkController.performRequestForURL(PostController.endpoint, httpMethod: .get) { (data, error) in
            guard let data = data,
                let postDictionary = NetworkController.jsonFromData(data) else {
                    if self.initialContactWithServer {
                        self.initialContactWithServer = false
                        completion?(posts: [])
                        return
                    } else {
                        print("Error serializing data")
                        completion?(posts: [])
                        return
                    }
            }
            
            let posts = postDictionary.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            
            let sortedPosts = posts.sort({ $0.0.timestamp > $0.1.timestamp})
            
            dispatch_async(dispatch_get_main_queue(), {
                self.posts = sortedPosts
                completion?(posts: sortedPosts)
                return
            })
        }
    }
    
    func addPost(username: String, text: String, completion: ((success: Bool) -> Void)?) {
        let newPost = Post(username: username, text: text)
        
        NetworkController.performRequestForURL(PostController.endpoint, httpMethod: .post, body: newPost.jsonData) { (data, error) in
            if let _ = error {
                completion?(success: false)
            } else {
                completion?(success: true)
            }
        }
    }

}


protocol PostControllerDelegate {
    func postsUpdated(posts: [Post])
}