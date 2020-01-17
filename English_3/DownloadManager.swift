//
//  DownloadManager.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 1/15/20.
//  Copyright © 2020 Minh Nguyen's Mac. All rights reserved.
//

import Foundation

extension UIImageView {
    func setFireBaseImageWithUrl(url : String) {
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        FirebaseDownloadManager.shared.downloadImageForUrl(url: url, completion: {
            image, error in
            if let image = image {
                self.image = image
                self.backgroundColor = UIColor.clear
            }
        })
    }
    
    
    func setFireBaseImageWithUrl(url: String, placeHolder: UIImage?) {
        if let placeHolder = placeHolder {
            self.image = placeHolder
        } else {
            self.image = UIImage(named: "placeholder.png")
        }
        
        FirebaseDownloadManager.shared.downloadImageForUrl(url: url, completion: {
            image, error in
            if let image = image {
                self.image = image
                self.backgroundColor = UIColor.clear
            }
        })
    }
}

class FirebaseDownloadManager {
    static let shared = FirebaseDownloadManager()
    
    var cachedDic = Dictionary<String,UIImage>()
    var downloader = Downloader.init()
    var serialQueue = DispatchQueue(label: "FirebaseDownloadQueue")
    
    func downloadImageForUrl(url:String, completion:@escaping DownloadPhotoCompletion) {
        serialQueue.async {
            if let photo = self.cachedDic[url] {
                DispatchQueue.main.async {
                    completion(photo,nil)
                }
                
            } else {
                self.downloader.downloadFirebasePhotoWithUrl(url: url, completion: {
                    image, error in
                    
                    
                    if let image = image {
                        self.cachedDic[url] = image
                    }
                        DispatchQueue.main.async {
                            completion(image,error)
                        }
                })
            }
        }
        
    }
    
}

typealias DownloadPhotoCompletion = (UIImage?,Error?) -> ()

class Downloader {
    var downloadingDic = Dictionary<String, Array<DownloadPhotoCompletion>>.init()
    
    func downloadFirebasePhotoWithUrl(url : String, completion:@escaping DownloadPhotoCompletion) {
        if var handlers = downloadingDic[url] {
            handlers.append(completion)
            downloadingDic[url] = handlers
            return
        } else {
            downloadingDic[url] = [completion]
        }
        
        
        let storageRef = QuestionFlowManager.shared.storage.reference()
        let photoRef = storageRef.child(url)
        photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            self.updateDownloadingDic(url:url, image: nil, error: error)
          } else {
            // Data for "images/island.jpg" is returned
            if let image = UIImage(data: data!) {
                self.updateDownloadingDic(url: url, image: image, error: nil)
            }
          }
        }
    }
    
    func updateDownloadingDic( url : String, image: UIImage?, error:Error?) {
        if let handlers = downloadingDic[url] {
            for handler in handlers {
                handler(image,error)
            }
        }
    }
}
