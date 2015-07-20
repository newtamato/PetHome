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
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let desc = Global.shareInstance().getDataCached().getUserData()?.getUserDesc()
        if (desc == nil){
            txtPlayerDesc.text = "这个家伙很懒，什么也没有留下"
        }else{
            txtPlayerDesc.text = desc
        }
        
        let name = Global.shareInstance().getDataCached().getUserData()?.getUserMail()
        txtPlayerName.text = name
        
        txtGoods.text = "10"
        txtThanks.text = "100"

    }
}