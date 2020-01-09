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
    var collectionView : UICollectionView?
    var questions : Array<MultiSelectQuestion> = []
    

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
        collectionView?.register(MultiSelectQuestionViewCell.self, forCellWithReuseIdentifier: MultiSelectQuestionViewCell.identifier)
        self.view.addSubview(collectionView!)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        collectionView?.delegate = self

        
        initializeFunctionalBar()
        
        QuestionsManager.shared.questionViewController = self
    }
    
    func initializeFunctionalBar() {
        
        functionalBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
        functionalBar?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        let quitButton = UIButton.init(frame: CGRect.init(x: 10, y: 25, width: 24, height: 24))
        quitButton.addTarget(self, action: #selector(self.tapQuitButton), for: UIControl.Event.touchUpInside)
        let quitImage = UIImage(named: "quit")
        quitButton.setImage(quitImage, for: UIControl.State.normal)
        functionalBar?.addSubview(quitButton)
        self.view.addSubview(functionalBar!)
    }

    
    @objc func tapQuitButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let question = self.getCurrentVisibleQuestion()
        SpeechService.shared.speak(text: question.question, completion: {
            
        })
    }
    
    public func gotoNextQuestion(currentQuestion : Int) {
        if currentQuestion<self.questions.count-1 {
            self.collectionView?.scrollToItem(at: IndexPath.init(item: currentQuestion+1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
    
    func getCurrentVisibleQuestion() -> MultiSelectQuestion{
        let left : CGFloat = collectionView!.contentOffset.x
        let currentPage = Int(floor(left/self.view.width))
        let question: MultiSelectQuestion = self.questions[currentPage]
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MultiSelectQuestionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MultiSelectQuestionViewCell.identifier, for: indexPath) as! MultiSelectQuestionViewCell
        
        let question = self.questions[indexPath.item]

        cell.question = question
        return cell
    }
}

extension MultiSelectionQuestionsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let question = self.getCurrentVisibleQuestion()
        SpeechService.shared.speak(text: question.question, completion: {
            
        })
    }
    
    
}

class MultiSelectQuestionViewCell : UICollectionViewCell {
    static let identifier : String = "MultiSelectQuestionViewCell"
    
    var question : MultiSelectQuestion? {
        didSet {
            questionLabel.text = self.question?.question
            
            for i in 0...(self.question!.answers.count-1) {
                let answer = self.question!.answers[i]
                
                let url = URL.init(string: answer)
                let answerView = answers![i]
                answerView.setImageWith(url!)
            }
        }
    }
    
    var questionLabel : UILabel =
    {
        var label : UILabel
         label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    var answer1 : UIImageView?
    var answer2 : UIImageView?
    var answer3 : UIImageView?
    var answer4 : UIImageView?
    var answers : Array<UIImageView>?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        answer1 = self.initialAnswerImageView(tag: 0)
        answer2 = self.initialAnswerImageView(tag: 1)
        answer3 = self.initialAnswerImageView(tag: 2)
        answer4 = self.initialAnswerImageView(tag: 3)
        answers = [answer1!,answer2!,answer3!,answer4!]

        self.contentView.addSubview(answer1!)
        self.contentView.addSubview(answer2!)
        self.contentView.addSubview(answer3!)
        self.contentView.addSubview(answer4!)
        self.contentView.addSubview(questionLabel)
        self.contentView.backgroundColor = UIColor.init(red: 0.0, green: 0.9, blue: 0.9, alpha: 0.06)
    }
    
    func initialAnswerImageView(tag: Int) -> UIImageView {
        let imageView = UIImageView.init()
        imageView.tag = tag
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }
    
    @objc func handleTap(_ tap: UIGestureRecognizer) {
        let imageView:UIView = tap.view!
        let getAns = imageView.tag
        let trueAns = self.question?.trueAns
        if getAns == trueAns
        {
            ToastView.showTrueAnswerToastForView(view: imageView, completionHandler: {
                QuestionsManager.shared.questionViewController?.gotoNextQuestion(currentQuestion: self.question!.questionIdx)
            })
            
        } else
        {
            ToastView.showFalseAnswerToastForView(view: imageView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let screenSize = UIScreen.main.bounds.size
        let answerSize = CGSize.init(width: (Double(screenSize.width)-30)/2, height: (Double(screenSize.height-64)-60-30)/2)
        var x = 10.0
        var y = 0.0 // statusBar
        self.questionLabel.frame = CGRect.init(x: x, y: y, width: Double(screenSize.width)-x*2, height: 60)
        y += 60 + 10
        for i in 0...3 {
            let answerView = answers![i]
            answerView.frame = CGRect.init(x: x, y: y, width: Double(answerSize.width), height: Double(answerSize.height))
            if (i%2==0) {
                x += Double(answerSize.width)+10
            } else {
                x -= (Double(answerSize.width)+10)
                y += Double(answerSize.height)+10
            }
        }
            
        
    }
}

class MultiSelectQuestion {
    let question : String
    let answers : Array<String>
    let trueAns : Int
    let questionIdx : Int
    init(question: String, answers: Array<String>, trueAns: Int, questionIdx: Int) {
        self.question = question
        self.answers = answers
        self.trueAns = trueAns  - 1
        self.questionIdx = questionIdx
    }
}

