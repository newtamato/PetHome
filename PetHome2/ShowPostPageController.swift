//
//  ShowPostPageController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/5/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ShowPostPageController:UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var btnGood: UIButton!
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var txtUserDesc: UILabel!
    

   

    var pageData:Post?
    
    override func viewDidLoad() {
        
        super.viewDidLoad();

        self.title = "Post信息"
//        设置自动宽高
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 600
        self.tableView.allowsSelection = true


        if let data = pageData {
            
            self.txtUserName.text = data.userId
            self.txtUserDesc.text = "\(data.userId) 的基本描述"

            self.imgUserPhoto.image = UIImage(named:"mother");

            self.btnGood.setTitle("\(data.goods)个赞",forState: UIControlState.Normal)
            self.tableView.dataSource = self
            self.tableView.delegate = self

            print("reload tableView data")
            self.tableView.reloadData()

        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        print("cell for row at index!!!\(indexPath.row)")
        print(self.pageData?.img)
        var cell:UITableViewCell?
        print(self.pageData?.body)
        if let postBody = self.pageData?.body {
            if let imgs = self.pageData?.img {
                cell = self.tableView.dequeueReusableCellWithIdentifier(postTableViewImageCell) as! PostImageCellController
                if let imgPreview = cell?.viewWithTag(TAG_POST_IMG) as? UIImageView{
                    if (imgs.count > 0 ){
                        var imgPath = imgs[0].string
                        imgPreview.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imgPath!)!)!)
                           (cell as? PostImageCellController)?.heightOfImg.constant = 200
                    }else{
                        (cell as? PostImageCellController)?.heightOfImg.constant = 1
                    }
                }
            }else{
                cell = self.tableView.dequeueReusableCellWithIdentifier(postTableViewWordCell) as! PostWorldCellController
            }
            if let bodyLabel = cell?.viewWithTag(TAG_POST_BODY) as? UILabel{
                bodyLabel.text = postBody
            }
        }
        return cell!
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue\(segue.identifier)asdfasfdasfdasdfassdf", terminator: "")
        if (segue.identifier == "showComments"){
            print(self.pageData)
            let data:CommentPageValueData = CommentPageValueData()
            data.posId = self.pageData?.id
            print(data)
            
            (segue.destinationViewController as? ShowCommentsPageController)?.pageData = data
        }
    }
    
    @IBAction func onGoodThisPostHandler(sender: AnyObject) {

        var param = ["post_id":(self.pageData!.id)!]
        print("onGoodThisPostHandler,\(param)", terminator: "" )
        RequestManager.shareInstance().sendRequest(API_GOOD_POST, param: param, onJsonResponseComplete: onGoodThisPostComplete)
        
    }
    @IBAction func btnCommentHandler(sender: AnyObject) {
        print("btnCommentHandler")
        self.performSegueWithIdentifier("showComments", sender: self)
    }
    
    func onGoodThisPostComplete(responseJson:JSON?,error:AnyObject?){
        print("onGoodThisPostComplete", terminator: "")
        dispatch_async(dispatch_get_main_queue(),{()->Void in
            if let id = self.pageData?.id {
                self.pageData = Global.shareInstance().getDataCached().goodForPost(id)
            }
            self.btnGood.setTitle("\(self.pageData?.goods)个赞",forState: UIControlState.Normal)
        })

    }
}