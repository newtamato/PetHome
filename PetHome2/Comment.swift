//
//  Comment.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/9/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
class Comment {
    var id:String?
    func loadData(data:Dictionary<String,AnyObject>){
        self.id = data["id"] as? String
    }
}