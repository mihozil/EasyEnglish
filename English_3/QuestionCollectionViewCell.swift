//
//  QuestionCollectionViewCell.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/27/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

class QuestionCollectionViewCell : UICollectionViewCell {
    var question : QuestionModel?
    var didAnswerCorrect : (()->Void)?
    var didAnswerWrong : (()->Void)?
}

class MultiSelectQuestionCollectionViewCell : QuestionCollectionViewCell {
    static let identifier : String = "MultiSelectQuestionViewCell"
    
    override var question : QuestionModel? {
        didSet {
            if (self.question?.texts.count)!>0 {
                questionLabel.text = self.question?.texts[0]
                questionLabel.handleEvenSoundButton(event: UIControl.Event.touchUpInside, actionBlock: {
                    SpeechService.shared.speak(text: (self.question?.texts[0])!, completion: {
                        
                    })
                })
            }
            
            for i in 0...(self.question!.thumbs.count-1) {
                let thumb = self.question!.thumbs[i]
                
                let answerView = answers![i]
                answerView.isHidden = false
                answerView.image = UIImage(named: thumb)
            }
        }
    }
    
    
    var questionLabel = LabelViewWithSoundButton.init()
    
    var answers : Array<UIImageView>?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let answer1 : UIImageView = self.initialAnswerImageView(tag: 0)
        let answer2 : UIImageView = self.initialAnswerImageView(tag: 1)
        let answer3 : UIImageView = self.initialAnswerImageView(tag: 2)
        let answer4 : UIImageView = self.initialAnswerImageView(tag: 3)
        answers = [answer1,answer2,answer3,answer4]

        self.contentView.addSubview(answer1)
        self.contentView.addSubview(answer2)
        self.contentView.addSubview(answer3)
        self.contentView.addSubview(answer4)
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
        let trueAns = self.question?.answer
        if getAns == trueAns
        {
            ToastView.showTrueAnswerToastForView(view: imageView, completionHandler: {
                UserManager.shared.questionViewController?.gotoNextQuestion(currentQuestion: self.question!.idx)
            })
            SpeechService.shared.playFileName(name: "correct.mp3")
            if let handler = self.didAnswerCorrect {
                handler()
            }
            
        } else
        {
            ToastView.showFalseAnswerToastForView(view: imageView)
            SpeechService.shared.playFileName(name: "wrong.mp3")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let screenSize = UIScreen.main.bounds.size
        let answerSize = CGSize.init(width: (Double(screenSize.width)-30)/2, height: (Double(screenSize.height-64)-60-35)/2)
        var x = 10.0
        var y = 5.0 // statusBar
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

class ListenSpeakQuestionCollectionViewCell : QuestionCollectionViewCell {
    static let identifier : String = "ListenSpeakQuestionCell"
    let questionLabel : LabelViewWithSoundButton = LabelViewWithSoundButton.init()
    let thumbImageView : UIImageView = {
        let imgView = UIImageView.init()
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        return imgView
    }()
    override var question : QuestionModel? {
        didSet {
            self.questionLabel.text = self.question?.texts[0]
            self.thumbImageView.image = UIImage(named: self.question!.thumbs[0])
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.questionLabel)
        self.contentView.addSubview(self.thumbImageView)
        self.contentView.backgroundColor = UIColor.init(red: 0.0, green: 0.9, blue: 0.9, alpha: 0.06)

        questionLabel.handleEvenSoundButton(event: UIControl.Event.touchUpInside, actionBlock: {
            SpeechService.shared.speak(text: self.question!.texts[0], completion: {
                UserManager.shared.questionViewController?.gotoNextQuestion(currentQuestion: self.question!.idx)
            })
            if let handler = self.didAnswerCorrect {
                handler()
            }
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        let size = self.contentView.frame.size
        let x = 10.0
        var y = 5.0
        self.questionLabel.frame = CGRect.init(x: x, y: y, width: Double(size.width-10*2), height: 60)
        y += 60+10
        self.thumbImageView.frame = CGRect.init(x: x, y: y, width: Double(size.width-10*2), height: Double(size.height)-y-10)

    }
}


class MultiSelectSecondTypeCollectionViewCell : QuestionCollectionViewCell {
    static let identifier : String = "MultiSelectSecondTypeCollectionViewCell"
    let choices : NSMutableArray = NSMutableArray.init()
    let thumbImgView : UIImageView = {
        let _thumbView = UIImageView.init()
        _thumbView.contentMode = UIView.ContentMode.scaleAspectFit
        return _thumbView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(thumbImgView)
        self.contentView.backgroundColor = UIColor.init(red: 0.0, green: 0.9, blue: 0.9, alpha: 0.06)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var question : QuestionModel? {
        didSet {
            self.thumbImgView.image = UIImage(named: (self.question?.thumbs[0])!)

            let choices : Array<String> = self.question!.texts
            var t : Int = 0
            for choice in choices {
                var label : LabelViewWithSoundButton?
                if t<self.choices.count {
                    label = (self.choices[t] as! LabelViewWithSoundButton)
                } else {
                    label = LabelViewWithSoundButton.init()
                    label?.tag = t
                    label?.addTapAction(actionBlock: {
                        if label?.tag==self.question?.answer {
                            ToastView.showTrueAnswerToastForView(view: label!, completionHandler: {
                                UserManager.shared.questionViewController?.gotoNextQuestion(currentQuestion: self.question!.idx)
                            })
                            SpeechService.shared.playFileName(name: "correct.mp3")
                            if let handler = self.didAnswerCorrect {
                                handler()
                            }
                        } else {
                            ToastView.showFalseAnswerToastForView(view: label!)
                            SpeechService.shared.playFileName(name: "wrong.mp3")
                        }
                    })

                    label?.handleEvenSoundButton(event: UIControl.Event.touchUpInside, actionBlock: {
                        SpeechService.shared.speak(text: choice, completion: {

                        })
                    })

                    self.choices.add(label as Any)
                    self.contentView.addSubview(label!)
                }
                t+=1

                label!.text = choice
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var x = 10.0
        var y = 5.0
        var heightLabel = 45
        if UIScreen.main.scale == 3.0 {
            heightLabel = 55
        }
        let labelSize = CGSize.init(width: Int(self.width-20), height: heightLabel)
        for i in 0...self.choices.count-1 {
            let labelView : UIView = self.choices[i] as! UIView
            labelView.frame = CGRect.init(x: x, y: y, width: Double(labelSize.width), height: Double(labelSize.height))
            y += Double(labelSize.height)+5
        }
        x = 10
        y += Double(labelSize.height)+10
        self.thumbImgView.frame = CGRect.init(x: x, y: y, width: Double(self.width)-20, height: Double(self.height) - y - 10)
    }


}
