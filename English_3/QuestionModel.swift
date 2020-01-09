//
//  QuestionModel.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/27/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

class QuestionModel {
    let idx : Int
    let type : Int
    let texts : Array<String>
    let thumbs : Array<String>
    let answer: Int
    let tip : String
    init(idx: Int, type: Int, texts: Array<String>, thumbs: Array<String>, answer: Int, tip: String) {
        self.idx = idx
        self.type = type
        self.texts = texts
        self.thumbs = thumbs
        self.answer = answer
        self.tip = tip
    }
}
