//
//  DelayView.swift
//  Fenamenal Voice Changer
//
//  Created by jonathan ferrer on 3/3/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit
import AudioKitUI

protocol DelayDelegate {
    func delayEnableToggle()
    func delayTimeChanged(value: Double)
    func delayDryWetChanged(value: Double)
}


class DelayView: UIView {
    var isActiveButton = UIButton()
    var delegate: DelayDelegate?
    var timeSlider = AKSlider(property: "Time (sec)")
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
        
        
        addSubview(timeSlider)
        timeSlider.range = 0.0...2.5
           if let value = preset?.reverb.dryWet {
               timeSlider.value = value
           } else {
            timeSlider.value = 1.0
           }
           timeSlider.callback = timeSliderChanged
           timeSlider.color = preset!.reverb.isActive ? UIColor.green : UIColor.red
           timeSlider.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               timeSlider.topAnchor.constraint(equalTo: isActiveButton.bottomAnchor, constant: 20),
               timeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width / 3),
               timeSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 3),
               timeSlider.heightAnchor.constraint(equalTo: isActiveButton.heightAnchor, multiplier: 2)
           ])
        
        addSubview(dryWetSlider)
        dryWetSlider.range = 0.0...1
        if let value = preset?.reverb.dryWet {
            dryWetSlider.value = value
        } else {
            dryWetSlider.value = 0.5
        }
        dryWetSlider.callback = dryWetSliderChanged
        dryWetSlider.color = preset!.reverb.isActive ? UIColor.green : UIColor.red
        dryWetSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dryWetSlider.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 20),
            dryWetSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width / 3),
            dryWetSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 3),
            dryWetSlider.heightAnchor.constraint(equalTo: isActiveButton.heightAnchor, multiplier: 2)
        ])
        
        
        }
    
    
    func timeSliderChanged(value: Double) {
        delegate?.delayTimeChanged(value: value)
        preset?.delay.time = value
        
    }
    
    func dryWetSliderChanged(value: Double) {
        delegate?.delayDryWetChanged(value: value)
        preset?.delay.dryWet = value
    }
    
    
    func changeActive() {
        if preset?.delay.isActive == true {
            
            isActiveButton.setTitle("Active", for: .normal)
            isActiveButton.backgroundColor = .systemGreen
        } else {
          
            isActiveButton.setTitle("Inactive", for: .normal)
            isActiveButton.backgroundColor = .systemRed
        }
    }
    
    @objc func isActiveButtonAction() {
        delegate?.delayEnableToggle()
               
               if preset?.delay.isActive == true {
                   preset?.delay.isActive = false
//                   slider.color = .systemRed
                   changeActive()
               } else {
                   preset?.delay.isActive = true
//                   slider.color = .systemGreen
                   changeActive()
               }
    }
    

}
