//
//  DataCached.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/9/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataCached {
    private var allPosts:NSMutableArray?
    private var allComments:NSMutableDictionary?
    private var follower:NSMutableDictionary?
    private var userData:Player?
    
    func setUserData(data:JSON){
        
        print(data, terminator: "")
        
        self.userData = Player()
        self.userData?.loadData(data)
    }
    func getUserData()->Player?{
        return self.userData
    }

    
    func loadPostData(data:JSON){
       
        if (self.allPosts == nil){
            self.allPosts = NSMutableArray()
        }
        for postItem in data.arrayValue{
            var localPostItem:Post = Post()
            localPostItem.loadData(postItem)
            self.allPosts?.addObject(localPostItem)
        }
    }
    func publishPost(postInfo:JSON){
        if (self.allPosts == nil){
            self.allPosts = NSMutableArray()
        }
        print(postInfo, terminator: "")
        var localPostItem:Post = Post()
        localPostItem.loadData(postInfo)
        self.allPosts?.insertObject(localPostItem, atIndex: 0)
//        self.allPosts?.addObject(localPostItem)
    }
    func loadCommentData(postId:String,data:JSON){
        if let comments = self.allComments?.objectForKey(String(postId)) as? NSMutableArray{
            for commentItem in data {
                var commentData:Comment = Comment()
                commentData.loadData(commentItem as! Dictionary<String, AnyObject>)
                comments.addObject(commentData)
            }
            
        }else{
            var comments:NSMutableArray = NSMutableArray()
            for commentItem in data {
                var commentData:Comment = Comment()
                commentData.loadData(commentItem as! Dictionary<String, AnyObject>)
                comments.addObject(commentData)
            }
            
            self.allComments?.setObject(comments, forKey: postId)
        }
    }
    
    func getHomePosts()->NSMutableArray?{
        return self.allPosts
    }
    
    func getPostDataByPostId(postId:String)->Post?{
        var postData:Post?
        for postItemData in self.allPosts!{
            if ((postItemData as! Post).id == postId){
                postData =  postItemData as? Post
            }
        }
        return postData
    }
    
    func goodForPost(postId:String)->Post{
        let postData = self.getPostDataByPostId(postId)
        postData?.goodIt()
        return postData!
    }
    
    func commentsForPost(postId:String,commentData:Comment){
        let postData = self.getPostDataByPostId(postId)
        let mutiArray:NSMutableArray = NSMutableArray()
        mutiArray.addObject(postData!)
//        self.loadCommentData(postId,data: mutiArray)
    }
    
//    关注某人
    func followWithSomeBody(uid:String?,someUid:String){
        if (self.follower == nil){
            self.follower = NSMutableDictionary()
        }
        var newUid = uid
        if (newUid == nil){
            newUid = String(stringInterpolationSegment: self.userData?.getUserId())
        }
        if ((self.follower?.objectForKey(newUid!)) != nil){
            self.follower?.setValue(NSMutableArray(), forKey: newUid!)
        }
        (self.follower?.objectForKey(newUid!) as? NSMutableArray)?.addObject(someUid);
    }
//    是否关注了某人
    func isFollowWithUid(uid:String?,someUid:String)->Bool{
        var newUid = uid
        if (newUid == nil){
            newUid = String(stringInterpolationSegment: self.userData?.getUserId())
        }
        if let followers = self.follower?.objectForKey(newUid!) as? NSMutableArray{
            let index = followers.indexOfObject(someUid)
            if index > -1 {
                return true
            }
        }
        return false
    }

    
}