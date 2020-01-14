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
    static var identifier : String = "LessionColletionCell"
    
    var thumbImgView : UIImageView = {
        let _thumbImgView = UIImageView.init()
        _thumbImgView.contentMode = UIView.ContentMode.scaleAspectFit
        _thumbImgView.layer.cornerRadius = 3.0
        _thumbImgView.layer.masksToBounds = true
        
        return _thumbImgView
    }()
    var titleLabel : UILabel = {
        let _titleLabel = UILabel.init()
        _titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    
        return _titleLabel
    }()
    var descriptionLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    var progressView : CircularProgressView = {
        let _progressView = CircularProgressView.init()
        _progressView.progressClr = UIColor.gray
        _progressView.trackClr = UIColor.lightGray.withAlphaComponent(0.4)
        return _progressView
    }()
    
    var reviewLabel : UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        label.textColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0);
        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        label.text = "Revision"
        label.textAlignment = NSTextAlignment.center
        label.layer.cornerRadius = 1.0;
        label.layer.masksToBounds = true
        return label
    }()
    
    var progressImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "tick")
        return imageView
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.addSubview(thumbImgView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(progressView)
        self.contentView.addSubview(progressImageView)
        self.contentView.addSubview(self.reviewLabel)
        
        thumbImgView.contentMode = UIView.ContentMode.scaleAspectFit
        thumbImgView.contentMode = UIView.ContentMode.scaleAspectFit
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: Double = 10.0
        var y: Double = 10.0
        thumbImgView.frame = CGRect.init(x: x, y: y, width: 90.0, height: 60.0)
        x += (90+10)
        
        self.descriptionLabel.frame = CGRect.init(x: x, y: y, width: Double(Double(self.contentView.width) - x - 10), height: 24.0)
        
        y += 24 + 3
        self.titleLabel.frame = CGRect.init(x: x, y: y, width: Double(self.contentView.frame.size.width - CGFloat(x) - CGFloat(10.0)), height: 24.0)
        self.progressView.frame = CGRect.init(x: Double(self.contentView.width)-24-20, y: y, width: 24, height: 24)
        self.progressImageView.frame = self.progressView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        
        self.reviewLabel.sizeToFit()
        self.reviewLabel.width += 3
        self.reviewLabel.height += 3
        self.reviewLabel.right = self.thumbImgView.right - 2
        self.reviewLabel.top = self.thumbImgView.top + 2
        
    }
    
    var lesson: LessonModel? {
        
        didSet {
            thumbImgView.image = UIImage(named: self.lesson!.thumb);
            
            titleLabel.text = self.lesson!.title
            descriptionLabel.text = self.lesson!.detail
            if self.lesson!.toQuestion<self.lesson!.totalQuestion {
                self.progressView.setProgressWithAnimation(duration: 0, value: Float(self.lesson!.toQuestion)/Float(self.lesson!.totalQuestion))
                self.progressImageView.isHidden = true
                if self.lesson?.toQuestion == 0 {
                    self.progressView.isHidden = true
                } else {
                    self.progressView.isHidden = false
                }
            } else {
                self.progressImageView.isHidden = false
                self.progressView.isHidden = true
            }
            
            if self.lesson!.isReview {
                self.reviewLabel.isHidden = false
            } else {
                self.reviewLabel.isHidden = true
            }
            
        }
    }
}

class LessonModel  {
    var thumb : String
    var title: String
    var detail : String
    var lessonId : Int
    var toQuestion : Int
    var totalQuestion : Int
    var isReview : Bool
    
    init(lessonId: Int, thumb: String, title: String, detail: String, totalQuestion: Int) {
        self.lessonId = lessonId
        self.thumb = thumb
        self.title = title
        self.detail = detail
        self.toQuestion = 0
        self.totalQuestion = totalQuestion
        
        self.isReview = false
    }
    
    
    
}
