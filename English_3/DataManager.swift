
//
//  DataManager.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/21/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

class DataManager : NSObject {
 
    class func fetchLessonWithId(lessonId : Int, unitId: Int)->Array<QuestionModel> {
        let fileName = String(format: "Lesson_%d_%d",unitId, lessonId)
        if let path = Bundle.main.path(forResource: fileName, ofType: nil) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe)
                return self.fetchLessonData(data: data)
                
                
            } catch {
                print("contact Minh Nguyen for the issue")
            }
        }
        return []
    }
    
    class func fetchLessonData(data : Data)->Array<QuestionModel> {
        do {
            let jsonDic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonDic = jsonDic as? Dictionary<String,AnyObject> {
                
                if let questions = jsonDic["questions"] as? Array<Dictionary<String, AnyObject>> {
                    let questionModels : NSMutableArray = NSMutableArray.init()
                    for question in questions  {
                        var idx : Int = -1
                        if let idxStr = question["idx"] as? String {
                            idx = Int(idxStr)!
                        }
                        
                        var type = -1
                        if let typeStr = question["type"] as? String {
                            type = Int(typeStr)!
                        }
                        
                        var texts : Array<String> = []
                        if let textsArr = question["texts"] as? Array<String> {
                            texts = textsArr
                        }
                        
                        var thumbs : Array<String> = []
                        if let thumbsArr = question["thumbs"] as? Array<String> {
                            thumbs = thumbsArr
                        }
                        
                        var ans = -1
                        if let ansStr = question["answer"] as? String {
                            ans = Int(ansStr)!
                        }
                        
                        var tip : String = "No tip"
                        if let tip1 = question["tip"] as? String {
                            tip = tip1
                        }
                        
                        let questionModel : QuestionModel = QuestionModel.init(idx: idx, type: type, texts: texts, thumbs: thumbs, answer: ans, tip: tip)
                        questionModels.add(questionModel)
                    
                    }
                    return questionModels.copy() as! Array<QuestionModel>
                }
            }
        } catch  {
            print("contact minh nguyen sooner")
        }
            
        return []
    }
    
    class func fetchUnitWithId(unitId: Int) -> Array<LessonModel> {
        let unitName = String(format: "Unit_%d", unitId)
        if let path = Bundle.main.path(forResource: unitName, ofType: nil) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return self.fetchUnitData(data: data)
            } catch  {
            
            }
        }
        return []
    }
    
    class func fetchUnitData(data : Data)-> Array<LessonModel> {
        do {
                       
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                
                let lessonModels = NSMutableArray.init()
                
                if let lessons = jsonResult["lessons"] as? Array<Dictionary<String, AnyObject>> {
                    for lesson in lessons {
                        var lessonID = -1
                        if let idString = lesson["lessonId"] as? String {
                            lessonID = Int(idString)!
                        }
                        
                        var thumb : String = ""
                        if let thumbString = lesson["thumb"] as? String {
                            thumb = thumbString
                        }
                        
                        var title : String = ""
                        if let titleString = lesson["title"] as? String {
                            title = titleString
                        }
                        
                        var detail : String = ""
                        if let detailString = lesson["detail"] as? String {
                            detail = detailString
                        }
                        
                        var total = 0
                        if let totalStr = lesson["totalQuestion"] as? String {
                            total = Int(totalStr)!
                        }
                        
                        let lessonModel : LessonModel = LessonModel.init(lessonId: lessonID, thumb: thumb, title: title, detail: detail,totalQuestion: total)
                        lessonModels.add(lessonModel)
                    }
                }
                
                return lessonModels.copy() as! Array<LessonModel>
                
            }
        }
        catch {
            print("contact Minh Nguyen")
        }
        return []
                   
    }
    
    class func fetchAllUnits() -> Array<UnitModel> {
        
        let name = "units"
        if let path = Bundle.main.path(forResource: name, ofType: nil) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return self.fetchAllUnitsData(data: data)
            } catch  {
                print("contact Minh Nguyen soon ")
            }
        }
        return []
    }
    class func fetchAllUnitsData(data : Data)-> Array<UnitModel> {
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! Dictionary<String, Array<Dictionary<String, Any>>>
            if let units = json["units"] {
                
                var models: Array = Array<UnitModel>.init()
                
                for unit in units {
                    let unitid = unit["unitId"] as! Int
                    let unitTitle = unit["title"] as! String
                    let unitDesc = unit["desc"] as! String
                    let thumb = unit["thumb"] as! String
                    let totalLessons = unit["totalLessons"] as! Int

                    let model = UnitModel(thumb: thumb, title: unitTitle, unitId: unitid, desc: unitDesc, totalLesson: totalLessons)
                    
                    models.append(model)

                    
                }
                return models
            }
        }
        catch {
            print("contact Mihozil")
        }
        return []
    }
    
    typealias FetchAllUnitCompletion = (Array<UnitModel>) -> ()
    class func fetchAllUnitFirebase(completion:@escaping FetchAllUnitCompletion) {
        if let cachedData = self.findCachedData(path: "units") as? Array<UnitModel>{
            completion(cachedData)
            return
        }
        
        FirebaseDownloadManager.shared.downloadDataForUrl(url: "units", completion: {
            data, error in
            if let data = data {
                let allunits = self.fetchAllUnitsData(data: data)
                completion(allunits)
                QuestionFlowManager.shared.cacheData.setValue(allunits, forKey: "units")
            } else {
                completion([])
            }
        })
    }
    typealias FetchUnitCompletion = (Array<LessonModel>) -> ()
    class func fetchUnitWithFirebase(unitId: Int, completion :@escaping FetchUnitCompletion) {
        let unitName = String(format: "Unit_%d", unitId)
        
        if let cachedData = self.findCachedData(path: unitName) as? Array<LessonModel>{
            completion(cachedData)
            return
        }
        
        FirebaseDownloadManager.shared.downloadDataForUrl(url: unitName, completion: {
            data, error in
            if let data = data {
                let allLessons = self.fetchUnitData(data: data)
                completion(allLessons)
                QuestionFlowManager.shared.cacheData.setValue(allLessons, forKey: unitName)
            } else {
                completion([])
            }
        })
    }
    typealias FetchLessonCompletion = (Array<QuestionModel>) -> ()
    class func fetchLessonWithFirebase(lessonId: Int, unitId: Int, completion:@escaping FetchLessonCompletion) {
        let fileName = String(format: "Lesson_%d_%d",unitId, lessonId)
        
        if let cachedData = self.findCachedData(path: fileName) as? Array<QuestionModel>{
            completion(cachedData)
            return
        }
        
        FirebaseDownloadManager.shared.downloadDataForUrl(url: fileName, completion: {
            data, error in
            if let data = data {
                let allQuestions = self.fetchLessonData(data: data)
                completion(allQuestions)
                QuestionFlowManager.shared.cacheData.setValue(allQuestions, forKey: fileName)
            } else {
                completion([])
            }
            
        })
    }
    
    class func findCachedData(path:String) -> Any? {
        if let data = QuestionFlowManager.shared.cacheData.value(forKey: path) {
            return data
        } else {
            return nil
        }
    }
    
}
