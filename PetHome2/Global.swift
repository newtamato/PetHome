//
//  Global.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 6/29/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
class Global{
    
    var mUserData:NSDictionary?;
    var mAllPosts:NSMutableArray?;

    var mSelectedPostIndex:Int?
    var mComments:NSMutableDictionary?
    var mDataCached:DataCached?
    class func shareInstance()->Global{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:Global? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = Global()
            }
        )
        return Singleton.instance!
    }
    
    func getDataCached()->DataCached{
        if (self.mDataCached == nil){
            self.mDataCached = DataCached()
        }
        return self.mDataCached!
    }
    
    func setUserInfo(data:NSDictionary){
        self.mUserData = data
        print("用户的数据如下")
        print(data)
    }
    func getUserProfileData()->NSDictionary{
        return self.mUserData!
    }
  
    
    func setUserRelatedPost(data:NSArray){
        print(data)
        print("排序之前")

        let data2:NSArray = data.sortedArrayUsingComparator(
        {
            (s1:AnyObject!,s2:AnyObject!)->NSComparisonResult in
            let s1Time = s1["update_datetime"] as! String
            let s2Time = s2["update_datetime"] as! String
            print("s1 time is \(s1Time), s2 time is \(s2Time)")
            if s1Time < s2Time {
                print("升序")
                return NSComparisonResult.OrderedDescending
            }else{
                return NSComparisonResult.OrderedAscending
            }
        })
        self.mAllPosts = data2.mutableCopy() as! NSMutableArray
        print("排序之后")
        print(data)
//        self.mAllPosts = data
    }
    
    func getUserRelatedPost()->NSMutableArray?{
        return self.mAllPosts
    }
    
    func setCurrentSelectedPostIndex(index:Int){
        self.mSelectedPostIndex = index
    }
    func getCurrentSelectedPostData()->NSDictionary{

        return (self.mAllPosts?.objectAtIndex(self.mSelectedPostIndex!) as? NSDictionary)!

    }
    func setCommentsData(posId:String,comments:NSMutableArray){
        if (self.mComments == nil){
            self.mComments = NSMutableDictionary()
        }
        if let commentsData = self.mComments?.objectForKey(posId) as? NSMutableArray {
            commentsData.addObjectsFromArray(comments as [AnyObject])
        }else{
            self.mComments?.setValue(comments, forKey: posId)
        }
        print(self.mComments)
    }
    func getCommentsWith(posId:Int) ->NSMutableArray? {
        let posId = String(posId)
        return (self.mComments?.objectForKey(posId) as? NSMutableArray)
    }
    func sendComment(posId:String,commentBody:String){
        print("send comment posId is \(posId) and body is \(commentBody)")
        let playerId:Int = (self.mUserData?.valueForKey("id") as? Int)!
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)

        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        formatter.timeZone = NSTimeZone(abbreviation: "UTC");
        let defaultTimeZoneStr = formatter.stringFromDate(NSDate());
    
        
        let comment:Dictionary<String, AnyObject> = ["players":playerId,"body":commentBody,"time_stmp":defaultTimeZoneStr,"posts":posId]
        
        if let comments = self.mComments?.objectForKey(posId) as? NSMutableArray {
            comments.addObject(comment)
        }else{
            self.mComments?.setValue(NSMutableArray(), forKey: posId)
        }
        print("after adding one comment, they are:")
        print(self.mComments)
    }
    func getPosDataWithId(id:String)->NSDictionary? {
        if let allPost = self.mAllPosts {
            for item in allPost {
                if ((item["id"] as? String) == id){
                    return (item as? NSDictionary)!
                }
            }
        }
        return nil
    }
    
}