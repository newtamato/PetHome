//
// Created by 亮亮 侯 on 7/19/15.
// Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation

class RequestManager {
    private var mRequest:BaseRequest?
    class func shareInstance()->RequestManager{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:RequestManager? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance = RequestManager()
        }
        )
        return Singleton.instance!
    }
    func sendRequest(action:String,param:Dictionary<String,AnyObject>?,onComplete:APICallback){
        if (mRequest == nil){
            mRequest = BaseRequest()
        }
        mRequest!.sendRequest(action,param:param,completionHandler: onComplete)
        mRequest!.startRequest()
    }
    func sendRequest(action:String,param:Dictionary<String,AnyObject>?,onJsonResponseComplete:APIJSONCallback){
        if (mRequest == nil){
            mRequest = BaseRequest()
        }
        mRequest!.sendRequest(action,param:param,onJsonCompleteHandler: onJsonResponseComplete)
        mRequest!.startRequest()
    }
    func uploadImage(nsData:NSData,onComplete:APICallback){
        if (mRequest == nil){
            mRequest = BaseRequest()
        }
        mRequest!.uploadImage(nsData, onComplete: onComplete)
    }
    func uploadImage(data:NSData,onJsonResponseComplete:APIJSONCallback){
        if (mRequest == nil){
            mRequest = BaseRequest()
        }
        mRequest!.uploadImage(data, onJsonResponseComplete: onJsonResponseComplete)
    }
}
