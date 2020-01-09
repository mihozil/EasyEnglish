//
//  MainTabViewController.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 1/3/20.
//  Copyright © 2020 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = HomeViewController()
        let icon1 = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        item1.tabBarItem = icon1
        
        let item2 = ProfileViewController()
        let icon2 = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        item2.tabBarItem = icon2
        
        let controllers = [item1,item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
}

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

class HomeViewController : UIViewController {
    var collectionView: UICollectionView?
    var units : Array<UnitModel>?
    let collectionLayout = CustomCollectionViewFlowLayout.init()
    
    var topbar : UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let screenSize = UIScreen.main.bounds.size
        collectionLayout.itemSize = CGSize(width: screenSize.width-20, height: (screenSize.width-20)/2 + 20)
        collectionView = UICollectionView.init(frame: UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)), collectionViewLayout: collectionLayout)
        
        collectionView?.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.95, alpha: 1.0)
        collectionView?.register(UnitCollectionViewCell.self, forCellWithReuseIdentifier: UnitCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        self.view.addSubview(collectionView!)
        
        self.units = DataManager.fetchAllUnits()
        self.updateProgressForUnits(reloadData: false)
        
        self.addTopbar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserManager.shared.user == nil {
            let loginVC = LoginViewController.init()
            if #available(iOS 13.0, *) {
                self.tabBarController?.navigationController?.pushViewController(loginVC, animated: true)
            } else {
                 self.navigationController?.pushViewController(loginVC, animated: true)
            }
           
        }
    }
    
   
    func addTopbar() {
        self.topbar = UIView.init()
        self.topbar?.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        let screenSize = UIScreen.main.bounds.size
        self.topbar?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 64)
        
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        titleLabel.text = "Easy English"
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: self.topbar!.centerX, y: 10+self.topbar!.centerY)
        self.topbar?.addSubview(titleLabel)
        
        let settingButton = UIButton.init()
        let settingIMage = UIImage(named: "setting")
        settingButton.setImage(settingIMage, for: UIControl.State.normal)
        settingButton.addTarget(self, action: #selector(didSelectSettingButton), for: UIControl.Event.touchUpInside)
        settingButton.frame = CGRect(x: screenSize.width-10-24, y: 30, width: 24, height: 24)
        self.topbar?.addSubview(settingButton)
        
        let bottomLine = UIView.init(frame: CGRect(x: 0, y: 63, width: screenSize.width, height: 1))
        bottomLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        topbar?.addSubview(bottomLine)
        
        self.view.addSubview(self.topbar!)
    }
    
    @objc func didSelectSettingButton() {
        let settingVC = SettingViewController.init()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func updateProgressForUnits(reloadData: Bool) {
        for unit in self.units! {
            if let totalFinished = UserManager.shared.user?.getUnitTotalFinished(unitId: unit.unitId) {
                unit.totalFinished = totalFinished
            }
            
        }
        if reloadData {
            self.collectionView?.reloadData()
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
}


extension HomeViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.units!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnitCollectionViewCell.identifier, for: indexPath) as! UnitCollectionViewCell
        let model = self.units![indexPath.item]
        cell.model = model
        cell.setNeedsLayout()
        return cell
    }
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let unit = self.units![indexPath.item]
        let lessonVC = LessonViewController.init()
        lessonVC.title = unit.title
        lessonVC.unitId = unit.unitId
        QuestionFlowManager.shared.currentUnitId = unit.unitId
        self.navigationController?.pushViewController(lessonVC, animated: true)
        
    }
}

class ProfileViewController : UIViewController {
    let coverImgView : UIImageView = {
        let cover = UIImageView.init()
        cover.image = UIImage(named:"coverProfile.png")
        return cover
    }()
    
    let welcomeLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Profile"
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.95, alpha: 1.0)
        
        let margin = 25.0
        coverImgView.frame = CGRect(x: margin, y: 0, width: Double(UIScreen.main.bounds.size.width) - margin*2, height: Double(UIScreen.main.bounds.size.width) - margin * 2)
        self.view.addSubview(coverImgView)
        
        welcomeLabel.text = String(format: "Welcome, %@", UserManager.shared.user!.userName)
        welcomeLabel.sizeToFit()
        welcomeLabel.center = CGPoint(x: coverImgView.centerX, y: coverImgView.bottom+30)
        self.view.addSubview(welcomeLabel)
    }
}
