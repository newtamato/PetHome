//
//  RegisterViewController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/8/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
class RegisterViewController:UIViewController {
    
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBAction func onRegisterComplete(sender: AnyObject) {
        
        var mailStr:String = self.txtMail.text
        var pwdStr:String = self.txtPwd.text
        var param = ["email":mailStr,"pwd":pwdStr]
        self.txtPwd.secureTextEntry = true
        RequestManager.shareInstance().sendRequest(API_REGISTER, param: param, onComplete: onRegisterComplete)

    }
    
    func onRegisterComplete(response:AnyObject?, error:AnyObject?){
        print(response)
        var userInfo:Dictionary<String,AnyObject> = (response as? Dictionary<String,AnyObject>)!
        print(userInfo["userInfo"])
        print((userInfo["userInfo"] as? Dictionary<String,AnyObject>)!["uid"])


    }
}