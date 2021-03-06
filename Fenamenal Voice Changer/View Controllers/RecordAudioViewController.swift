//
//  StopWatch.swift
//  Fenamenal Voice Changer
//
//  Created by Jonathan Ferrer on 2/18/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
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

class RecordAudioViewController: UIViewController{

    var micMixer: AKMixer!
    var recorder: AKNodeRecorder!
    var player: AKPlayer!
    var tape: AKAudioFile!
    var micBooster: AKBooster!
    var reverb: AKReverb!
    var delay: AKDelay!
    var pitchShifter: AKPitchShifter!
    var mainMixer: AKMixer!
    var didPlay = false

    let mic = AKMicrophone()
    var state = State.readyToRecord
    var effectsPanel = EffectsPanel()
    var preset = Preset()

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

        reverb = AKReverb(player)
        reverb.stop()
        delay = AKDelay(reverb)
        delay.stop()
        
        pitchShifter = AKPitchShifter(delay)
        pitchShifter.stop()
        mainMixer = AKMixer(pitchShifter, micBooster)

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
                   recordPlayButton.setBackgroundImage(UIImage(systemName: "stop"), for: .normal)
                   state = .playing
                   outputPlot?.node = player
                   print(tape.url.absoluteString)

               case .playing :
                   player.stop()
                   
                   if didPlay {
                    
                    setupUIForPlaying()
                    didPlay = false
                   }
                   playingEnded()
                   outputPlot?.node = mic
               }

    }

    

    func playingEnded() {
        DispatchQueue.main.async {
       
            let recordedDuration = self.player != nil ? self.player.audioFile?.duration  : 0
            self.recordPlayButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
            self.state = .readyToPlay
            self.navigationController?.title = String(recordedDuration!)

        }
    }
    



    func setupUIForPlaying () {
        playingEnded()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: nil)
        
        self.effectsPanel.preset = self.preset
        UIView.animate(withDuration: 0.5, animations: {
            self.recordPlayButton.translatesAutoresizingMaskIntoConstraints = false
            self.outputPlot?.translatesAutoresizingMaskIntoConstraints = false
            self.effectsPanel.translatesAutoresizingMaskIntoConstraints = false
            self.recordPlayButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            self.outputPlot?.bottomAnchor.constraint(equalTo: self.recordPlayButton.topAnchor, constant: -20).isActive = true
            
            self.view.backgroundColor = .black
           
            self.effectsPanel.reverbDelegate = self
            self.effectsPanel.reverbView.delegate = self
            self.effectsPanel.delayDelegate = self
            self.effectsPanel.pitchShiftDelegate = self
            self.view.layoutIfNeeded()
            
        })
       }

    func setupUIForRecording () {
        state = .readyToRecord
        navigationController?.title = "Ready to record"
        recordPlayButton.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        micBooster.gain = 0
        effectsPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effectsPanel)
        effectsPanel.bottomAnchor.constraint(equalTo: outputPlot?.topAnchor ?? view.bottomAnchor, constant: -20).isActive = true
        effectsPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        effectsPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        effectsPanel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        

    }
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch: UITouch = touches.first
            else { return }
        let location = touch.location(in: view)
        if !effectsPanel.frame.contains(location) {
            effectsPanel.reverbView.isHidden = true
            effectsPanel.delayView.isHidden = true
            effectsPanel.pitchShiftView.isHidden = true
        }
          
    }



}



