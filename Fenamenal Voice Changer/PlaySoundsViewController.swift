//
//  StopWatch.swift
//  Fenamenal Voice Changer
//
//  Created by Jonathan Ferrer on 2/18/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//
//
//  PlaySoundsViewController.swift
//  Voice Changer Libre
//
//  Created by Luis on 2/8/18.
//

import UIKit
import AVFoundation
import AudioKit
import AudioKitUI


enum State {
       case readyToRecord
       case recording
       case readyToPlay
       case playing

   }

class RecordAudioViewController: UIViewController {

    var micMixer: AKMixer!
    var recorder: AKNodeRecorder!
    var player: AKPlayer!
    var tape: AKAudioFile!
    var micBooster: AKBooster!
    var moogLadder: AKMoogLadder!
    var mainMixer: AKMixer!

    let mic = AKMicrophone()
    var state = State.readyToRecord




    @IBOutlet weak var outputPlot: AKNodeOutputPlot?
    @IBOutlet weak var recordPlayButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        outputPlot?.node = mic

        setupUIForRecording()

    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Clean tempFiles !
        AKAudioFile.cleanTempDirectory()

        // Session settings
        AKSettings.bufferLength = .medium
        
        do {
            try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)
        } catch {
            AKLog("Could not set session category.")
        }
        
        AKSettings.defaultToSpeaker = true

        // Patching
        let monoToStereo = AKStereoFieldLimiter(mic, amount: 1)
        micMixer = AKMixer(monoToStereo)
        micBooster = AKBooster(micMixer)

        // Will set the level of microphone monitoring
        micBooster.gain = 0
        recorder = try? AKNodeRecorder(node: micMixer)
        if let file = recorder.audioFile {
            player = AKPlayer(audioFile: file)
        }
        player.isLooping = true
        player.completionHandler = playingEnded

        moogLadder = AKMoogLadder(player)
        
        mainMixer = AKMixer(moogLadder, micBooster)

        AudioKit.output = mainMixer
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }
    @IBAction func recordPlayButtonPressed(_ sender: UIButton) {

        switch state {
               case .readyToRecord :
                   navigationController?.title = "Recording"
                   recordPlayButton.setBackgroundImage(UIImage(systemName: "stop.fill"), for: .normal)
                   state = .recording
                   // microphone will be monitored while recording
                   // only if headphones are plugged
                   if AKSettings.headPhonesPlugged {
                       micBooster.gain = 1
                   }
                   do {
                       try recorder.record()
                   } catch { AKLog("Errored recording.") }

               case .recording :
                   // Microphone monitoring is muted
                   micBooster.gain = 0
                   tape = recorder.audioFile!
                   player.load(audioFile: tape)

                   if let _ = player.audioFile?.duration {
                       recorder.stop()
                       tape.exportAsynchronously(name: "TempTestFile.m4a",
                                                 baseDir: .documents,
                                                 exportFormat: .m4a) {_, exportError in
                           if let error = exportError {
                               AKLog("Export Failed \(error)")
                           } else {
                               AKLog("Export succeeded")
                           }
                       }
                       setupUIForPlaying()
                   }
               case .readyToPlay :
                   player.play()
                    navigationController?.title = "Playing..."
                   recordPlayButton.setBackgroundImage(UIImage(systemName: "stop.fill"), for: .normal)
                   state = .playing
                   outputPlot?.node = player
                   print(tape.url.absoluteString)

               case .playing :
                   player.stop()
                   setupUIForPlaying()
                   outputPlot?.node = mic
               }

    }



    func playingEnded() {
        DispatchQueue.main.async {
            self.setupUIForPlaying ()
        }
    }


    func setupUIForPlaying () {
        let recordedDuration = player != nil ? player.audioFile?.duration  : 0
        recordPlayButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        state = .readyToPlay
        navigationController?.title = String(recordedDuration!)
       }

    func setupUIForRecording () {
        state = .readyToRecord
        navigationController?.title = "Ready to record"
        recordPlayButton.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        micBooster.gain = 0
    }

}
