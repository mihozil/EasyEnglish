//
//  MutualView.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/25/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

class LabelViewWithSoundButton : UIView {
    let button : WidenButton =
    {
        let _button = WidenButton.init()
        _button.setImage(UIImage(named: "sound"), for: UIControl.State.normal)
        _button.left = 5
        _button.top = 5
        return _button
    }()
    
    let label : UILabel = {
        let _label = UILabel.init()
        _label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        _label.textAlignment = NSTextAlignment.center
        _label.numberOfLines = 0
        _label.top = 0
        return _label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(button)
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var frame: CGRect {
        didSet {
            button.height = self.frame.size.height - 10
            button.width = button.height
            label.frame = CGRect.init(x: button.right+5, y: 0, width: self.frame.size.width-(button.right+5), height: self.frame.size.height)
        }
    }
    
    func handleEvenSoundButton(event:UIControl.Event, actionBlock:@escaping()->Void) {
        button.handleControlEvent(event: event, actionBlock: actionBlock)
    }
    
    var actionBlock : (()->Void)?
    
    func addTapAction(actionBlock:@escaping()->Void) {
        if let gestures = self.gestureRecognizers {
            for gesture in gestures {
                self.removeGestureRecognizer(gesture)
            }
        }
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleAtionTapView))
        self.addGestureRecognizer(tap)
        
        self.actionBlock = actionBlock
    }
    
    @objc func handleAtionTapView() {
        if let handler = self.actionBlock {
            handler()
        }
    }
    
    var text : String? {
        didSet {
            label.text = self.text
        }
    }
}

class WidenButton : UIButton {
    var completionBlock : (()->Void)?
    func handleControlEvent(event:UIControl.Event, actionBlock:@escaping()-> Void) {
        completionBlock = actionBlock
        self.addTarget(self, action: #selector(callBlockAction), for: event)
    }
    
    @objc func callBlockAction() {
        if let handler = completionBlock {
            handler()
        }
    }
    
}
