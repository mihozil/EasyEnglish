//
//  UserInfo.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/29/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation
import UIKit

typealias LearningProgress = Dictionary<String,Dictionary<String, Any>>

class UserInfo : NSObject, NSCoding {
    var userName : String
    var userId : String
    var learningProgress : LearningProgress?
    init(userName : String, userId : String) {
        self.userName = userName
        self.userId = userId
        self.learningProgress = Dictionary.init()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.userName = coder.decodeObject(forKey: "userName") as! String
        self.userId = coder.decodeObject(forKey: "userId") as! String
        self.learningProgress = (coder.decodeObject(forKey: "learningProgress") as? LearningProgress)
        if self.learningProgress == nil {
            self.learningProgress = Dictionary.init()
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.userName, forKey: "userName")
        coder.encode(self.userId, forKey: "userId")
        coder.encode(self.learningProgress, forKey: "learningProgress")
    }
    
    func updateLearningProgress(unitId: Int, lessonId : Int, toQuestion:Int) {
        let unitName = String(format: "unit_%d", unitId)
        var unit = self.learningProgress![unitName]
        if unit==nil {
            unit = Dictionary.init()
        }
        let lessonName = String(format: "lesson_%d", lessonId)
        var lesson = unit![lessonName] as? Dictionary<String, Any>
        if lesson == nil {
            lesson = Dictionary<String, Any>.init()
        }
        
        if let answered = lesson!["toQuestion"] as? Int {
            if answered >= toQuestion {
                return
            }
        }
        
        lesson!["toQuestion"] = toQuestion
        unit![lessonName] = lesson
        self.learningProgress![unitName] = unit
    }
    
    func getLessonToQuestion(unitId : Int, lessonId: Int) -> Int {
        let unitStr = String(format: "unit_%d", unitId)
        let lessonStr = String(format: "lesson_%d", lessonId)
        
        if let learningProgress = self.learningProgress {
            if let unitProgress = learningProgress[unitStr] {
                if let lessonProgress = unitProgress[lessonStr] as? Dictionary<String, Any> {
                    if let toQuestion = lessonProgress["toQuestion"] as? Int {
                        return toQuestion
                    }
                }
            }
        }
        return 0
    }
    
    func updateUnitWithLessonFinished(unitId: Int, finishedLesson: Int) {
           let unitName = String(format: "unit_%d", unitId)
           var unit = self.learningProgress![unitName]
           if unit==nil {
               unit = Dictionary.init()
           }
           
            if let totalFinished = unit!["totalFinished"] as? Int{
                unit!["totalFinished"] = totalFinished + 1
            } else {
                unit!["totalFinished"] = 1
            }
            self.learningProgress![unitName] = unit
       }
    
    func getUnitTotalFinished(unitId:Int) -> Int {
        let unitStr = String(format: "unit_%d", unitId)
        if let learningProgress = self.learningProgress {
            if let unitProgress = learningProgress[unitStr] {
                if let totalFinished = unitProgress["totalFinished"] as? Int {
                    return totalFinished
                }
            }
        }

        return 0
    }
    
}
