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
    
    func setUserInfo(data:NSDictionary){
        self.mUserData = data
        println("用户的数据如下")
        println(data)
    }
    func getUserProfileData()->NSDictionary{
        return self.mUserData!
    }
  
    
    func setUserRelatedPost(data:NSArray){
        println(data)
        println("排序之前")

        let data2:NSArray = data.sortedArrayUsingComparator(
        {
            (s1:AnyObject!,s2:AnyObject!)->NSComparisonResult in
            let s1Time = s1["time_stmp"] as! String
            let s2Time = s2["time_stmp"] as! String
            println("s1 time is \(s1Time), s2 time is \(s2Time)")
            if s1Time < s2Time {
                println("升序")
                return NSComparisonResult.OrderedDescending
            }else{
                return NSComparisonResult.OrderedAscending
            }
        })
        self.mAllPosts = data2.mutableCopy() as! NSMutableArray
        println("排序之后")
        println(data)
//        self.mAllPosts = data
    }
    
    func getUserRelatedPost()->NSMutableArray{
        return self.mAllPosts!
    }
    
    
}