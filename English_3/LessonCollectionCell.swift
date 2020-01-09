//
//  LessonCollectionCell.swift
//  English
//
//  Created by Minh Nguyen's Mac on 12/18/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation
import UIKit


class LessonCollectionCell : UICollectionViewCell {
    let thumbImgView = UIImageView.init()
    var titleLabel : UILabel = {
        let _titleLabel = UILabel.init()
        _titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        return _titleLabel
    }()
    var descriptionLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        
        self.object = LessonObject.init()
        
        super.init(frame: frame)
        
        self.contentView.addSubview(thumbImgView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: Double = 10.0
        var y: Double = 10.0
        thumbImgView.frame = CGRect.init(x: x, y: y, width: 100.0, height: 100.0)
        x += (100+10)
        
        self.titleLabel.frame = CGRect.init(x: x, y: y, width: Double(self.contentView.frame.size.width - CGFloat(x) - CGFloat(10.0)), height: 50.0)
        
        y += 50
        self.descriptionLabel.frame = CGRect.init(x: x, y: y, width: Double(self.titleLabel.frame.size.width), height: 50.0)
    }
    
    var object: LessonObject {
        
        didSet {
            if let thumb = self.object.thumb {
                let url = URL.init(string: thumb)!
                thumbImgView.setImageWith(url);
            }
            
            titleLabel.text = self.object.title
            descriptionLabel.text = self.object.description
        }
    }
}

class LessonObject : NSObject {
    public var thumb : String?
    public var title: String?
    
}
