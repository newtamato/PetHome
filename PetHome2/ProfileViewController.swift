//
//  ProfileViewController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 6/29/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var imgPlayer: UIImageView!
    
    @IBOutlet var txtPlayerName: UILabel!
    
    @IBOutlet var txtPlayerDesc: UILabel!



    @IBOutlet var txtGoods: UILabel!
    @IBOutlet var txtThanks: UILabel!

    @IBOutlet var tableViewOfPost:UITableView!


    @IBOutlet weak var labelFollower: UILabel!
    
    private var mPosts:JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOfPost.rowHeight = UITableViewAutomaticDimension
        self.tableViewOfPost.estimatedRowHeight = 240
        self.tableViewOfPost.allowsSelection = true
        self.tableViewOfPost.dataSource = self
        self.tableViewOfPost.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        let desc = Global.shareInstance().getDataCached().getUserData()?.getUserDesc()
        if (desc == nil){
            txtPlayerDesc.text = "这个家伙很懒，什么也没有留下"
        }else{
            txtPlayerDesc.text = desc
        }
        
        let name = Global.shareInstance().getDataCached().getUserData()?.getUserName()
        txtPlayerName.text = name

        let img = Global.shareInstance().getDataCached().getUserData()?.getUserImg()
        if (img == DefaultImg){
            self.imgPlayer.image = UIImage(named: img!)
        }else{
            let url = NSURL(string:img!)
            let data = NSData(contentsOfURL: url!)
            self.imgPlayer.image = UIImage(data: data!)
        }
        if let num = Global.shareInstance().getDataCached().getUserData()?.getUserFollowerNumber(){
            self.labelFollower.text = "关注人数\(num)"
        }

        txtGoods.text = "10"
        txtThanks.text = "100"
        
        RequestManager.shareInstance().sendRequest(API_FETCH_POST,param: nil,onJsonResponseComplete: {(response:JSON?,error:AnyObject?) in
            self.mPosts = response!["postList"]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableViewOfPost.reloadData()
            })
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let posts = self.mPosts{
            return posts.arrayValue.count
        }
        return 0
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell = (tableView.dequeueReusableCellWithIdentifier(SimplePostCell)! as UITableViewCell)
        if let itemData = self.mPosts?.arrayValue[indexPath.row]{
            if let imgView = cell.viewWithTag(TAG_POST_IMG) as? UIImageView {
                if let imgs = itemData["image_url"].array {
                    var firstImg = imgs[0].stringValue
                    if (firstImg != ""){
                        firstImg = firstImg.stringByReplacingOccurrencesOfString("index.php/", withString: "")
                        let url = NSURL(string: firstImg)
                        imgView.image = UIImage(data: NSData(contentsOfURL: url!)!)
                        
                        
                    }
                    
                }else{
                   imgView.image = nil
                }
            }


            let txt = itemData["text"].string
            if let label = cell.viewWithTag(TAG_POST_BODY) as? UILabel{

                label.text = txt
            }
        }
        return cell
    }
}