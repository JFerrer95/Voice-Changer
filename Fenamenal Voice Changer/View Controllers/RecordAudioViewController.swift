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
    var mainMixer: AKMixer!

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
        mainMixer = AKMixer(delay, micBooster)

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
                   setupUIForPlaying()
                   outputPlot?.node = mic
               }

    }



    func playingEnded() {
        DispatchQueue.main.async {
       
            self.recordPlayButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
            self.state = .readyToPlay
            

        }
    }
    



    func setupUIForPlaying () {
        let recordedDuration = player != nil ? player.audioFile?.duration  : 0
        recordPlayButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        state = .readyToPlay
        navigationController?.title = String(recordedDuration!)
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
            self.effectsPanel.delayDelegate = self
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
        }
          
    }



}

extension RecordAudioViewController: DelayDelegate {
    func delayEnableToggle() {
        if preset.delay.isActive == true {
            delay.bypass()
            
        } else {
            delay.start()
        }
        
    }
    
    
}

extension RecordAudioViewController: ReverbDelegate {
    func reverbTypeChanged(index: Int) {
        
        switch index {
        case 0:
            reverb.loadFactoryPreset(.cathedral)
        case 1:
            reverb.loadFactoryPreset(.largeHall)
        case 2:
            reverb.loadFactoryPreset(.largeHall2)
        case 3:
            reverb.loadFactoryPreset(.largeRoom)
        case 4:
            reverb.loadFactoryPreset(.largeRoom2)
        case 5:
            reverb.loadFactoryPreset(.mediumChamber)
        case 6:
            reverb.loadFactoryPreset(.mediumHall)
        case 7:
            reverb.loadFactoryPreset(.mediumHall2)
        case 8:
            reverb.loadFactoryPreset(.mediumHall3)
        case 9:
            reverb.loadFactoryPreset(.mediumRoom)
        case 10:
            reverb.loadFactoryPreset(.plate)
        case 11:
            reverb.loadFactoryPreset(.smallRoom)
        default:
            reverb.loadFactoryPreset(.cathedral)
        }
    }
    
    func reverbEnableToggle() {
      if preset.reverb.isActive == true {
        reverb.bypass()
          } else {
        reverb.start()
      }
    }
    
    func reverbWetDryChanged(value: Double) {
        if preset.reverb.isActive {
            reverb.dryWetMix = preset.reverb.dryWet
        }

    }
    
    
    
    
}


