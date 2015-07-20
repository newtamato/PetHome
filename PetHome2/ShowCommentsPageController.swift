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
class ShowCommentsPageController:UIViewController,UITableViewDelegate,UITableViewDataSource {

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
       
        // 下拉刷新(Pull to LoadMore)
        self.tableView.toRefreshAction({() -> () in
            print("load more actions")
            var page = self.pageIndex - 1
            if (page <= 0 ){
                page = 1
            }
            self.getDataFromServer(page)

        })
        // 上拉刷新(Pull to LoadMore)
        self.tableView.toLoadMoreAction({ () -> () in
            println("toLoadMoreAction success")
            self.getDataFromServer(self.pageIndex + 1)

        })
       
    }
    override func viewDidAppear(animated: Bool) {
        print("view did for comment of post")
        print(self.pageData!)
        self.getDataFromServer(1)
    }
    func getDataFromServer(index:Int){
        let postId = self.pageData!.posId!
        var param = ["post_id":postId,"page":index,"size":6]
        RequestManager.shareInstance().sendRequest(API_POST_COMMENT_LIST, param: param as? Dictionary<String, AnyObject>, onJsonResponseComplete:
            {(response:JSON?,error:AnyObject?) in
                print("get all comments",response)
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
            bodyLable.text = commentItem?["text"].string
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
        print("开始提交")
        self.performSegueWithIdentifier("writeComment", sender: self);
        
    }
    
}
