//
//  BaseRequest.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/7/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import SwiftHTTP
import SwiftyJSON

class BaseRequest {
    private var action:String = ""
    private var param:Dictionary<String,AnyObject>?
    private var onCompleteFunc:APICallback?
    private var onJsonCompleteFunc:APIJSONCallback?
    private var mHttpTask:HTTPTask?

    init(){

    }
    init(action:String){
        self.action = action
    }
    init(action:String,param:Dictionary<String,AnyObject>){
        self.action = action
        self.param = param
    }
    init(action:String,param:Dictionary<String,AnyObject>?,completionHandler:APICallback){
        self.action = action
        self.param = param
        self.onCompleteFunc = completionHandler
        self.onJsonCompleteFunc = nil
    }
    init(action:String,param:Dictionary<String,AnyObject>?,onJsonCompleteHandler:APIJSONCallback){
        self.action = action
        self.param = param
        self.onJsonCompleteFunc = onJsonCompleteHandler
        self.onCompleteFunc = nil
    }
    func sendRequest(action:String,param:Dictionary<String,AnyObject>?,completionHandler:APICallback){
        self.action = action
        self.param = param
        self.onCompleteFunc = completionHandler
        self.onJsonCompleteFunc = nil
    }
    func sendRequest(action:String,param:Dictionary<String,AnyObject>?,onJsonCompleteHandler:APIJSONCallback){
        self.action = action
        self.param = param
        self.onJsonCompleteFunc = onJsonCompleteHandler
        self.onCompleteFunc = nil
    }

    func startRequest(){
        if (self.mHttpTask == nil){
            self.mHttpTask = HTTPTask()
        }
        var param = ["api":self.action]
        if (self.param != nil ){
            var data = NSJSONSerialization.dataWithJSONObject(self.param!, options: NSJSONWritingOptions(0), error: nil)
            let paramStr = NSString(data: data!,
                encoding: NSUTF8StringEncoding)
            let str = paramStr as! String
            param["json"] = str
        }
        
        self.mHttpTask!.GET("\(SERVER_URL)", parameters: param, completionHandler:handlerTheResponse)
    }
  
    func handlerTheResponse(response:HTTPResponse){
        if let err = response.error {
            println("error: \(err.localizedDescription)")
            self.onCompleteFunc!(nil,err)
            return //also notify app of failure as needed
        }
        if let data = response.responseObject as? NSData {
            let str = NSString(data: data, encoding: NSUTF8StringEncoding)
//            let decodedJson = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
//
             //prints the HTML of the page
            if (self.onCompleteFunc != nil){
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                self.onCompleteFunc!(jsonResult,nil)
            }
            if (self.onJsonCompleteFunc != nil){
                let jsonResult = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                println("response: \(jsonResult)")
                self.onJsonCompleteFunc!(jsonResult,nil)
            }

        }
    }


    func uploadImage(nsData:NSData,onComplete:APICallback){
//        let task = HTTPTask()
//        var fileUrl = NSURL(fileURLWithPath: "\(SERVER_URL)")!
        if (self.mHttpTask == nil){
            self.mHttpTask = HTTPTask()
        }
        var upload = HTTPUpload(data:nsData,fileName:"abc.png",mimeType:"application/octet-stream")
        self.mHttpTask!.upload("\(SERVER_URL)", method: .POST, parameters: ["api": "upload.image", "file": upload], progress: { (value: Double) in
            println("progress: \(value)")
        }, completionHandler: { (response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("response: \(str!)") //prints the response
                let decodedJson = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                onComplete(decodedJson,nil)
            }
        })
    }
}