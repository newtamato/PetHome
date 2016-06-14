//
//  PublishPostDialogController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/10/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
class PublishPostDialogController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var txtPost: UITextView!
    
    var imagePicker:UIImagePickerController?
    var imageUrl:NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.imgPost.addGestureRecognizer(tapGestureRecognizer)
        self.imgPost.userInteractionEnabled = true
        
    }
    func imageTapped(sender:AnyObject){
        print("image tapped", terminator: "")
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.allowsEditing = false
        imagePicker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker!, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgPost.contentMode = .ScaleAspectFit
            self.imgPost.image = pickedImage
            self.imageUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
            
            print("\(self.imageUrl)",terminator: "");
//            print("\(self.navigationController!.viewControllers)", terminator: "");
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onPublishPostHandler(sender: AnyObject) {
        if (self.imgPost.image == nil){
            
            let encodedData = self.txtPost.text.dataUsingEncoding(NSUTF8StringEncoding)!
            let strJson = NSString(data: encodedData, encoding: NSUTF8StringEncoding) as! String
            let param = ["text":strJson]
            RequestManager.shareInstance().sendRequest(API_PUBLISH_POST,param:param as Dictionary<String,AnyObject>,onJsonResponseComplete: onPostComplete)

        }else{
            let imageData:NSData  = UIImagePNGRepresentation(self.imgPost.image!)!;
            RequestManager.shareInstance().uploadImage(imageData, onJsonResponseComplete: onUploadImageComplete)
        }
    }
    func onUploadImageComplete(response:JSON?,error:AnyObject?){
        if let url: String = response!["url"].stringValue{
            var images:Array = Array<String>()
            images.append(url);
            let encodedData = self.txtPost.text.dataUsingEncoding(NSUTF8StringEncoding)!
            let strJson:String = NSString(data: encodedData, encoding: NSUTF8StringEncoding) as! String

            let params = ["text":strJson,"image_url":images]
            
            RequestManager.shareInstance().sendRequest(API_PUBLISH_POST, param: params as? Dictionary<String, AnyObject>, onJsonResponseComplete:onPostComplete)
           
        }
    }
    func  onPostComplete(response:JSON?,error:AnyObject?){
        print("on upload and post complete", terminator: "")
        if let post = response?["postInfo"]  {
            Global.shareInstance().getDataCached().publishPost(post)
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let navigation = self.navigationController{
                navigation.popViewControllerAnimated(true)
            }
        })
        print("\(self.navigationController!.viewControllers)", terminator: "");

    }
}
