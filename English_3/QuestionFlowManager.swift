//
//  QuestionFlowManager.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/31/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation
import Firebase

class QuestionFlowManager {
    
    static let shared = QuestionFlowManager()
    
    private init() {
        FirebaseApp.configure()
        self.storage = Storage.storage()
        ref = Database.database().reference()
        
    }
    
    var currentUnitId : Int?
    var currentLessonId : Int?
    
    let storage : Storage
    
    var ref: DatabaseReference!

    
    
}
