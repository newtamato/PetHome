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
        
        var param = ["api":self.action]
        if (self.param != nil ){
            var data = try? NSJSONSerialization.dataWithJSONObject(self.param!, options: NSJSONWritingOptions(rawValue: 0))
            let paramStr = NSString(data: data!,
                encoding: NSUTF8StringEncoding)
            let str = paramStr as! String
            param["json"] = str
        }
        
//        handlerTheResponse
        do{
            print(SERVER_URL)
            print(param)
            let call = try HTTP.GET(SERVER_URL, parameters: param)
            call.onFinish = {response in
                print(response);
                print("call.onFinish");
               
            }
            
            call.start{response in
                print(response);
                 self.handlerTheResponse(response)
                print("start to call")
            }
        }catch{
            
        }
    }
  
    func handlerTheResponse(response:Response){
        if let err = response.error {
            print("error: \(err.localizedDescription)")
            self.onCompleteFunc!(nil,err)
            return //also notify app of failure as needed
        }
        if let data = response.data as? NSData {
            
            
             //prints the HTML of the page
            if (self.onCompleteFunc != nil){
                var jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                self.onCompleteFunc!(jsonResult,nil)
            }
            if (self.onJsonCompleteFunc != nil){
                let jsonResult = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                print("response: \(jsonResult)")
                self.onJsonCompleteFunc!(jsonResult,nil)
            }

        }
    }


    func uploadImage(data:NSData,onJsonResponseComplete:APIJSONCallback){
      
        print("uploadImage");
        
        do{
            let upload = Upload.init(data: data,fileName:"abc.png",mimeType:"application/octet-stream")
            let params = ["api":"upload.image","data":upload]
            let operate = try HTTP.POST(SERVER_URL,parameters:params)
            operate.start({response in
                print(response);
                print("operate aaaaaa");
                if let data = response.data as? NSData {
                    if (self.onJsonCompleteFunc != nil){
                        let jsonResult = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                        print("response: \(jsonResult)")
                        onJsonResponseComplete(jsonResult,nil)
                    }
                }
                
            })
            
            operate.progress = {progress in
                
                if progress > 0  {
                    print("progress is \(progress)")
                }
            }
        }catch let error{
            print("break error\(error)")
        }
        
    }

    func uploadImage(nsData:NSData,onComplete:APICallback){
      
        print("uploadImage");
        
        do{
            let upload = Upload.init(data:nsData,fileName:"abc.png",mimeType:"application/octet-stream")
            let params = ["api":"upload.image","file":upload]
            let operate = try HTTP.POST(SERVER_URL,parameters:params)
            operate.start({response in
                print(response);
                print("operate aaaaaa");
                if let data = response.data as? NSData {
                    if (self.onJsonCompleteFunc != nil){
                        let jsonResult = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                        print("response: \(jsonResult)")
//                        onComplete(jsonResult,nil)
                    }
                }
                
            })
            
            operate.progress = {progress in
                
                if progress > 0  {
                    print("progress is \(progress)")
                }
            }
        }catch{
            print("break error")
        }
        
    }
}