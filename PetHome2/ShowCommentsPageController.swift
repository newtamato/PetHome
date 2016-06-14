//
//  ShowCommentsPageController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/5/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftHTTP
import SwiftyJSON
//
class ShowCommentsPageController:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var bottomOfTxtComment: NSLayoutConstraint!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var pageData:CommentPageValueData?
    var commentList:JSON?
    var pageIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.rightBarButtonItem?.title = "写评论"
        self.txtComment.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onUpdatePostList:",name:NotificationUpDataPostList,object:nil)
        
        // 下拉刷新(Pull to LoadMore)
//        self.tableView.toRefreshAction({() -> () in
//            print("load more actions")
//            var page = self.pageIndex - 1
//            if (page <= 0 ){
//                page = 1
//            }
//            self.getDataFromServer(page)
//
//        })
//        // 上拉刷新(Pull to LoadMore)
//        self.tableView.toLoadMoreAction({ () -> () in
//            println("toLoadMoreAction success")
//            self.getDataFromServer(self.pageIndex + 1)
//
//        })
       
    }
    override func viewDidAppear(animated: Bool) {
        print("view did for comment of post", terminator: "")
        print(self.pageData!, terminator: "")
        self.getDataFromServer(1)
    }
    func getDataFromServer(index:Int){
        let postId = self.pageData!.posId!
        var param = ["post_id":postId,"page":index,"size":6]
        RequestManager.shareInstance().sendRequest(API_POST_COMMENT_LIST, param: param as? Dictionary<String, AnyObject>, onJsonResponseComplete:
            {(response:JSON?,error:AnyObject?) in
                print("get all comments",response, terminator: "")
                if let size = response?["size"] {
                    if (size == 0){
                        self.tableView.doneRefresh()
                        self.tableView.endLoadMoreData()
                        return
                    }
                }
                self.pageIndex = response!["page"].intValue
                self.commentList = response!["comment_list"]
                dispatch_async(dispatch_get_main_queue(),{()->Void in
                    self.tableView.reloadData()
                    self.tableView.doneRefresh()
            })
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let comments = self.commentList?.arrayValue{
            return comments.count
        }
        return Int(0)
    }
    
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:CommentItemRenderController = (tableView.dequeueReusableCellWithIdentifier(commentSimpleItemRender) as? CommentItemRenderController)!
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if let bodyLable = cell.viewWithTag(TAG_POST_BODY) as? UILabel{
//            var commentItem = self.pageData?.comments?.objectAtIndex(indexPath.row) as? NSDictionary
            var commentItem = self.commentList?.arrayValue[indexPath.row]
            bodyLable.text = commentItem?["comment_text"].string
        }
        if let userImg = cell.viewWithTag(TAG_POST_AVATAR_IMG) as? UIImageView{
            userImg.image = UIImage(named: "mother")
        }
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let writeCtrl = segue.destinationViewController as? WriteCommentController {
            writeCtrl.posId = (self.pageData?.posId)!
        }
    }
    @IBAction func btnWriteHandler(sender: AnyObject) {
        print("开始提交", terminator: "")
        self.performSegueWithIdentifier("writeComment", sender: self);
        
    }
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        print("keyboardFrame.size.height is \(keyboardFrame.size.height)")
        var keyY = keyboardFrame.origin.y;
//        UIView.animateWithDuration(0.1, animations: { () -> Void in
//            println("asdfasdfasdfasdfasdfasdfasdf234qwererqwer")
////            self.bottomOfTxtComment.constant = keyboardFrame.size.height
//            var PScreenH = UIScreen.mainScreen().bounds.size.height
//            self.view.transform = CGAffineTransformMakeTranslation(0, keyY - PScreenH);
//        })
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect = CGRectMake(0.0, -keyboardFrame.size.height,width,height);
        self.view.frame = rect
    }
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    // UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
