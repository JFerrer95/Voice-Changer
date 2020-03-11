//
//  Preset.swift
//  Fenamenal Voice Changer
//
//  Created by Jonathan Ferrer on 2/24/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import Foundation
import AudioKit

class Preset {
    var reverb: Reverb
    var delay: Delay
    var pitchShift: PitchShift
    init() {
        reverb = Reverb()
        delay = Delay()
        pitchShift = PitchShift()
    }

}

class PitchShift {
    var isActive: Bool
    var shift: Double
    
    init(isActive: Bool = false, shift: Double = 0.0) {
        self.isActive = isActive
        self.shift = shift
    }
}

class Delay {
    var isActive: Bool
    var time: Double
    var dryWet: Double
    
    init(isActive: Bool = false, time: Double = 1.0, dryWet: Double = 0.5) {
        self.isActive = isActive
        self.time = time
        self.dryWet = dryWet
    }
}

class Reverb {
    var isActive: Bool
    var reverbPreset: String
    var dryWet: Double
    let reverbPresets = ["Cathedral", "Large Hall", "Large Hall 2",
    "Large Room", "Large Room 2", "Medium Chamber",
    "Medium Hall", "Medium Hall 2", "Medium Hall 3",
    "Medium Room", "Plate", "Small Room"]

    init(isActive: Bool = false, reverbPreset: String = ReverbPreset.cathedral.rawValue, dryWet: Double = 0.5) {
        self.isActive = isActive
        self.reverbPreset = reverbPreset
        self.dryWet = dryWet
    }
}

enum ReverbPreset: String {

       case cathedral
       case largeHall
       case largeHall2
       case largeRoom
       case largeRoom2
       case mediumChamber
       case mediumHall
       case mediumHall2
       case mediumHall3
       case mediumRoom
       case plate
       case smallRoom
   }
