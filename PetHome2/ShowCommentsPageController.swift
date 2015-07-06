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
//
class ShowCommentsPageController:UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var pageData:CommentPageValueData?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.navigationItem.rightBarButtonItem?.title = "写评论"
        var request = HTTPTask()
        var id:Int = 4 //self.pageData!.posId!
        println("view did load")
        if let comments = Global.shareInstance().getCommentsWith(id){
            self.pageData?.comments = comments
            self.tableView.reloadData()
        }else{
            request.GET("\(SERVER_URL)/getComments.json", parameters: ["postId":id ], completionHandler: {
                
                (response:HTTPResponse) in

                    if let err = response.error{
                        return
                    }

                    if let data = response.responseObject as? NSData{
                        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println(str)
                        
                        let decodedJson:NSDictionary = (NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary)!
                        println(decodedJson)
                        var comments:NSMutableArray = (decodedJson.objectForKey("comments") as? NSMutableArray)!

                        Global.shareInstance().setCommentsData(String(id), comments:comments.mutableCopy() as! NSMutableArray)
                        
                        if let comments = Global.shareInstance().getCommentsWith(self.pageData!.posId!){
                            self.pageData?.comments = comments
                        }
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                           self.tableView.reloadData()
                        })
                        
                    }
                }
            )
        }
    }
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear")
        if let comments = Global.shareInstance().getCommentsWith(4){
            self.pageData?.comments = comments
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let comments = self.pageData?.comments{
            return comments.count
        }
        return Int(0)
    }
    
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:CommentItemRenderController = (tableView.dequeueReusableCellWithIdentifier(commentSimpleItemRender) as? CommentItemRenderController)!
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if let bodyLable = cell.viewWithTag(TAG_POST_BODY) as? UILabel{
            var commentItem = self.pageData?.comments?.objectAtIndex(indexPath.row) as? NSDictionary
            bodyLable.text = commentItem?["body"] as? String
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
