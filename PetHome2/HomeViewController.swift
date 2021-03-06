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
import SwiftyJSON





class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
//    @IBOutlet weak var txtPublisher: UITextField!
    @IBOutlet weak var tableViewOfPost: UITableView!
//    @IBOutlet weak var txtPublishPost: UITextField!
    
    @IBOutlet weak var commentPostBottomCons: NSLayoutConstraint!

    @IBOutlet weak var actionSegmented: UISegmentedControl!
    var allPost:NSMutableArray?
    var selectedIndex:Int = 0;
    var selectedPostData:Post?
    var pageIndex:Int = 0
    override func viewDidLoad() {
//        设置为自动变化
        self.tableViewOfPost.rowHeight = UITableViewAutomaticDimension
        self.tableViewOfPost.estimatedRowHeight = 240
        self.tableViewOfPost.allowsSelection = true
        self.tableViewOfPost.dataSource = self
        self.tableViewOfPost.delegate = self


        
        // 下拉刷新(Pull to LoadMore)
        /*
        self.tableViewOfPost.toRefreshAction({() -> () in
            print("load more actions")
            var page = self.pageIndex - 1
            if (page <= 0 ){
                page = 1
            }
            self.getDataFromServer(page)
        })
        // 上拉刷新(Pull to LoadMore)
        self.tableViewOfPost.toLoadMoreAction({ () -> () in
            println("toLoadMoreAction success")
            self.getDataFromServer(self.pageIndex + 1)
        })
        */
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidAppear(animated: Bool) {
        
        self.allPost =  Global.shareInstance().getDataCached().getHomePosts()
        if (self.allPost != nil ){
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableViewOfPost.reloadData()
            })
        }else{
            self.getDataFromServer(1)
        }
        
        print(self.view.frame.size.width)
    }
    func getDataFromServer(pageIndex:Int){
        print("pageIndex is \(pageIndex)")
        RequestManager.shareInstance().sendRequest(API_ALL_USER_POST,param: ["page":pageIndex,"size":10] ,onJsonResponseComplete: onFetchPostComplete)
    }
    
    func onFetchPostComplete(response:JSON?,error:AnyObject?){

        print(response, terminator: "")
        let page = response!["page"].intValue
        if (self.pageIndex == page) {
//            self.tableViewOfPost.doneRefresh()
//            self.tableViewOfPost.endLoadMoreData()
//            self.tableViewOfPost.doneRefresh()
            return
        }
        if let size = response?["size"] {
            if (size  == 0 ){
//                self.tableViewOfPost.endLoadMoreData()
//                self.tableViewOfPost.doneRefresh()
                return
            }
        }
        self.pageIndex = page
        if let posts:JSON = response?["postList"]
        {
            Global.shareInstance().getDataCached().loadPostData(posts)
            self.allPost =  Global.shareInstance().getDataCached().getHomePosts()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableViewOfPost.reloadData()
//                self.tableViewOfPost.doneRefresh()
            })
        }
    }

    
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let data = self.allPost{
            return data.count
        }
        return 0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath")
        self.selectedIndex = indexPath.row
        self.performSegueWithIdentifier("showPostPage", sender: self);
    }
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showPostPage"){
            let localPostData = PostPageValueData()
            if (self.selectedIndex >= 0 ){
                let postData:Post = self.allPost?.objectAtIndex(self.selectedIndex) as! Post
                
                (segue.destinationViewController as! ShowPostPageController).pageData = postData
            }

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell?
        if let itemData = self.allPost?.objectAtIndex(indexPath.row) as? Post{
            var firstImg = itemData.getFirstImage()
            if (firstImg != nil && firstImg != "" ) {
                cell = self.tableViewOfPost.dequeueReusableCellWithIdentifier(complexCell)! as UITableViewCell
                if let imgView = cell?.viewWithTag(TAG_POST_IMG) as? UIImageView{
                    do{
                        firstImg = firstImg?.stringByReplacingOccurrencesOfString("index.php/", withString: "")
                        let url = NSURL(string: firstImg!)!
                        
                        print("图片的地址\(url)")
                        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL:url), queue: NSOperationQueue.mainQueue(), completionHandler: { (response:NSURLResponse?, imageData:NSData?, error:NSError?) -> Void in
                            if let data = imageData {
                                imgView.image = UIImage(data: data)
                            }
                            
                        })
                        
                    }catch let error{
                        print("cell 上面展示图片\(error)")
                    }
                
                }
            }else{
                cell = self.tableViewOfPost.dequeueReusableCellWithIdentifier(wordCell)! as UITableViewCell
            }

            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.userInteractionEnabled = true
            
            if let commonBtn = cell?.viewWithTag(TAG_POST_GOOD_BTN) as? CommentButton{
                commonBtn.userInteractionEnabled = false
                commonBtn.setExtraData(indexPath.row)
                commonBtn.addTarget(self, action: "onGoodPostHandler:", forControlEvents: UIControlEvents.TouchUpInside)
                commonBtn.userInteractionEnabled = true
            }
            if let commonBtn = cell?.viewWithTag(TAG_POST_COMMENT_BTN) as? CommentButton{
                commonBtn.userInteractionEnabled = false
                commonBtn.setExtraData(indexPath.row)
            }
            if let commonBtn = cell?.viewWithTag(TAG_POST_FOLLOW_BTN) as? CommentButton{
                let isFollowed = Global.shareInstance().getDataCached().isFollowWithUid(nil, someUid: itemData.userId)
                if (isFollowed == false){
                    commonBtn.userInteractionEnabled = true
                    commonBtn.setExtraData(indexPath.row)
                    commonBtn.addTarget(self, action: "onFollowPosterHandler:", forControlEvents: UIControlEvents.TouchUpInside)
                }else{
                    commonBtn.setTitle("已关注", forState: UIControlState.Normal)
                }
                
            }
            
            if let avatarImg = cell?.viewWithTag(TAG_POST_AVATAR_IMG) as? UIImageView{
                avatarImg.image = UIImage(named: "mother")
            }
            if let bodyLable = cell?.viewWithTag(TAG_POST_BODY) as? UILabel{
                if itemData.body != nil && itemData.body == "内容：" {
                        bodyLable.text = "there is nothing!"
                }else{
                     bodyLable.text =  itemData.body
                }
                
            }
            if let nameLabel = cell?.viewWithTag(TAG_POST_USER_NAME) as? UILabel{
                 nameLabel.text = itemData.players
            }
            
        }
        return cell!
    }
 
  
    
   
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

    func onFollowPosterHandler(sender:AnyObject){
//        API_USER_FOLLOW
        if let btn = sender as? CommentButton{
            let rowIndex = btn.getExtraData()
            self.selectedIndex = rowIndex
            self.selectedPostData = self.allPost?.objectAtIndex(rowIndex) as? Post
            
            var param = ["uid":self.selectedPostData!.userId]
            print("\(param)", terminator: "")
            RequestManager.shareInstance().sendRequest(API_USER_FOLLOW, param: param, onJsonResponseComplete: onFollowPosterComplete)
        }
    }
    func onFollowPosterComplete(response:JSON?,error:AnyObject?){
        if (response?["retMsg"].stringValue == RES_SUCCESS){
            Global.shareInstance().getDataCached().followWithSomeBody(nil, someUid: self.selectedPostData!.userId)
            
            self.tableViewOfPost.reloadRowsAtIndexPaths([NSIndexPath(index: self.selectedIndex)], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    func onGoodPostHandler(sender:AnyObject){
        if let btn = sender as? CommentButton{
            let rowIndex = btn.getExtraData()
            var postData = self.allPost?.objectAtIndex(rowIndex) as? Post
            var param = ["post_id":postData!.id!]
            RequestManager.shareInstance().sendRequest(API_GOOD_POST, param: param, onJsonResponseComplete: onGoodPostCompleteHandler)

        }
    }
        func onGoodPostCompleteHandler(response:JSON?,error:AnyObject?){
            print("onGoodPostCompleteHandler\(response)", terminator: "")
        }
    func commentThisPostHandler(sender:AnyObject){
        if let btn = sender as? CommentButton{
            let rowIndex = btn.getExtraData()
            print(rowIndex)
            if (rowIndex >= 0 ){
            }
        }
        
        print("commentThisPostHandler")
    }
        
    @IBAction func sendPost(sender: AnyObject) {
        let body = (sender as! UITextField).text!
        let param = ["text":body]
        let request:BaseRequest = BaseRequest(action: API_PUBLISH_POST, param: param)
        request.startRequest()
    }
    
    func onUpdatePostList(sender:AnyObject){
        print("upate post list right now!", terminator: "")
        self.onFetchPostComplete(nil,error: nil)
    }
    @IBAction func onSelectedTheActionHandler(sender: AnyObject) {
        if(self.actionSegmented.selectedSegmentIndex == 0)
        {

        }
        else if(self.actionSegmented.selectedSegmentIndex == 1)
        {

        }
    }
}