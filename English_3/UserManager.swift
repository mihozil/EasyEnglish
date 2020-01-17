//
//  QuestionsManager.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/24/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation
import UIKit
class UserManager : NSObject {
    static let shared = UserManager()
    weak var questionViewController : QuestionsViewController?
    
    let defaults = UserDefaults.standard
    var user : UserInfo?
    var setting : SettingInfo? 
    
    func createUserWithName(name : String) {
        let userId = String(format: "%ld", Date().timeIntervalSince1970)
        user = UserInfo.init(userName: name, userId: userId)
         QuestionFlowManager.shared.ref.child("/Users").child(userId).child("name").setValue(name)
               QuestionFlowManager.shared.ref.child("/Users").child(userId).child("id").setValue(userId)
    }
    
    func loadDataWhenAppstart() {
        if let userData = defaults.object(forKey: "userInfo") {
           self.user = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userData as! Data) as? UserInfo
        }
        if let settingInfo = defaults.object(forKey: "settingInfo") {
            self.setting = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(settingInfo as! Data) as? SettingInfo
        } else {
            self.setting = SettingInfo.init()
        }
        
        // minhnht noted : get learning Progress from serve
//        QuestionFlowManager.shared.ref.child("Users").child(self.user!.userId).child("progress").observeSingleEvent(of: .value, with: { (snapshot) in
//                 // Get user value
//                   if let value = snapshot.value as? String {
//                    print("check:: ",value)
//                       if let data = value.data(using: String.Encoding.utf8) {
//                           do {
//                               let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//
//                            self.user!.learningProgress = json as! LearningProgress
//                           } catch  {
//                               print("things went wrong, contact Minh Nguye")
//                           }
//                       }
//                   }
//                 // ...
//                 }) { (error) in
//                   print(error.localizedDescription)
//               }
       
    }
    func updateDataWhenAppKilled() {
        do {
      
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.user!, requiringSecureCoding: false)
            self.defaults.removeObject(forKey: "userInfo")
            self.defaults.set(data, forKey: "userInfo")
            
            let settingData = try NSKeyedArchiver.archivedData(withRootObject: self.setting!, requiringSecureCoding: false)
            self.defaults.removeObject(forKey: "settingInfo")
            self.defaults.set(settingData, forKey: "settingInfo")
            
            let jsonData = try! JSONSerialization.data(withJSONObject: self.user?.learningProgress as Any, options: [])
            let jsonStr = String(data: jsonData, encoding: .utf8)
        QuestionFlowManager.shared.ref.child("/Users").child(self.user!.userId).child("progress").setValue(jsonStr)
            
        } catch {
            print("contact minh nguyen immediately")
        }
        
    }
    
}


class SettingInfo : NSObject, NSCoding {
    var voiceType : VoiceType = VoiceType.waveNetFemale
    let voiceArray = ["en-US-Wavenet-F","en-US-Wavenet-D"]
    
    func encode(with coder: NSCoder) {
        
        var voiceType = "en-US-Wavenet-F"
        if self.voiceType == VoiceType.waveNetMale {
            voiceType = "en-US-Wavenet-D"
        }
        coder.encode(voiceType, forKey: "voiceType")
        
    }
    
    required init?(coder: NSCoder) {
        if let voiceType = coder.decodeObject(forKey: "voiceType") as? String {
            if voiceType == "en-US-Wavenet-F" {
                self.voiceType = VoiceType.waveNetFemale
            } else {
                self.voiceType = VoiceType.waveNetMale
            }
        }
    }
    override init() {
        super.init()
    }
}
