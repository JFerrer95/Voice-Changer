//
//  PitchShiftView.swift
//  Fenamenal Voice Changer
//
//  Created by jonathan ferrer on 3/10/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit
import AudioKitUI

protocol PitchShiftDelegate {
    func pitchShiftEnableToggle()
    func pitchShiftAmount(semitones: Double)
}



class PitchShiftView: UIView {

       var isActiveButton = UIButton()
        var delegate: PitchShiftDelegate?
        var semitonesSlider = AKSlider(property: "Semitones")
        var dryWetSlider = AKSlider(property: "Dry/Wet")
        var preset: Preset? {
           didSet {
                setupViews()
            
           }
        }
        
        
        func setupViews() {
            backgroundColor = .systemTeal
            layer.borderWidth = 5
            layer.borderColor = UIColor.systemBlue.cgColor
            
            isActiveButton = UIButton()
            changeActive()
            
            isActiveButton.addTarget(self, action: #selector(self.isActiveButtonAction), for: .touchUpInside)
            addSubview(isActiveButton)
            isActiveButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                isActiveButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                isActiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width / 3),
                isActiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 3),
                isActiveButton.heightAnchor.constraint(equalToConstant: frame.height / 3)
            ])
            
            addSubview(semitonesSlider)
            semitonesSlider.range = -12...12
            if let value = preset?.pitchShift.shift {
                semitonesSlider.value = value
            } else {
                semitonesSlider.value = 0
            }
            semitonesSlider.callback = semitonesChanged
            semitonesSlider.color = preset!.reverb.isActive ? UIColor.green : UIColor.red
            semitonesSlider.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                semitonesSlider.topAnchor.constraint(equalTo: isActiveButton.bottomAnchor, constant: 20),
                semitonesSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width / 3),
                semitonesSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 3),
                semitonesSlider.heightAnchor.constraint(equalTo: isActiveButton.heightAnchor, multiplier: 2)
            ])
            
            
         
            
            
            }
    
    func semitonesChanged(value: Double) {
        preset?.pitchShift.shift = value
        delegate?.pitchShiftAmount(semitones: value)
    }
        
        
  
        
        func changeActive() {
            if preset?.pitchShift.isActive == true {
                
                isActiveButton.setTitle("Active", for: .normal)
                isActiveButton.backgroundColor = .systemGreen
            } else {
              
                isActiveButton.setTitle("Inactive", for: .normal)
                isActiveButton.backgroundColor = .systemRed
            }
        }
        
        @objc func isActiveButtonAction() {
            delegate?.pitchShiftEnableToggle()
                   
                   if preset?.pitchShift.isActive == true {
                       preset?.pitchShift.isActive = false
    //                   slider.color = .systemRed
                       changeActive()
                   } else {
                       preset?.pitchShift.isActive = true
    //                   slider.color = .systemGreen
                       changeActive()
                   }
        }
        

    }
