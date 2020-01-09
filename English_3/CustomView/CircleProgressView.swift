//
//  CircleProgressView.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/27/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation
import UIKit
class CircularProgressView: UIView {
   var progressLyr = CAShapeLayer()
   var trackLyr = CAShapeLayer()
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
    }
    
    override var frame: CGRect {
        didSet {
            makeCircularPath()
        }
    }
    
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
    
   var progressClr = UIColor.white {
      didSet {
         progressLyr.strokeColor = progressClr.cgColor
      }
   }
   var trackClr = UIColor.white {
      didSet {
         trackLyr.strokeColor = trackClr.cgColor
      }
   }
   func makeCircularPath() {
      self.backgroundColor = UIColor.clear
      self.layer.cornerRadius = self.frame.size.width/2
      let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
    
      trackLyr.path = circlePath.cgPath
      trackLyr.fillColor = UIColor.clear.cgColor
      trackLyr.strokeColor = trackClr.cgColor
      trackLyr.lineWidth = 3.0
      trackLyr.strokeEnd = 1.0
      layer.addSublayer(trackLyr)
      progressLyr.path = circlePath.cgPath
      progressLyr.fillColor = UIColor.clear.cgColor
      progressLyr.strokeColor = progressClr.cgColor
      progressLyr.lineWidth = 3.0
      progressLyr.strokeEnd = CGFloat(currentVal)
      layer.addSublayer(progressLyr)
   }
    
    var currentVal : Float = 0.0 {
        didSet {
            
        }
    }
    
   func setProgressWithAnimation(duration: TimeInterval, value: Float) {
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.duration = duration
      animation.fromValue = currentVal
      animation.toValue = value
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
      progressLyr.strokeEnd = CGFloat(value)
      progressLyr.add(animation, forKey: "animateprogress")
    
      currentVal = value
   }
}
