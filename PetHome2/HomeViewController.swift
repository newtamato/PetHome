//
//  HomeViewController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 6/29/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP





class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var txtPublisher: UITextField!
    @IBOutlet weak var tableViewOfPost: UITableView!
    @IBOutlet weak var txtPublishPost: UITextField!
    
    @IBOutlet weak var commentPostBottomCons: NSLayoutConstraint!

    var allPost:NSMutableArray?
    var selectedIndex:Int = 0;
    override func viewDidLoad() {
//        设置为自动变化
        self.tableViewOfPost.rowHeight = UITableViewAutomaticDimension
        self.tableViewOfPost.estimatedRowHeight = 210
        self.tableViewOfPost.allowsSelection = true
//        初始化textfield
        self.txtPublisher.delegate = self
        self.txtPublishPost.delegate = self
        var request = HTTPTask()
        request.GET("\(SERVER_URL)/fetchAllPosts.json", parameters: nil, completionHandler: {(response:HTTPResponse) in
            if let err = response.error{
                return
            }
            if let data = response.responseObject as? NSData{
                let decodedJson:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary

                if let posts = decodedJson
                {
                    Global.shareInstance().setUserRelatedPost(posts["rows"] as! NSArray)
                    self.allPost =  Global.shareInstance().getUserRelatedPost()
                    self.tableViewOfPost.dataSource = self
                    self.tableViewOfPost.delegate = self
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        self.tableViewOfPost.reloadData()
                    })
                    
                }
            }
        })
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
       
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        animateViewMoving(true, moveValue: keyboardFrame.size.height)
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.commentPostBottomCons.constant = keyboardFrame.size.height
        })
        
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        self.tableViewOfPost.contentInset = UIEdgeInsetsMake(self.tableViewOfPost.contentInset.top, 0, 0, 0);
        self.tableViewOfPost.scrollIndicatorInsets = contentInsets
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let data = self.allPost{
            return data.count
        }
        return 0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath")
        self.selectedIndex = indexPath.row
        self.performSegueWithIdentifier("showPostPage", sender: self);
    }
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showPostPage"){
            let localPostData = PostPageValueData()
            if (self.selectedIndex > 0 ){
                var postData = self.allPost?.objectAtIndex(self.selectedIndex)
                localPostData.postBody = postData as! NSDictionary
                localPostData.userName = "123"
                localPostData.userDesc = "hello,world"
                localPostData.userGoods = 10
                localPostData.userImage = "mother"
                
                (segue.destinationViewController as! ShowPostPageController).pageData = localPostData
            }

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell?
        if let itemData = self.allPost?.objectAtIndex(indexPath.row){
            if let imgUrl = itemData["post_img"] as? String{
                if (imgUrl != ""){
                    cell = self.tableViewOfPost.dequeueReusableCellWithIdentifier(complexCell) as! UITableViewCell
                    if let imgView = cell?.viewWithTag(TAG_POST_IMG) as? UIImageView{
                        var imgURL = "\(SERVER_URL)/download/\(imgUrl)"
                        println(imgURL)
                        let url = NSURL(string:imgURL)
                        let data = NSData(contentsOfURL: url!)
                        imgView.image = UIImage(data: data!)
                    }
                }else{
                    cell = self.tableViewOfPost.dequeueReusableCellWithIdentifier(wordCell) as! UITableViewCell
                }
            }else{
                cell = self.tableViewOfPost.dequeueReusableCellWithIdentifier(wordCell) as! UITableViewCell
            }

            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.userInteractionEnabled = true
            
            if let commonBtn = cell?.viewWithTag(TAG_POST_COMMENT_BTN) as? CommentButton{
                commonBtn.userInteractionEnabled = false
//                commonBtn.enabled = false
//                commonBtn.addTarget(self, action: "commentThisPostHandler:", forControlEvents: UIControlEvents.TouchUpInside)
                commonBtn.setExtraData(indexPath.row)
//                commonBtn.delegate = self
            }
            if let avatarImg = cell?.viewWithTag(TAG_POST_AVATAR_IMG) as? UIImageView{
                avatarImg.image = UIImage(named: "mother")
            }
            if let bodyLable = cell?.viewWithTag(TAG_POST_BODY) as? UILabel{
                bodyLable.text = itemData["body"] as? String
            }
            if let nameLabel = cell?.viewWithTag(TAG_POST_PUBLISHER) as? UILabel{
                if let player = itemData["players"] as? Int {
                   
                    nameLabel.text = String(player)
                }
            }
            
        }
        return cell!
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        println("textFieldDidEndEditing")
        self.sendPost(textField)
       
        self.tableViewOfPost.scrollEnabled = false
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField!) {
        self.tableViewOfPost.scrollEnabled = true
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

    func commentThisPostHandler(sender:AnyObject){
        if let btn = sender as? CommentButton{
            let rowIndex = btn.getExtraData()
            println(rowIndex)
            if (rowIndex >= 0 ){
                self.txtPublishPost.becomeFirstResponder()

            }
        }
        
        println("commentThisPostHandler")
    }

    @IBAction func sendPost(sender: AnyObject) {
        let body = (sender as! UITextField).text
        var request = HTTPTask()
        var param = NSDictionary()

        let playerData = Global.shareInstance().getUserProfileData()
        let playerId = playerData["id"] as! Int
        
        param = ["body":body,"playerId":playerId]

        self.txtPublisher.text = ""
        
        request.GET("\(SERVER_URL)/sendPostFromIos.json", parameters: param as! Dictionary<String, AnyObject>, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                return //also notify app of failure as needed
            }
            if let data = response.responseObject as? NSData {
//          
                println(data)
                let decodedJson:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                
                if let posts = decodedJson
                {
                    Global.shareInstance().setUserRelatedPost(posts["rows"] as! NSArray)
                    self.allPost =  Global.shareInstance().getUserRelatedPost()
                    self.tableViewOfPost.dataSource = self
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.tableViewOfPost.reloadData()
                    })
                    
                }
            }}
        )
        
    }
}