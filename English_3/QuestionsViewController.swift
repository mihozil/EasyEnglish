//
//  QuestionsViewController.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/19/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import UIKit

// q1 : multi select
// q2 :
// q3 :

class MultiSelectionQuestionsViewController: UIViewController {
    
    var functionalBar : UIView?
    var titleLabel : UILabel?
    var collectionView : UICollectionView?
    var questions : Array<QuestionModel> = []
    var progressView : CircularProgressView?
    var lesson : LessonModel?
    var bottomBar : UIView?
    var viewDidAppearOnce = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        let screenSize = UIScreen.main.bounds.size
        
        let collectionViewLayout = UICollectionViewFlowLayout.init()
        collectionViewLayout.itemSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64)
        collectionViewLayout.minimumInteritemSpacing = 0;
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 64, width: screenSize.width, height: screenSize.height-64), collectionViewLayout: collectionViewLayout)
        collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.isScrollEnabled = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(MultiSelectQuestionCollectionViewCell.self, forCellWithReuseIdentifier: MultiSelectQuestionCollectionViewCell.identifier)
        collectionView?.register(ListenSpeakQuestionCollectionViewCell.self, forCellWithReuseIdentifier: ListenSpeakQuestionCollectionViewCell.identifier)
        collectionView?.register(MultiSelectSecondTypeCollectionViewCell.self, forCellWithReuseIdentifier: MultiSelectSecondTypeCollectionViewCell.identifier)
        
        self.view.addSubview(collectionView!)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        self.title = lesson!.title
        let toQuestion = lesson!.toQuestion%questions.count
        collectionView?.scrollToItem(at: IndexPath(item: toQuestion, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        
        initializeFunctionalBar()
        initializeBottomBar()
        
        UserManager.shared.questionViewController = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    func initializeFunctionalBar() {
        
        functionalBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
        functionalBar?.backgroundColor = UIColor.init(red: 0.0, green: 0.9, blue: 0.9, alpha: 0.06)
        
        let quitButton = UIButton.init(frame: CGRect.init(x: 10, y: 30, width: 24, height: 24))
        quitButton.addTarget(self, action: #selector(self.tapQuitButton), for: UIControl.Event.touchUpInside)
        quitButton.tintColor = UIColor.lightGray
        
        
        let quitImage = UIImage(named: "quit")!.withRenderingMode(.alwaysTemplate)
        quitButton.setImage(quitImage, for: UIControl.State.normal)
        functionalBar?.addSubview(quitButton)
        self.view.addSubview(functionalBar!)
        
        self.titleLabel = UILabel.init()
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        self.titleLabel?.frame = CGRect.init(x: quitButton.right+10, y: 20, width: functionalBar!.width-(quitButton.right+10)*2, height: 44)
        self.titleLabel?.text = self.title
        self.titleLabel?.textAlignment = NSTextAlignment.center
        functionalBar?.addSubview(self.titleLabel!)
        
        self.progressView = CircularProgressView.init()
        self.progressView?.frame = CGRect.init(x: functionalBar!.right-(35+20), y: 30, width: 24, height: 24)
        self.progressView?.trackClr = UIColor.lightGray
        self.progressView?.progressClr = UIColor.cyan
        let toQuestion = lesson!.toQuestion%questions.count
        self.progressView?.setProgressWithAnimation(duration: 0.0, value: Float(toQuestion+1)/Float(self.questions.count))
        functionalBar?.addSubview(self.progressView!)
        
    }
    
    func initializeBottomBar() {
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(onPanGesture(pan:)))
        self.view.addGestureRecognizer(panGesture)
        
        self.bottomBar = UIView.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height-44, width: UIScreen.main.bounds.size.width, height: 44))
        self.view.addSubview(bottomBar!)
        bottomBar!.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        let inforButton = UIButton.init(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
        let inforImage = UIImage(named: "information")?.withRenderingMode(.alwaysTemplate)
        inforButton.imageView?.tintColor = UIColor.gray
        inforButton.setImage(inforImage, for: UIControl.State.normal)
        inforButton.addTarget(self, action: #selector(didSelectInforButton), for: UIControl.Event.touchUpInside)
        bottomBar!.addSubview(inforButton)
        self.updateTimerShowBottomBar()
    }
    
    var oldLocationY : CGFloat?
    var timerShowBottombar : Timer?
    
    @objc func onPanGesture(pan: UIPanGestureRecognizer) {
        let location = pan.location(in: self.view)
        if pan.state == UIPanGestureRecognizer.State.began {
            oldLocationY = location.y
            return
        }
        
        let change = location.y - oldLocationY!
        let newTop = bottomBar!.top + change
        if pan.state == UIPanGestureRecognizer.State.changed {
            
            if newTop<=self.view.height && newTop>=self.view.height-44 {
                bottomBar!.top = newTop
            }
        }
        if pan.state == UIPanGestureRecognizer.State.ended || pan.state == UIPanGestureRecognizer.State.cancelled {
            if bottomBar!.top <= self.view.height-15 && change<=0 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.bottomBar!.top = self.view.height-44
                })
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.bottomBar!.top = self.view.height
                })
            }
            self.updateTimerShowBottomBar()
        }
        
        oldLocationY = location.y
    }
    
    func updateTimerShowBottomBar() {
        timerShowBottombar?.invalidate()
        timerShowBottombar = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.bottomBar!.top = self.view.height
            })
        })
    }
    
    @objc func didSelectInforButton() {
        let question = self.getCurrentVisibleQuestion()
        ToastView.showToastView(text: String(format: "Tip: %@", question.tip), time: Int(5.0))
        self.updateTimerShowBottomBar()
        
    }

    override var title: String? {
        didSet {
            self.titleLabel?.text = self.title
        }
    }
    
    @objc func tapQuitButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !viewDidAppearOnce {
            viewDidAppearOnce = true
            let toQuestion = lesson!.toQuestion%questions.count
            self.speakSenntenceAtPage(page: toQuestion)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SpeechService.shared.cancelSpeaking()
    }
    
    public func gotoNextQuestion(currentQuestion : Int) {
        let goBlock = {
            if currentQuestion < self.questions.count - 1 {
                self.collectionView?.scrollToItem(at: IndexPath.init(item: currentQuestion+1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            } else {
                if let nav = self.parent as? UINavigationController {
                    let lessonIdx = nav.viewControllers.count-2
                    if lessonIdx>=0, let parent = nav.viewControllers[lessonIdx] as? LessonViewController {
                        parent.didFinishLesson()
                    }
                }
                self.tapQuitButton()
            }
        }
        
        if SpeechService.shared.busy {
            if let handler = SpeechService.shared.blockImlementOnSpeechCompletion {
                SpeechService.shared.blockImlementOnSpeechCompletion = {
                    handler()
                    goBlock()
                }
            } else {
                SpeechService.shared.blockImlementOnSpeechCompletion = {
                    goBlock()
                }
            }
        } else {
            goBlock()
        }
    }
    
    func getCurrentVisibleQuestion() -> QuestionModel {
        let left : CGFloat = collectionView!.contentOffset.x
        let currentPage = Int(floor(left/self.view.width))
        let question : QuestionModel = self.questions[currentPage]
        return question
    }

}

extension MultiSelectionQuestionsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.questions.count
    }
    
    func getIdentifierForQuestion(questionModel: QuestionModel) -> String {
        if questionModel.type == 1 {
            return MultiSelectQuestionCollectionViewCell.identifier
        }
        if questionModel.type == 2 {
            return ListenSpeakQuestionCollectionViewCell.identifier
        }
        if questionModel.type == 3 {
            return MultiSelectSecondTypeCollectionViewCell.identifier
        }
        return "123" // update later
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let question : QuestionModel = self.questions[indexPath.item]
        let cellIdentifier = self.getIdentifierForQuestion(questionModel: self.questions[indexPath.item])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! QuestionCollectionViewCell
        cell.question = question
        cell.didAnswerCorrect = {
            
            UserManager.shared.user?.updateLearningProgress(unitId: QuestionFlowManager.shared.currentUnitId!, lessonId: QuestionFlowManager.shared.currentLessonId!, toQuestion: question.idx+1)
        }
        
        return cell
    }
}

extension MultiSelectionQuestionsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let left = scrollView.contentOffset.x
        let page = Int(floor(left/scrollView.width))
        self.progressView?.setProgressWithAnimation(duration: 0.1, value: Float(page+1)/Float(self.questions.count))
        
        self.speakSenntenceAtPage(page: page)
    }
    
    func speakSenntenceAtPage(page : Int) {
        let question = self.questions[page]
        if question.type==1 || question.type == 2 {
            SpeechService.shared.speak(text:question.texts[0], completion: {})
        }
    }
}

