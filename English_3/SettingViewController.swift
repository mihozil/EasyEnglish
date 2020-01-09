//
//  SettingViewController.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 1/8/20.
//  Copyright © 2020 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

enum SettingType : Int {
    case VoiceType = 0
}

class SettingViewController : UIViewController {
    var sections : Array<SettingSectionModel>?
    var collectionView : UICollectionView?
    var topbar : UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var femaleVoice = true
        if UserManager.shared.setting?.voiceType == VoiceType.waveNetMale {
            femaleVoice = false
        }
        
        let settingSection = SettingSectionModel.init(title: "Choice voice type", items: [SettingCellModel.init(title: "Male voice", selection: !femaleVoice),SettingCellModel.init(title: "Female voice", selection: femaleVoice)])
        sections = [settingSection]
        
        let screenSize = UIScreen.main.bounds.size
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.itemSize = CGSize(width: screenSize.width-20, height: 44)
        collectionLayout.headerReferenceSize = CGSize(width: screenSize.width-20, height: 30)
        collectionView = UICollectionView.init(frame: UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)), collectionViewLayout: collectionLayout)
        
        collectionView?.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.95, alpha: 1.0)
        collectionView?.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.identifier)
        collectionView?.register(SettingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingHeaderView.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        self.view.addSubview(collectionView!)
        
        self.addTopBar()
        
    }
    
    func addTopBar() {
           self.topbar = UIView.init()
           self.topbar?.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
           let screenSize = UIScreen.main.bounds.size
           self.topbar?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 64)
                         
           let titleLabel = UILabel.init()
           titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
           titleLabel.text = "Setting"
           titleLabel.sizeToFit()
           titleLabel.center = CGPoint(x: self.topbar!.centerX, y: 10+self.topbar!.centerY)
           self.topbar?.addSubview(titleLabel)
           
           let quitButton = UIButton.init(frame: CGRect.init(x: 10, y: 30, width: 24, height: 24))
           quitButton.addTarget(self, action: #selector(didSelectBackBt), for: UIControl.Event.touchUpInside)
           quitButton.tintColor = UIColor.lightGray
           let quitImage = UIImage(named: "quit")!.withRenderingMode(.alwaysTemplate)
           quitButton.setImage(quitImage, for: UIControl.State.normal)
           self.topbar?.addSubview(quitButton)
           
           let bottomLine = UIView.init(frame: CGRect(x: 0, y: 63, width: screenSize.width, height: 1))
           bottomLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
           topbar?.addSubview(bottomLine)
           
           self.view.addSubview(self.topbar!)
       }
    
    @objc func didSelectBackBt() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SettingViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections![indexPath.section]
        var i = 0
        for item in section.items {
            if i == indexPath.item {
                item.selection = true
                if item.title == "Male voice" {
                    UserManager.shared.setting?.voiceType = VoiceType.waveNetMale
                } else {
                    UserManager.shared.setting?.voiceType = VoiceType.waveNetFemale
                }
            } else {
                item.selection = false
            }
            i+=1
        }
        self.collectionView?.reloadData()
    }
}

extension SettingViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections!.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections![section]
        return section.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections![indexPath.section]
        let item = section.items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCollectionViewCell.identifier, for: indexPath) as? SettingCollectionViewCell
        cell?.model = item
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingHeaderView.identifier, for: indexPath) as? SettingHeaderView
            let section = sections?[indexPath.section]
            view?.title = section?.title
            return view!
        }
        return UICollectionReusableView.init()
    }
}

class SettingCollectionViewCell : UICollectionViewCell {
    static let identifier = "SettingCollectionViewCell"
    
    var model : SettingCellModel? {
        didSet {
            self.titleLabel.text = self.model?.title
            self.selectionView.isHidden = !(self.model!.selection)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.selectionView)
        self.contentView.addSubview(self.separatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let selectionView : UIImageView = {
        let imgView = UIImageView.init()
        let image = UIImage(named: "tick.jpg")?.withRenderingMode(.alwaysTemplate)
        imgView.image = image
        imgView.tintColor = UIColor.lightGray
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        return imgView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return label
    }()
    
    let separatorView : UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 44))
        self.selectionView.frame = CGRect(x: self.titleLabel.right+10, y: 5, width: 15, height: 15)
        self.selectionView.centerY = self.titleLabel.centerY
        self.separatorView.frame = CGRect(x: 10, y: self.contentView.height-1, width: self.contentView.width-20, height: 0.5)
        
    }
    
}

class SettingCellModel {
    let title : String
    var selection : Bool
    init(title : String, selection: Bool) {
        self.title = title
        self.selection = selection
    }
}

class SettingSectionModel {
    let title : String
    let items : Array<SettingCellModel>
    init(title: String, items : Array<SettingCellModel>) {
        self.title = title
        self.items = items
    }
}

class SettingHeaderView : UICollectionReusableView {
    static let identifier = "SettingHeaderView"
    let label : UILabel  = {
        let _label = UILabel.init()
        _label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        _label.textColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        return _label
    }()
    var title : String?  {
        didSet {
            self.label.text = self.title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        self.label.frame = self.bounds.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        
    }
}


