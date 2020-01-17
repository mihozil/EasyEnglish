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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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

                answerView.setFireBaseImageWithUrl(url: thumb, placeHolder: nil)
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
            if let handler = self.didAnswerCorrect {
                handler()
            }
            
        } else
        {
            ToastView.showFalseAnswerToastForView(view: imageView)
            if let handler = self.didAnswerWrong {
                handler()
            }
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

            self.thumbImageView.setFireBaseImageWithUrl(url: (self.question?.thumbs[0])!, placeHolder: nil)
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.questionLabel)
        self.contentView.addSubview(self.thumbImageView)

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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var question : QuestionModel? {
        didSet {
 
            self.thumbImgView.setFireBaseImageWithUrl(url: (self.question?.thumbs[0])!, placeHolder: nil)

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
                    
                            if let handler = self.didAnswerCorrect {
                                handler()
                            }
                            
                        } else {
                            ToastView.showFalseAnswerToastForView(view: label!)
                            if let handler = self.didAnswerWrong {
                                handler()
                            }
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

protocol RearrangeViewProtocol {
    func didSelectButton(button: UIButton)
}

class RearrangementQuestionCollectionViewCell : QuestionCollectionViewCell, RearrangeViewProtocol {
    static let identifier = "RearrangementQuestionCollectionViewCell"
    
    let toFillView : RearrangeView
    let initialView : RearrangeView
    let thumbImageView : UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    let resetButton : UIButton = {
        let button = UIButton.init()
        button.setTitle("Reset", for: UIControl.State.normal)
//        button.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
//        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 3.0
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        button.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1.0), for: UIControl.State.normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        
        toFillView = RearrangeView.init(type: RearrangeViewType.TypeToFill)
        initialView = RearrangeView.init(type: RearrangeViewType.TypeInitial)
        
        super.init(frame: frame)
        
        
        toFillView.rearrangeCell = self
        initialView.rearrangeCell = self
        resetButton.addTarget(self, action: #selector(resetAllCharacter), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(initialView)
        self.contentView.addSubview(toFillView)
        self.contentView.addSubview(thumbImageView)
        self.contentView.addSubview(resetButton)
    }
    
    override func prepareForReuse() {
        if toFillView.addedCharacters.count > 0 {
            self.resetAllCharacter()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var trueText : String?
    override var question : QuestionModel? {
        didSet {
            let arrangedText = self.question?.texts[0]
            self.trueText = self.question?.texts[1]
            initialView.text = arrangedText
            toFillView.text = self.trueText
            
             self.thumbImageView.setFireBaseImageWithUrl(url: (self.question?.thumbs[0])!, placeHolder: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x = 10.0
        var y = 10.0
        self.toFillView.frame = CGRect(x: x, y: y, width: Double(self.contentView.width-20), height: 44)
        y += (20+Double(self.toFillView.height))
        self.initialView.frame = CGRect(x: x, y: y, width: Double(self.contentView.width-20), height: 44)
        y += (10+Double(self.initialView.height))
        
        self.resetButton.frame = CGRect(x: Double(self.width)-70, y: y, width: 60, height: 30)
        y += Double(resetButton.height + 10)
        
        self.thumbImageView.frame = CGRect(x: x, y: y, width: Double(self.contentView.width-20), height: Double(self.contentView.height)-y-10)
    }
    
    func didSelectButton(button: UIButton) {
        if self.toFillView.subviews.contains(button) {
            return;
        }
        self.moveViewFromInitialToArrange(view: button)
        self.toFillView.addedCharacters.append(button.titleLabel!.text!)
        
        if self.toFillView.addedCharacters.count == self.toFillView.text?.count {
            if self.toFillView.addedCharacters == self.toFillView.text {
                ToastView.showTrueAnswerToastForView(view: self.toFillView, completionHandler: {
                    UserManager.shared.questionViewController?.gotoNextQuestion(currentQuestion: self.question!.idx)
                })
                
                if let handler = self.didAnswerCorrect {
                    handler()
                }
            } else {
                ToastView.showFalseAnswerToastForView(view: self.toFillView)
                if let handler = self.didAnswerWrong {
                    handler()
                }
            }
        }
    }
    
    func moveViewFromInitialToArrange(view : UIView) {
        let newRectInArrangedView = self.toFillView.boundForCharacterAtIndex(index: self.toFillView.addedCharacters.count, textCount: self.trueText!.count)
        self.moveView(view: view, fromSuper: self.initialView, toSuper: self.toFillView, atRect: newRectInArrangedView)
    }
    
    func moveView(view: UIView, fromSuper:UIView, toSuper:UIView, atRect:CGRect) {
        view.removeFromSuperview()
        
        let preFrame = view.frame
        view.frame = fromSuper.convert(preFrame, to: toSuper)
        toSuper.addSubview(view)
        
        UIView.animate(withDuration: 0.2, animations: {
            view.frame = atRect
        }, completion: { _ in
            
        })
    }
    
    @objc func resetAllCharacter() {
        self.toFillView.addedCharacters = ""
        for button in self.initialView.buttonViews! {
            if button.superview == self.initialView {
            
            } else {
                self.moveView(view: button, fromSuper: self.toFillView, toSuper: self.initialView, atRect: self.initialView.boundForCharacterAtIndex(index: button.tag, textCount: self.initialView.text!.count))
            }
        }
    }
    
}

enum RearrangeViewType : Int {
    case TypeToFill = 0
    case TypeInitial = 1
};

class RearrangeView : UIView {
    
    weak var rearrangeCell : RearrangementQuestionCollectionViewCell?
    let type : RearrangeViewType
    init( type: RearrangeViewType) {
        self.type = type
    
        super.init(frame: CGRect.zero)
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var text : String? {
        
        didSet {
            if self.type == RearrangeViewType.TypeInitial {
                self.updateButtonFrameForText()
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            if self.type == RearrangeViewType.TypeInitial {
                self.updateButtonFrameForText()
            }
        }
    }
    
    var buttonViews: Array<UIButton>?
    
    func updateButtonFrameForText() {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        if self.text == nil || self.frame == CGRect.zero {
            return
        }
        
        let buttonWidth = Double(self.width)/Double(self.text!.count)
        var centerX = 0.0 + buttonWidth/2
        let centerY = Double(self.height/2)
        
        var tag = 0
        buttonViews = Array()
        for ch in self.text! {
            
            let button = UIButton.init()
            button.width = CGFloat(max(buttonWidth/2, 30))
            button.height = max(self.height/2, 30)
            button.center = CGPoint(x: centerX, y: centerY)
            button.setTitle(String(ch), for: UIControl.State.normal)
            self.addSubview(button)
            button.addTarget(self, action: #selector(didSelectButton(button:)), for: .touchUpInside)
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 3.0
            button.layer.masksToBounds = true
            button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
            button.setTitleColor(UIColor.darkText, for: UIControl.State.normal)
            
            
            centerX += buttonWidth
            
            button.tag = tag
            buttonViews?.append(button)
            tag += 1
            
        }
    }
    
    var addedCharacters : String  = ""
    
    func boundForCharacterAtIndex(index : Int, textCount:Int) -> CGRect {
        let buttonWidth = Double(self.width)/Double(self.text!.count)
        let width = Double(max(buttonWidth/2, 30))
        let height =  Double(max(self.height/2, 30))
        let centerX = Double(index)*buttonWidth + buttonWidth/2
        let centerY = Double(self.height/2)
        return CGRect(x: centerX-width/2, y: centerY-height/2, width: width, height: height)
    }
    
    @objc func didSelectButton(button : UIButton) {
        self.rearrangeCell?.didSelectButton(button: button)
    }
    
}
