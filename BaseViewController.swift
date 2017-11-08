//
//  BaseViewController.swift
//  
//
//  Created by Zahid Ahmed on 11/8/17.
//

import UIKit

class BaseViewController: UIViewController {
    
    let keybrdWillShowNotificationName = Notification.Name.UIKeyboardWillShow
    let keybrdWillHideNotificationName = Notification.Name.UIKeyboardWillHide
    
    var bottomLayout : NSLayoutConstraint?
    var selectedUser : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: keybrdWillShowNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: keybrdWillHideNotificationName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: keybrdWillShowNotificationName, object: nil)
        NotificationCenter.default.removeObserver(self, name: keybrdWillHideNotificationName, object: nil)
    }
    
    func keyboardWillShowNotification(_ notification: Notification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    func keyboardWillHideNotification(_ notification: Notification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    func updateBottomLayoutConstraintWithNotification(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        
        let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        if let bottomLayout = bottomLayout {
            bottomLayout.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationCurve, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BaseViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
