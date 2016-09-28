//
//  PostListTableViewController.swift
//  Post
//
//  Created by Wesley Austin on 9/25/16.
//  Copyright © 2016 Wesley Austin. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {

    var postController = PostController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postController.delegate = self
        
        
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postController.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCells", forIndexPath: indexPath) as! PostTableViewCell

        let post = postController.posts[indexPath.row]
        cell.postTextLabel.text = post.text
        let df = NSDateFormatter()
        df.dateStyle = .MediumStyle
        df.timeStyle = .ShortStyle
        
        cell.postTimestampLabel.text = df.stringFromDate(NSDate(timeIntervalSince1970: post.timestamp))
        
        return cell
    }
 
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row+1 == postController.posts.count {
            
            postController.fetchPosts(false, completion: { (newPosts) in
                
                if !newPosts.isEmpty {
                    
                    self.tableView.reloadData()
                }
            })
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - PostController Delegate 
    
    func postsUpdated(posts: [Post]) {
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        postController.fetchPosts { (posts) in
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                refreshControl.endRefreshing()
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Actions 
    
    @IBAction func addPostButtonTapped(sender: UIBarButtonItem) {
        presentNewPostAlert()
    }
    
    // MARK: - Helper function
    func presentNewPostAlert() {
        let addNotif = UIAlertController(title: "Add Post", message: nil, preferredStyle: .Alert)
        
        addNotif.addTextFieldWithConfigurationHandler { (textField) in
            textField.attributedPlaceholder = NSAttributedString(string: "username")
        }
    
        addNotif.addTextFieldWithConfigurationHandler { (textField) in
            textField.attributedPlaceholder = NSAttributedString(string: "message")
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let postAction = UIAlertAction(title: "Post", style: .Default) { (_) in
            let usernameTextField = addNotif.textFields![0]
            let messageTextField = addNotif.textFields![1]
            
            if usernameTextField.text != "" && messageTextField.text != "" {
                let username = usernameTextField.text!
                let message = messageTextField.text!
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                self.postController.addPost(username, text: message)
            } else {
                    self.presentErrorAlert()
                    return
            }
            
            
        }
        
        addNotif.addAction(cancelAction)
        addNotif.addAction(postAction)
        
        self.presentViewController(addNotif, animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let errorNotif = UIAlertController(title: "Missing either username or message", message: nil, preferredStyle: .Alert)
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .Default) { (_) in
                self.presentNewPostAlert()
        }
        
        errorNotif.addAction(tryAgainAction)
        
        self.presentViewController(errorNotif, animated: true, completion: nil)
    }
}
