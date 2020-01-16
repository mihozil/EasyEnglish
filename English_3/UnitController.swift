//
//  UnitController.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 1/3/20.
//  Copyright © 2020 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

class UnitCollectionViewCell : UICollectionViewCell {
    static let identifier = "UnitCollectionViewCell"
    
    let thumbImageView : UIImageView = {
        let imgView = UIImageView.init()
        imgView.layer.cornerRadius = 3.0
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 1.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    let progressLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 1.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(progressLabel)
        self.contentView.addSubview(thumbImageView)
        self.contentView.sendSubviewToBack(thumbImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: UnitModel? {
        didSet {
             self.thumbImageView.setFireBaseImageWithUrl(url:self.model!.thumb)
            
            self.titleLabel.text = self.model?.title
            self.descriptionLabel.text = self.model?.desc
            if self.model!.totalFinished > 0 {
                self.progressLabel.text = String(format: "%d/%d", self.model!.totalFinished,self.model!.totalLessons)
            } else {
                self.progressLabel.text = ""
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x = 10.0
        var y = 5.0
        thumbImageView.frame = CGRect(x: x, y: y, width: Double(self.contentView.width-20), height: Double((self.contentView.width-20)/2))
        
        self.titleLabel.sizeToFit()
        self.descriptionLabel.sizeToFit()
        self.progressLabel.sizeToFit()
        y = Double(thumbImageView.bottom - titleLabel.height - 5 - descriptionLabel.height - 10)
        
        x += 5
        self.titleLabel.frame = CGRect(x: x, y: y, width: Double(self.titleLabel.width), height: Double(self.titleLabel.height))
        self.progressLabel.frame = CGRect(x: self.thumbImageView.right - self.progressLabel.width-5, y:thumbImageView.top+5, width: progressLabel.width, height: progressLabel.height)
        
        y += Double(titleLabel.height) + 5.0
        self.descriptionLabel.frame = CGRect(x: x, y: y, width: Double(self.descriptionLabel.width), height: Double(self.descriptionLabel.height))
        
    }
}

class UnitModel {
    let thumb : String
    let title : String
    let unitId : Int
    let desc : String
    var totalFinished : Int
    let totalLessons : Int
    init( thumb: String, title: String, unitId: Int, desc: String, totalLesson: Int) {
        self.thumb = thumb
        self.title = title
        self.unitId = unitId
        self.desc = desc
        self.totalLessons = totalLesson
        self.totalFinished = 0
    }
}
