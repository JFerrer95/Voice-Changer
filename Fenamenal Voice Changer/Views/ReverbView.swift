//
//  ReverbView.swift
//  Fenamenal Voice Changer
//
//  Created by jonathan ferrer on 2/26/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

protocol ReverbDelegate {
    func reverbEnableToggle()
    func reverbWetDryChanged(value: Double)
}

class ReverbView: UIView {


    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var isActiveButton = UIButton()
    var slider = AKSlider(property: "Reverb")
    var delegate: ReverbDelegate?
    var preset: Preset?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setupViews()
        
        
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    func setupViews() {
        self.backgroundColor = .systemTeal
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemBlue.cgColor
        
            
            self.isActiveButton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: 100, height: 50))
            self.isActiveButton.setTitle("Enabled", for: .normal)
            self.isActiveButton.backgroundColor = .systemBlue
            self.isActiveButton.addTarget(self, action: #selector(self.isActiveButtonAction), for: .touchUpInside)
            
            self.addSubview(self.isActiveButton)
            
            // TODO -
            addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.topAnchor.constraint(equalTo: isActiveButton.bottomAnchor, constant: 20).isActive = true
        slider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        slider.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        slider.heightAnchor.constraint(equalTo: isActiveButton.heightAnchor).isActive = true


        slider.range = 0.0...1
        slider.value = 0.5
        slider.callback = sliderChanged
        
    }
    

    
    func sliderChanged(value: Double) {
        preset?.reverb.dryWet = value
        delegate?.reverbWetDryChanged(value: value)
    }
    
    
    

    @objc func isActiveButtonAction(sender: UIButton!) {
        delegate?.reverbEnableToggle()
    }

}
