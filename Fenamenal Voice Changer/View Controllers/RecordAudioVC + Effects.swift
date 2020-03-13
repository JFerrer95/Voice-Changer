//
//  RecordAudioVC + Effects.swift
//  Fenamenal Voice Changer
//
//  Created by jonathan ferrer on 3/11/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import Foundation

extension RecordAudioViewController: PitchShiftDelegate {
    func pitchShiftAmount(semitones: Double) {
        if preset.pitchShift.isActive == true {
            pitchShifter.shift = semitones
        }
    }
    
    func pitchShiftEnableToggle() {
        if preset.pitchShift.isActive == true {
            pitchShifter.bypass()
            
        } else {
            pitchShifter.start()
        }
    }
    
    
}

extension RecordAudioViewController: DelayDelegate {
    func delayDryWetChanged(value: Double) {
        delay.dryWetMix = value
    }
    
    func delayTimeChanged(value: Double) {
        delay.time = TimeInterval(value)
    }
    
    func delayEnableToggle() {
        if preset.delay.isActive == true {
            delay.bypass()
            
        } else {
            delay.start()
        }
        
    }
    
    
}

extension RecordAudioViewController: ReverbDelegate, ReverbEnableDelegate {
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
    
    @objc func reverbWetDryChanged(value: Double) {
        if preset.reverb.isActive {
            reverb.dryWetMix = preset.reverb.dryWet
        }

    }
    
    
    
    
}
