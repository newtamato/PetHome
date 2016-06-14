//
//  RegisterViewController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/8/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class RegisterViewController:UIViewController {
    
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMan: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBAction func onRegisterComplete(sender: AnyObject) {
        
        let mailStr:String = self.txtMail.text!
        let pwdStr:String = self.txtPwd.text!
        let param = ["email":mailStr,"pwd":pwdStr]
        self.txtPwd.secureTextEntry = true
        RequestManager.shareInstance().sendRequest(API_REGISTER, param: param, onJsonResponseComplete: onRegisterComplete)

    }
    
    func onRegisterComplete(response:JSON?, error:AnyObject?){
        print(response, terminator: "")
        print(response);
        
//        print((userInfo["userInfo"] as? Dictionary<String,AnyObject>)!["uid"], terminator: "")


    }
}