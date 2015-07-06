//
//  ShowPostPageController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/5/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
class ShowPostPageController:UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var btnGood: UIButton!
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var txtUserDesc: UILabel!
    

    var pageData:PostPageValueData?
    
    override func viewDidLoad() {
        
        super.viewDidLoad();

        self.title = "Post信息"
//        设置自动宽高
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 600
        self.tableView.allowsSelection = true


        if let data = pageData {
            
            self.txtUserName.text = data.userName
            self.txtUserDesc.text = data.userDesc
            if (data.userImage != "mother"){
                self.imgUserPhoto.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: data.userImage)!)!)
            }else{
                self.imgUserPhoto.image = UIImage(named: data.userImage);
            }

            self.btnGood.setTitle("\(data.userGoods)个赞",forState: UIControlState.Normal)
            self.tableView.dataSource = self
            self.tableView.delegate = self

            println("reload tableView data")
            self.tableView.reloadData()

        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        println("cell for row at index!!!\(indexPath.row)")
        var cell:UITableViewCell?
        println(self.pageData?.postBody)
        if let postBody = self.pageData?.postBody {
            if ((postBody["post_img"] as? String) != "") {
                cell = self.tableView.dequeueReusableCellWithIdentifier(postTableViewImageCell) as! PostImageCellController
                if let imgPreview = cell?.viewWithTag(TAG_POST_IMG) as? UIImageView{
                    var imgPath:String = postBody["post_img"] as! String
                    var imgURL:String = "\(SERVER_URL)/download/\(imgPath)"
                    println(imgURL)
                    imgPreview.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imgURL)!)!)
                }
            }else{
                cell = self.tableView.dequeueReusableCellWithIdentifier(postTableViewWordCell) as! PostWorldCellController
            }
            if let bodyLabel = cell?.viewWithTag(TAG_POST_BODY) as? UILabel{
                if let postBody = self.pageData?.postBody{
                    bodyLabel.text = postBody["body"] as? String
                }
            }
        }
        return cell!
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepareForSegue\(segue.identifier)asdfasfdasfdasdfassdf")
        if (segue.identifier == "showComments"){
            println(self.pageData)
            var data:CommentPageValueData = CommentPageValueData()
            data.posId = 4 //self.pageData?.posId
//            data.comments = self.pageData?.comments
            println(data)
            
            (segue.destinationViewController as? ShowCommentsPageController)?.pageData = data
        }
    }

    @IBAction func btnCommentHandler(sender: AnyObject) {
        println("btnCommentHandler")
        self.performSegueWithIdentifier("showComments", sender: self)
    }
}