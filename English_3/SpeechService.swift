//
//  SpeechService.swift
//  English_3
//
//  Created by Minh Nguyen's Mac on 12/24/19.
//  Copyright © 2019 Minh Nguyen's Mac. All rights reserved.
//

import Foundation
import AVFoundation

enum VoiceType: String {
    case undefined
    case waveNetFemale = "en-US-Wavenet-F"
    case waveNetMale = "en-US-Wavenet-D"
    case standardFemale = "en-US-Standard-E"
    case standardMale = "en-US-Standard-D"
}

let ttsAPIUrl = "https://texttospeech.googleapis.com/v1beta1/text:synthesize"
let APIKey = "AIzaSyCsIm1vzix3hKPfrQBmytFINGOhx_SNqTc"

class SpeechService : NSObject, AVAudioPlayerDelegate {
    static let shared = SpeechService()
    var busy : Bool = false {
        didSet {
            if !self.busy {
                if let handler = self.blockImlementOnSpeechCompletion {
                    handler()
                    self.blockImlementOnSpeechCompletion = nil
                }
            }
        }
    }
    private var player : AVAudioPlayer?
    private var completionHandler: (()->Void)?
    
    var blockImlementOnSpeechCompletion : (()->Void)?
    
    func speak(text: String, voiceType: VoiceType = UserManager.shared.setting!.voiceType, completion: @escaping () -> Void) {
//        #if DEBUG
//        completion()
//        if let handler = self.completionHandler {
//            handler()
//            self.completionHandler = nil
//        }
//        return
//        #endif
        guard !self.busy else {
            print("Speech Service busy!")
            return
        }
        
        self.busy = true
        
        DispatchQueue.global(qos: .background).async {
            let postData = self.buildPostData(text: text, voiceType: voiceType)
            let headers = ["X-Goog-Api-Key": APIKey, "Content-Type": "application/json; charset=utf-8"]
            let response = self.makePOSTRequest(url: ttsAPIUrl, postData: postData, headers: headers)

            // Get the `audioContent` (as a base64 encoded string) from the response.
            guard let audioContent = response["audioContent"] as? String else {
                print("Invalid response: \(response)")
                self.busy = false
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            // Decode the base64 string into a Data object
            guard let audioData = Data(base64Encoded: audioContent) else {
                self.busy = false
                
                return
            }
            
            DispatchQueue.main.async {
                self.completionHandler = completion
                self.player = try! AVAudioPlayer(data: audioData)
                self.player?.delegate = self
                self.player!.play()
            }
        }
    }
    
    func cancelSpeaking() {
        self.player?.stop()
        
        self.player?.delegate = nil
        self.player = nil
        self.busy = false
    }
    
    private func buildPostData(text: String, voiceType: VoiceType) -> Data {
        
        var voiceParams: [String: Any] = [
            // All available voices here: https://cloud.google.com/text-to-speech/docs/voices
            "languageCode": "en-US"
        ]
        
        if voiceType != .undefined {
            voiceParams["name"] = voiceType.rawValue
        }
        
        let params: [String: Any] = [
            "input": [
                "text": text
            ],
            "voice": voiceParams,
            "audioConfig": [
                // All available formats here: https://cloud.google.com/text-to-speech/docs/reference/rest/v1beta1/text/synthesize#audioencoding
                "audioEncoding": "LINEAR16"
            ]
        ]

        // Convert the Dictionary to Data
        let data = try! JSONSerialization.data(withJSONObject: params)
        return data
    }
    
    // Just a function that makes a POST request.
    private func makePOSTRequest(url: String, postData: Data, headers: [String: String] = [:]) -> [String: AnyObject] {
        var dict: [String: AnyObject] = [:]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        // Using semaphore to make request synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                dict = json
            }
            
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return dict
    }
    
    // Implement AVAudioPlayerDelegate "did finish" callback to cleanup and notify listener of completion.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player?.delegate = nil
        self.player = nil
        self.busy = false
        
        if let handler = self.completionHandler {
            handler()
            self.completionHandler = nil
        }
    }
    
    
    
    func playFileName(name : String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { return }
        guard !self.busy else {
            print("service busy")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            
            self.busy = true
            
            player?.volume = 0.5
            
            player!.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

