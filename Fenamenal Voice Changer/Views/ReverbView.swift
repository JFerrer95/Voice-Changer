//
//  ReverbView.swift
//  Fenamenal Voice Changer
//
//  Created by jonathan ferrer on 2/26/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit

protocol ReverbDelegate {
    func reverbEnableToggle()
    func reverbWetDryChanged(vlaue: Float)
}

class ReverbView: UIView {


    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var isActiveButton = UIButton()
    var slider = UISlider()
    var delegate: ReverbDelegate?
    
    
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
            
            self.slider = UISlider()
            self.slider.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.slider)
            self.slider.topAnchor.constraint(equalTo: self.isActiveButton.bottomAnchor, constant: 20).isActive = true
            self.slider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            self.slider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
            self.slider.minimumValue = 0
            self.slider.maximumValue = 1
            self.slider.value = 0.5
            self.slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        
    }
    
    
    
   @objc func sliderChanged() {
        delegate?.reverbWetDryChanged(vlaue: slider.value)
    }
    
    
    

    @objc func isActiveButtonAction(sender: UIButton!) {
        delegate?.reverbEnableToggle()
    }

}
