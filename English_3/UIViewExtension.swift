//
//  UIViewExtension.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/24/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var width : CGFloat {
        get {
            return self.frame.size.width
        }
        set (newWidth) {
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: newWidth, height: self.frame.size.height)
        }
    }
    var height : CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newHeight)
        }
    }
    var top : CGFloat {
        get {
            return self.frame.origin.y
        }
        set (newTop) {
            self.frame = CGRect.init(x: self.frame.origin.x, y: newTop, width: self.frame.size.width, height: self.frame.size.height)
        }
        
    }
    var left : CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            self.frame = CGRect.init(x: newLeft, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    var bottom : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        
        set (newBottom){
            self.frame = CGRect.init(x: self.frame.origin.x, y: newBottom-self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    var right : CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set (newRight) {
            self.frame = CGRect.init(x: newRight-self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    var centerX : CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width/2
        }
        set (newCenterX) {
            self.frame = CGRect.init(x: newCenterX-self.frame.size.width/2, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    var centerY : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height/2
        }
        
        set (newCenterY){
            self.frame = CGRect.init(x: self.frame.origin.x, y: newCenterY-self.frame.size.height/2, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
}
