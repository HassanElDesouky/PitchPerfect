//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Hassan El Desouky on 11/29/17.
//  Copyright © 2017 Hassan El Desouky. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    //
    var audioRecorder : AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Recording audio button
    
    @IBAction func recordAudio(_ sender: Any) {
        
        // MARK: Record 3D Touch
        
        if let bundleID = Bundle.main.bundleIdentifier {
            
            
            let type = bundleID + ".Record"
            let icon = UIApplicationShortcutIcon(templateImageName: "RecordButton")
            
            let newQuickAction = UIApplicationShortcutItem(type: type, localizedTitle: "Record", localizedSubtitle: nil, icon: icon, userInfo: nil)
            var existingShortcutItems = UIApplication.shared.shortcutItems ?? [newQuickAction]
            print(existingShortcutItems)
            
            if !existingShortcutItems.contains(newQuickAction) {
                
                existingShortcutItems.append(newQuickAction)
                UIApplication.shared.shortcutItems = existingShortcutItems
                
            }
            
        } else {
            print("bundle Id is missing")
        }

        
        // MARK: Calling the recording func
        
        recordingAudio()

    }
    
    // MARK: Stop recording button
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLable.text = "Tap to Record"
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
    
    // MARK: Passing data for the next view
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordAudioVC = sender as! URL
            playSoundVC.recordedAudioURL = recordAudioVC
        }
    }
    
    // MARK: Recording audio function
    
    func recordingAudio() {
        recordingLable.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
}

