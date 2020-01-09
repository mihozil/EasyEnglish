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
    
}
