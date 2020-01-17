//
//  ViewController.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/19/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController  {
    
    var collectionView : UICollectionView?
    var items : Array<LessonModel> = []
    var unitId : Int?
    var topbar : UIView?
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionLayout = UICollectionViewFlowLayout.init()
               collectionLayout.itemSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 80)
               
        collectionView = UICollectionView.init(frame: UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)), collectionViewLayout: collectionLayout)
    
               self.view.addSubview(collectionView!)
               
        DataManager.fetchUnitWithFirebase(unitId: self.unitId!, completion: {
            allLessons in
            self.items = allLessons
            self.updateLessonsProgress()
            self.collectionView?.reloadData()
        })
        
        // Do any additional setup after loading the view.
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.95, alpha: 1.0)
        collectionView!.register(LessonCollectionCell.self, forCellWithReuseIdentifier: LessonCollectionCell.identifier)
        
        self.addTopBar()

    }
    
    func addTopBar() {
        self.topbar = UIView.init()
        self.topbar?.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        let screenSize = UIScreen.main.bounds.size
        self.topbar?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 64)
                      
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        titleLabel.text = self.title
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
    
    
    func updateLessonsProgress() {
        for item in items {
            let userInfo = UserManager.shared.user
            if let toQuestion = userInfo?.getLessonToQuestion(unitId: self.unitId!, lessonId: item.lessonId) {
                item.toQuestion = toQuestion
            }
            
        }
    }
    
    var currentLeson : Int = -1
    var lessonLearnAgain : Bool = false
    func didFinishLesson() {
        if currentLeson >= 0 && !lessonLearnAgain {
            UserManager.shared.user?.updateUnitWithLessonFinished(unitId: QuestionFlowManager.shared.currentUnitId!, finishedLesson: currentLeson)
            if let nav = self.navigationController {
                if let parent = nav.viewControllers[0] as? HomeViewController {
                    parent.updateProgressForUnits(reloadData: true)
                } else
                    if let tabBar = nav.viewControllers[0] as? MainTabBarController {
                        if let parent = tabBar.viewControllers![0] as? HomeViewController {
                            
                            parent.updateProgressForUnits(reloadData: true)
                            
                        }
                }
            }
        }
    }
    
}

extension LessonViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : LessonCollectionCell =  collectionView.dequeueReusableCell(withReuseIdentifier: LessonCollectionCell.identifier, for: indexPath) as! LessonCollectionCell
        let item = items[indexPath.item]
        cell.lesson = item
        return cell
    }
}

extension LessonViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let questionVC = QuestionsViewController.init()
        let lesson = self.items[indexPath.item]
        questionVC.lesson = lesson
        QuestionFlowManager.shared.currentLessonId = lesson.lessonId
        self.navigationController?.pushViewController(questionVC, animated: true)
        
        currentLeson = indexPath.item
        if lesson.toQuestion == lesson.totalQuestion {
            lessonLearnAgain = true
        }
        
    }
}
