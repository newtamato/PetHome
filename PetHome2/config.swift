//
//  config.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 6/30/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import SwiftyJSON
//let SERVER_URL:String = "http://127.0.0.1:8000/PetsProject/default"

typealias APICallback = ((AnyObject?, AnyObject?) -> ())
typealias APIJSONCallback = ((JSON?, AnyObject?) -> ())


//let SERVER_URL:String = "http://pethome/index.php"
let SERVER_URL:String = "http://pethome/index.php"
let API_LOGIN:String = "user.login"
let API_REGISTER:String = "user.register"
let API_FETCH_POST:String = "user.postlist"
let API_PUBLISH_POST:String = "postinfo.publish"
let API_UPLOAD_IMAGE:String = "upload.image"
let API_GOOD_POST:String = "postinfo.good"
let API_USER_FOLLOW:String = "user.follow" //uid
let API_GET_POST_GOODS:String = "postinfo.allgood" //uid
let API_POST_COMMENT:String = "postinfo.comment" //对post评论
let API_POST_COMMENT_LIST:String = "postinfo.commentlist" //获取所有与post有关的评论
let API_ALL_USER_POST:String = "postinfo.all" //获取所有人发的post，以后会改为获取当前用户关注的人发的post
let API_EDIT_USER_INFO:String = "user.edit"
let API_SEARCH_USERL:String = "user.search" //查找用户
let API_GET_RECOMMENT_USER:String="user.random" //获得随机推荐的用户
let RES_SUCCESS:String = "success"
let BasicCellIdentifier = "PureWordContentCell";
let ImageContentCellIdentifier = "ImageWordContentCellController";
let ImageCellIdentifier = "PureImageContentCellController";

let DefaultImg = "mother"

let wordCell = "wordCell";
let imageCell = "imageCell";
let complexCell = "complexCell";
let inputCommentCell = "inputCommentCell"
let SimplePostCell = "SimplePostCell"
let SearchUserResultCell = "SearchUserResultCell"

let postTableViewWordCell = "postWorldCell"
let postTableViewImageCell = "postImageCell"
let commentSimpleItemRender = "commentItemCell"


let TAG_POST_BODY = 1
let TAG_POST_PUBLISHER = 2

let TAG_POST_AVATAR_IMG = 3
let TAG_POST_IMG = 4
let TAG_POST_COMMENT_BTN = 5
let TAG_POST_GOOD_BTN = 6
let TAG_POST_COMMENT_TF = 7
let TAG_POST_FOLLOW_BTN = 8
let TAG_POST_USER_NAME = 9


let NotificationUpDataPostList = "updatePostList"

let STATUS_SUCCESS="success"
