//
//  CommentTextField.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 6/30/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
class CommentTextField: UITextField {
    var mIndex:Int?
    func setExtraData(index:Int){
        self.mIndex = index
    }
    
    func getExtraData()->Int{
        return self.mIndex!
    }
}