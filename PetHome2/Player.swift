//
//  Player.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/9/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import SwiftyJSON
class Player {
   
    private var mData:JSON?

    
    func loadData(data:JSON){
        self.mData = data["userInfo"]
        print("load user data")
        print(self.mData)
    }
    func getUserId()->Int{
        var id = self.mData?["uid"].intValue
        return id!
    }
    func getUserName()->String?{
        return self.mData?["nick"].string
    }
    func getUserMail()->String{
        if let mail = self.mData?["email"].string{
            return mail
        }
        return "none"
    }
    func getUserImg()->String?{
        return self.mData?["avatar_url"].string
    }
    func getUserDesc()->String?{
        return self.mData?["text"].string
    }

    

}