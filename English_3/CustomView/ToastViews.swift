//
//  ToastViews.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/23/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation
import UIKit
class ToastView: NSObject {
    class func borderLayerForView(view:UIView, color: UIColor) -> CAShapeLayer {
        var rect = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        rect = rect.inset(by: UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1))
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 3.0)
        let borderLayer = CAShapeLayer()
        borderLayer.path = roundedRect.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = 3.0
        
        return borderLayer
    }
    
    class func showTrueAnswerToastForView(view:UIView, completionHandler:@escaping()->Void) {
        let borderLayer = self.borderLayerForView(view: view, color: UIColor.green)
        let borderWidth = view.layer.borderWidth
        view.layer.borderWidth = 0
        view.layer.addSublayer(borderLayer)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false ) { _ in
            borderLayer.removeFromSuperlayer()
            view.layer.borderWidth = borderWidth
            completionHandler()
        };
    }
    
    class func showFalseAnswerToastForView(view:UIView) {
        let borderLayer = self.borderLayerForView(view: view, color: UIColor.red)
        let borderWidth = view.layer.borderWidth
        view.layer.borderWidth = 0
        view.layer.addSublayer(borderLayer)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false ) { _ in
            borderLayer.removeFromSuperlayer()
            view.layer.borderWidth = borderWidth
        };
    }
    
    static var currentToastView : UIView?
    
    class func showToastView(text: String, time : Int) {
        if let topViewController = self.topViewController() {
            if let toastView = currentToastView {
                toastView .removeFromSuperview()
                currentToastView = nil
            }
            
            let label = UILabel.init()
            label.font = UIFont.systemFont(ofSize: 15)
            label.text = text
            label.textColor = UIColor(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            label.backgroundColor = UIColor.black.withAlphaComponent(0.66)
            label.layer.cornerRadius = 5.0
            label.layer.masksToBounds = true
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.center
            let size = label.sizeThatFits(CGSize(width: topViewController.view.width/1.5, height: CGFloat(MAXFLOAT)))
            label.width = size.width+20
            label.height = size.height+10
            label.center = topViewController.view.center
            
            
            topViewController.view.addSubview(label)
            label.alpha = 0
            UIView.animate(withDuration: 0.1, animations: {
                label.alpha = 1.0
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(time*1000), execute: {
                    label.removeFromSuperview()
                    currentToastView = nil
                })
            })
            
            currentToastView = label
        }
        
        
    }
    
    class func topViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
}
