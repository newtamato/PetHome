//
// Created by 亮亮 侯 on 7/26/15.
// Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
class CommonItemRenderController:UITableViewCell {
    private var mData:JSON?
    func setData(data:JSON?){
        self.mData = data
    }
    func getData()->JSON?{
        return self.mData
    }
}
