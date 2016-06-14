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
    
    @IBOutlet weak var lableWarning: UILabel!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPasswd: UITextField!
    var data:NSObject!
    @IBAction func onConnectWithServer(sender: AnyObject) {

//        var request = HTTPTask()
        var mail:String = self.txtName.text!
        var pwd:String = self.txtPasswd.text!
        var jsonParam = ["email":mail,"pwd":pwd]
        

        RequestManager.shareInstance().sendRequest(API_LOGIN, param: jsonParam, onJsonResponseComplete: onLoginComplete)

        
    }
    
    func onLoginComplete(response:JSON?,error:AnyObject?)
    {
        print("login successful")
        print(response!)
        
        let retMsg = response!["retMsg"].stringValue as? String
        let success = "success"
        if  retMsg != success  {
            print(retMsg);
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lableWarning.text = "login failed"
            })

        }else{
            Global.shareInstance().getDataCached().setUserData(response!)
             dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("showMainPage", sender: self.btnLogin)
            })
            
        }
        
    }
    @IBAction func onClearAllData(sender: AnyObject) {
        txtName.text = ""
        txtPasswd.text = ""
    }
    
   


}