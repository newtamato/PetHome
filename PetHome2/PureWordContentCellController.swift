//
//  PureWordContentCellController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 6/30/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
class PureWordContentCellController: UITableViewCell {
    
    @IBOutlet  var txtDate: UILabel!
    @IBOutlet  var txtBodyContent: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}