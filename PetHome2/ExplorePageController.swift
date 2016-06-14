//
// Created by 亮亮 侯 on 7/19/15.
// Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ExplorePageController:UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    private var mSearchResultArray:[JSON]?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    override func viewDidLoad() {
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchBar.delegate = self
//        self.searchBar.setScopeBarButtonTitleTextAttributes(<#attributes: [NSObject : AnyObject]?#>, forState: <#UIControlState#>)
        
        super.viewDidLoad()
        
        RequestManager.shareInstance().sendRequest(API_GET_RECOMMENT_USER, param: nil, onJsonResponseComplete: {(response:JSON?,error:AnyObject?) in
            print(response)
            var userData = response?["userInfo"]
            self.mSearchResultArray = [JSON]()
            self.mSearchResultArray?.append(userData!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchTableView.reloadData()
            })

        })
    }
    func searchBarTextDidEndEditing(){
        var txt:String = self.searchBar.text!
        RequestManager.shareInstance().sendRequest(API_SEARCH_USERL,param:["nick":txt],onJsonResponseComplete: {(response:JSON?,error:AnyObject?)in
            self.mSearchResultArray = response?["userList"].arrayValue

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.searchTableView.reloadData()
            })
        })
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool{
        print("searchBarShouldBeginEditing")
        return true
    }
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool{
        print("searchBarShouldEndEditing")
        return true
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        print("searchBarSearchButtonClicked")
        self.searchBarTextDidEndEditing()
        self.searchBar.resignFirstResponder()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let array = self.mSearchResultArray {
            return array.count
        }
        return 0
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:CommonItemRenderController = (tableView.dequeueReusableCellWithIdentifier(SearchUserResultCell) as? CommonItemRenderController)!
        print(self.mSearchResultArray)
        var cellData:JSON? = self.mSearchResultArray?[indexPath.row]

        if let avatarImg = cell.viewWithTag(TAG_POST_AVATAR_IMG) as? UIImageView{
            if let avatarurl = cellData?["avatar_url"].string{
                if (avatarurl != ""){
                    var url = NSURL(string: avatarurl)
                    var nsData = NSData(contentsOfURL: url!)
                    var imgData = UIImage(data: nsData!)
                    avatarImg.image = imgData
                }else{
                    avatarImg.image = UIImage(named: "mother")
                }
            }else{
                avatarImg.image = UIImage(named: "mother")
            }
        }
        if let avatarNameLabel = cell.viewWithTag(TAG_POST_USER_NAME) as? UILabel{
            avatarNameLabel.text = cellData?["nick"].string
        }
        if let followBtn = cell.viewWithTag(TAG_POST_FOLLOW_BTN) as? CommonButton{
            if let isFollow = cellData?["isFollow"].boolValue{
                print("瑟吉欧放屁关注\(isFollow)")
                if (isFollow){
                    print("已关注")
                    followBtn.setTitle("已关注", forState: UIControlState.Normal)
                }else{
                    followBtn.setTitle("关注", forState: UIControlState.Normal)

                    followBtn.addTarget(self, action: "onFollowUser:", forControlEvents: UIControlEvents.TouchUpInside)
                    followBtn.setData(cellData)
                    followBtn.setIndex(indexPath.row)
                }
            }else{
                followBtn.setTitle("关注", forState: UIControlState.Normal)
                followBtn.addTarget(self, action: "onFollowUser:", forControlEvents: UIControlEvents.TouchUpInside)
                followBtn.setData(cellData)
                followBtn.setIndex(indexPath.row)
            }
        }
        return cell
    }
    
    func onFollowUser(sender:AnyObject){
        print("onFollowUser")
        if let index = (sender as? CommonButton)?.getIndex(){
            var data:JSON? = self.mSearchResultArray?[index]
            if let uid = data?["uid"].intValue {
                RequestManager.shareInstance().sendRequest(API_USER_FOLLOW, param: ["uid":uid], onJsonResponseComplete:{(response:JSON?,error:AnyObject?) in
                    if (response?["retMsg"].string == STATUS_SUCCESS || response?["retMsg"].string == "already follow"){
                        data?["isFollow"] = true
                        self.mSearchResultArray?[index] = data!
                        var indexPath = NSIndexPath(forRow: index, inSection: 0)
                        dispatch_async(dispatch_get_main_queue(), { () ->Void in
                            self.searchTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                        })
                      
                        
                    }
                })
            }
        }

    }
}
