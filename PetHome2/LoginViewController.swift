//
//  LoginViewController.swift
//  PetHome
//
//  Created by 亮亮 侯 on 6/29/15.
//  Copyright © 2015 亮亮 侯. All rights reserved.
//

import Foundation
import SwiftHTTP
import UIKit
import SwiftyJSON
class  LoginViewController:UIViewController{
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPasswd: UITextField!
    var data:NSObject!
    @IBAction func onConnectWithServer(sender: AnyObject) {

        var request = HTTPTask()
        var mail:String = self.txtName.text
        var pwd:String = self.txtPasswd.text
        var jsonParam = ["email":mail,"pwd":pwd]
        

        RequestManager.shareInstance().sendRequest(API_LOGIN, param: jsonParam, onJsonResponseComplete: onLoginComplete)

        
    }
    
    func onLoginComplete(response:JSON?,error:AnyObject?)
    {
        Global.shareInstance().getDataCached().setUserData(response!)
    }
    @IBAction func onClearAllData(sender: AnyObject) {
        txtName.text = ""
        txtPasswd.text = ""
    }
    
   

}