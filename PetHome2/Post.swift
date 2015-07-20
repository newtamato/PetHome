//
//  Post.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/9/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Post {
    var id:String?
    var userId:String = ""
    var goods:Int = 0
    var body:String?
    var players:String?
    var img:[JSON]?

    private var postData:JSON?
    func loadData(data:JSON){
        self.postData = data
        self.id = data["post_id"].string
        self.userId = data["uid"].string!
        self.body = data["text"].string
        self.goods = data["good_num"].intValue
        self.img = data["image_url"].arrayValue
        self.players = "Jolie"
    }
    func goodIt(){
        self.goods += 1
    }
    
    func getFirstImage()->String?{
        return self.postData?["image_url"][0].string
    }
    
}