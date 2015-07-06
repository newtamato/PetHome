//
//  WriteCommentController.swift
//  PetHome2
//
//  Created by 亮亮 侯 on 7/5/15.
//  Copyright (c) 2015 亮亮 侯. All rights reserved.
//

import Foundation
import UIKit
class WriteCommentController:UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtComment: UITextView!
    
    var posId:Int = 0
    
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
//    func textFieldShouldReturn(textField: UITextField) -> Bool{
//        textField.resignFirstResponder()
//        return true
//    }
    @IBAction func onPublishCommentHandler(sender: AnyObject) {
        self.txtComment.resignFirstResponder();
        Global.shareInstance().sendComment(String(self.posId),commentBody: self.txtComment.text )
        self.navigationController?.popViewControllerAnimated(true);
    }
}