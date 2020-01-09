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
    var items : Array<LessonModel>?
    var unitId : Int?
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
              self.unitId = 1
              self.title = "Unit 1: Single Words"
              QuestionFlowManager.shared.currentUnitId = 1
              #endif
        let collectionLayout = UICollectionViewFlowLayout.init()
               collectionLayout.itemSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 80)
               
               collectionView = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: collectionLayout)
    
               self.view.addSubview(collectionView!)
               
               items = DataManager.fetchUnitWithId(unitId: 1)
        
        
        
        // Do any additional setup after loading the view.
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.95, alpha: 1.0)
        collectionView!.register(LessonCollectionCell.self, forCellWithReuseIdentifier: LessonCollectionCell.identifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.updateLessonsProgress() // minhnht noted : may be update later
        self.collectionView?.reloadData()
    }
    
    func updateLessonsProgress() {
        for item in items! {
            let userInfo = UserManager.shared.user
            if let toQuestion = userInfo?.getLessonToQuestion(unitId: self.unitId!, lessonId: item.lessonId) {
                item.toQuestion = toQuestion
            }
            
        }
    }
    
    
    
}

extension LessonViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : LessonCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: LessonCollectionCell.identifier, for: indexPath) as! LessonCollectionCell
        let item = items![indexPath.item]
        cell.lesson = item
        return cell
    }
}

extension LessonViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let questionVC = MultiSelectionQuestionsViewController.init()
        let lesson = self.items![indexPath.item]
        questionVC.questions = DataManager.fetchLessonWithId(lessonId: lesson.lessonId)
        questionVC.lesson = lesson
        QuestionFlowManager.shared.currentLessonId = lesson.lessonId
        self.navigationController?.pushViewController(questionVC, animated: true)
        
    }
}
