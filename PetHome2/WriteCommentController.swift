//
//  WriteCommentController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/5/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WriteCommentController:UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtComment: UITextView!
    
    var posId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.txtComment.returnKeyType = UIReturnKeyType.Go
        self.txtComment.becomeFirstResponder()
        self.txtComment.delegate = self
        self.txtComment.scrollEnabled = true
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
       
    }

    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
        
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder();
        return true
    }

    @IBAction func onPublishCommentHandler(sender: AnyObject) {
        self.txtComment.resignFirstResponder();
        
        let param = ["post_id":self.posId,"text":self.txtComment.text]
        
        RequestManager.shareInstance().sendRequest(API_POST_COMMENT, param: param, onJsonResponseComplete: {(respnse:JSON?,error:AnyObject?) in
                print(respnse);
//                Global.shareInstance().sendComment(String(self.posId),commentBody: self.txtComment.text )
                dispatch_async(dispatch_get_main_queue(), {()->Void in
                    self.navigationController?.popViewControllerAnimated(true);
                })
            
            }
        )

//
        
    }
    

}