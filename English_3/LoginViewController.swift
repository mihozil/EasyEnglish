//
//  LoginViewController.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 1/7/20.
//  Copyright © 2020 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

class LoginViewController : UIViewController {
    let coverImgView : UIImageView = {
        let cover = UIImageView.init()
        cover.image = UIImage(named:"coverProfile.png")
        return cover
    }()
    
    let welcomeTextView : UITextField = {
        let textView = UITextField.init()
        textView.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        textView.placeholder = "Enter your user name"
        textView.layer.cornerRadius = 3.0
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        textView.leftViewMode = UITextField.ViewMode.always
        textView.leftView = spacerView
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Profile"
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.95, alpha: 1.0)
        
        let margin = 25.0
        coverImgView.frame = CGRect(x: margin, y: 0, width: Double(UIScreen.main.bounds.size.width) - margin*2, height: Double(UIScreen.main.bounds.size.width) - margin * 2)
        self.view.addSubview(coverImgView)
        
        welcomeTextView.frame = CGRect(x: 0, y: 0, width:coverImgView.width-60 , height: 35)
        welcomeTextView.center = CGPoint(x: coverImgView.centerX, y: coverImgView.bottom+20)
        welcomeTextView.delegate = self
        self.view.addSubview(welcomeTextView)
        
        welcomeTextView.becomeFirstResponder()
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text  {
            if text.count > 0  {
                if let nav = self.navigationController {
                    if let mainTab = nav.viewControllers[0] as? MainTabBarController {
                        if (mainTab.viewControllers?[0] as? HomeViewController) != nil {
                            UserManager.shared.createUserWithName(name: text)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        } else {
            ToastView.showToastView(text: "You must enter a valid username", time: Int(3.0))
        }
        return true
    }
}
