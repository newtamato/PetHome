//
//  CommentButton.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 6/30/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
class CommentButton:UIButton {
    var mExtraData:Int?
    
    func setExtraData(data:Int){
        self.mExtraData = data
    }
    func getExtraData()->Int{
        return self.mExtraData!
    }
    
}
