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
class  LoginViewController:UIViewController{
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPasswd: UITextField!
    var data:NSObject!
    @IBAction func onConnectWithServer(sender: AnyObject) {

        var request = HTTPTask()
        var param = NSDictionary()
        param = ["mail":txtName.text, "passwd":txtPasswd.text]
        request.GET("http://127.0.0.1:8000/PetsProject/default/login2.json", parameters: param as! Dictionary<String, AnyObject>, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)

                let decodedJson = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                
//                var sb = UIStoryboard(name: "Main", bundle:nil)
//                var vc = sb.instantiateViewControllerWithIdentifier("MainTabView") as! UIViewController
//                self.presentViewController(vc, animated: true, completion: nil);
                println("response: \(str)") //prints the HTML of the page
                Global.shareInstance().setUserInfo(decodedJson )
                self.performSegueWithIdentifier("showMainTabView",sender:self);
            }})
    }
    @IBAction func onClearAllData(sender: AnyObject) {
        txtName.text = ""
        txtPasswd.text = ""
    }
    
   

}