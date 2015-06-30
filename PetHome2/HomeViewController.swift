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
    
    var mAllPost:NSMutableArray?
    override func viewDidLoad() {
//        设置为自动变化
        self.tableViewOfPost.rowHeight = UITableViewAutomaticDimension
        self.tableViewOfPost.estimatedRowHeight = 210
//        初始化textfield
        self.txtPublisher.delegate = self
        
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
                    self.mAllPost =  Global.shareInstance().getUserRelatedPost()
                    self.tableViewOfPost.dataSource = self
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        self.tableViewOfPost.reloadData()
                    })
                    
                }
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let data = self.mAllPost{
            return data.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell?
        if let itemData = self.mAllPost?.objectAtIndex(indexPath.row){
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
            
            if let commonBtn = cell?.viewWithTag(TAG_POST_COMMENT_TF) as? CommentTextField{
//                commonBtn.enabled = true
                commonBtn.addTarget(self, action: "commentThisPostHandler:", forControlEvents: UIControlEvents.TouchUpInside)
                commonBtn.setExtraData(indexPath.row)
                commonBtn.delegate = self
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
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        return false
    }
    
    func commentThisPostHandler(sender:AnyObject){
        if let btn = sender as? CommentTextField{
            let rowIndex = btn.getExtraData()
            println(rowIndex)
            if (rowIndex >= 0 ){
                btn.becomeFirstResponder()
//                let indexPath = NSIndexPath(index: rowIndex + 1)
//                self.mAllPost?.addObject(["type":"inputComment"])
//
//                self.tableViewOfPost?.insertRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .Bottom)

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
                    self.mAllPost =  Global.shareInstance().getUserRelatedPost()
                    self.tableViewOfPost.dataSource = self
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.tableViewOfPost.reloadData()
                    })
                    
                }
            }}
        )
        
    }
}