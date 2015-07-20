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
    override func viewDidLoad() {
        super.viewDidLoad()
        var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.imgPost.addGestureRecognizer(tapGestureRecognizer)
        self.imgPost.userInteractionEnabled = true
        
    }
    func imageTapped(sender:AnyObject){
        print("image tapped")
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.allowsEditing = false
        imagePicker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker!, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgPost.contentMode = .ScaleAspectFit
            self.imgPost.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onPublishPostHandler(sender: AnyObject) {
        if (self.imgPost.image == nil){
            
            let encodedData = self.txtPost.text.dataUsingEncoding(NSUTF8StringEncoding)!
            var strJson = NSString(data: encodedData, encoding: NSUTF8StringEncoding) as! String
            var param = ["text":strJson]
            RequestManager.shareInstance().sendRequest(API_PUBLISH_POST,param:param as Dictionary<String,AnyObject>,onJsonResponseComplete: onPostComplete)

        }else{
            var imageData:NSData  = UIImagePNGRepresentation(self.imgPost.image);
            RequestManager.shareInstance().uploadImage(imageData, onComplete: onUploadImageComplete)
        }
    }
    func onUploadImageComplete(response:AnyObject?,error:AnyObject?){
        if let url: AnyObject = (response as? Dictionary<String,AnyObject>)?["url"]{
            var images:Array = Array<String>()
            images.append(url as! String);
            let encodedData = self.txtPost.text.dataUsingEncoding(NSUTF8StringEncoding)!
            var strJson = NSString(data: encodedData, encoding: NSUTF8StringEncoding) as! String

            var params = ["text":strJson,"image_url":images]
            
            RequestManager.shareInstance().sendRequest(API_PUBLISH_POST, param: params as? Dictionary<String,AnyObject>, onJsonResponseComplete:onPostComplete)
           
        }
    }
    func  onPostComplete(response:JSON?,error:AnyObject?){
        print("on upload and post complete")
        if let post = response?["postInfo"]  {
            Global.shareInstance().getDataCached().publishPost(post)
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let navigation = self.navigationController{
                navigation.popViewControllerAnimated(true)
            }
        })
        print("\(self.navigationController!.viewControllers)");

    }
}
