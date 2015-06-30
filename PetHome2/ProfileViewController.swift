//
//  ProfileViewController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 6/29/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
class ProfileViewController:UIViewController{
    
    @IBOutlet var imgPlayer: UIImageView!
    
    @IBOutlet var txtPlayerName: UILabel!
    
    @IBOutlet var txtPlayerDesc: UILabel!


    @IBOutlet var txtGoods: UILabel!
    @IBOutlet var txtThanks: UILabel!
    
    override func viewDidLoad() {
        let data = Global.shareInstance().getUserProfileData()

        
        let desc = data["desc"] as! String
        txtPlayerDesc.text = desc
        
        let name = data["name"] as! String
        txtPlayerName.text = name
        
        let goods = String(stringInterpolationSegment: (data["user_goods"] as! Int))
        txtGoods.text = goods
        let thanks = String(stringInterpolationSegment: (data["user_thanks"] as! Int))
        txtThanks.text = thanks
//        let img = data["user_img"] as! String
//        let url = NSURL(string: img)
//        URL=
//        let imgData = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
//        imgPlayer.image = UIImage(data: imgData!)
        
        
        
    }
}