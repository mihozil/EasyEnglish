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
    weak var questionViewController : MultiSelectionQuestionsViewController?
    
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
       
    }
    func updateDataWhenAppKilled() {
        do {
      
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.user!, requiringSecureCoding: false)
            self.defaults.removeObject(forKey: "userInfo")
            self.defaults.set(data, forKey: "userInfo")
            
            let settingData = try NSKeyedArchiver.archivedData(withRootObject: self.setting!, requiringSecureCoding: false)
            self.defaults.removeObject(forKey: "settingInfo")
            self.defaults.set(settingData, forKey: "settingInfo")
            
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
