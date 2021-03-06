//
// Created by 亮亮 侯 on 7/19/15.
// Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
class EditUserInfoPageController :UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var txtUserName: UITextField!

    @IBOutlet weak var txtUserDesc: UITextView!
    @IBOutlet weak var imgPost:UIImageView!
    @IBOutlet weak var petImg1:UIImageView!
    @IBOutlet weak var petImg2:UIImageView!
    @IBOutlet weak var petImg3:UIImageView!
    var touchedImageView:UIImageView?
    var imageIndex:Int = -1
    var imageArray:Dictionary<Int,UIImageView>?
    var avatarImgUrl:String?
    var petImageUrlArray:[String]?
    override func viewDidLoad(){
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.imgPost.addGestureRecognizer(tapGestureRecognizer)
        self.imgPost.userInteractionEnabled = true
        let pet1TapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.petImg1.addGestureRecognizer(pet1TapGestureRecognizer)
        self.petImg1.userInteractionEnabled = true

        var pet2TapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.petImg2.addGestureRecognizer(pet1TapGestureRecognizer)
        self.petImg2.userInteractionEnabled = true

        var pet3TapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.petImg3.addGestureRecognizer(pet1TapGestureRecognizer)
        self.petImg3.userInteractionEnabled = true

        self.imageArray = Dictionary<Int,UIImageView>()
        self.imageArray?.updateValue(self.imgPost, forKey: 0)
        self.imageArray?.updateValue(self.petImg1, forKey: 1)
        self.imageArray?.updateValue(self.petImg2, forKey: 2)
        self.imageArray?.updateValue(self.petImg3, forKey: 3)


        self.petImageUrlArray = [String]()
        self.imageIndex = -1
    }

    func imageTapped(sender:AnyObject){
//        self.touchedImageView = sender as? UIImageView
        self.touchedImageView = (sender as! UITapGestureRecognizer).view as? UIImageView
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.touchedImageView!.contentMode = .ScaleAspectFit
            self.touchedImageView!.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCommitUserInfo(sender: AnyObject) {
//        var param = ["nick":,"text":""]
//        RequestManager.shareInstance().sendRequest(API_EDIT_USER_INFO)

        self.onUploadImageComplete(nil,error: nil)

    }
    func  onUploadImageComplete(response:JSON?,error:AnyObject?) {
        if response != nil {
            if let url: String = response!["url"].stringValue {
                if (self.imageIndex == 0 ){
                    self.avatarImgUrl = url
                }else{
                    self.petImageUrlArray?.append(url)
                }
            }
        }
        
        self.imageIndex += 1
        if (self.imageIndex >= self.imageArray!.count) {
            print(self.petImageUrlArray, terminator: "")
            print(self.avatarImgUrl, terminator: "")
            let userName = self.txtUserName.text!
            let text = self.txtUserDesc.text!
            
            let param = ["nick":userName,"text":text,"avatar_url":self.avatarImgUrl!,"image_url":self.petImageUrlArray!]
            
            RequestManager.shareInstance().sendRequest(API_EDIT_USER_INFO, param: param as? Dictionary<String, AnyObject>, onJsonResponseComplete: {(response:JSON?, error:AnyObject?) in
                Global.shareInstance().getDataCached().setUserData(response!)
                dispatch_async(dispatch_get_main_queue(), {()->Void in
                    self.navigationController?.popViewControllerAnimated(true);
                })
            })
        }else if let imgView = self.imageArray?[self.imageIndex]{
            
            if (imgView.image != nil ){
                let imageData: NSData = UIImagePNGRepresentation(imgView.image!)!;
                RequestManager.shareInstance().uploadImage(imageData, onJsonResponseComplete: onUploadImageComplete)
            }
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
