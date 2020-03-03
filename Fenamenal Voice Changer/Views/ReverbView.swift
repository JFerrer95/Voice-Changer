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
    var reverbTypeButton = UIButton()
    var slider = AKSlider(property: "Reverb")
    var delegate: ReverbDelegate?
    var preset: Preset? {
        didSet {
            setupViews()
        }
    }
    
    var tableView: UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        
        
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    func setupViews() {
        backgroundColor = .systemTeal
        layer.borderWidth = 5
        layer.borderColor = UIColor.systemBlue.cgColor
        
        
        isActiveButton = UIButton()
        isActiveButton.setTitle("Enabled", for: .normal)
        isActiveButton.backgroundColor = .systemBlue
        isActiveButton.addTarget(self, action: #selector(self.isActiveButtonAction), for: .touchUpInside)
        addSubview(isActiveButton)
        isActiveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            isActiveButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            isActiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width / 3),
            isActiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 3),
            isActiveButton.heightAnchor.constraint(equalToConstant: frame.height / 3)
        ])
        
            
        
        addSubview(slider)
        slider.range = 0.0...1
        slider.value = 0.5
        slider.callback = sliderChanged
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: isActiveButton.bottomAnchor, constant: 20),
            slider.widthAnchor.constraint(equalTo: widthAnchor, constant: -20 ),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.heightAnchor.constraint(equalTo: isActiveButton.heightAnchor, multiplier: 2)
        ])
       


        
        
        reverbTypeButton = UIButton()
        reverbTypeButton.setTitle(preset?.reverb.reverbPreset.rawValue.capitalized, for: .normal)
        addSubview(reverbTypeButton)
        reverbTypeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reverbTypeButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            reverbTypeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width / 3),
            reverbTypeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 3),
            reverbTypeButton.heightAnchor.constraint(equalTo: isActiveButton.heightAnchor)
        ])
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: reverbTypeButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: reverbTypeButton.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: reverbTypeButton.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        
        
        
        
    }
    
    func changeActive() {
        if preset?.reverb.isActive == true {
            
            isActiveButton.setTitle("Active", for: .normal)
        } else {
          
            isActiveButton.setTitle("Inactive", for: .normal)
        }
    }
    

    
    func sliderChanged(value: Double) {
        preset?.reverb.dryWet = value
        delegate?.reverbWetDryChanged(value: value)
    }
    
    

    @objc func isActiveButtonAction(sender: UIButton!) {
        delegate?.reverbEnableToggle()
        
        if preset?.reverb.isActive == true {
            preset?.reverb.isActive = false
            slider.color = .green
            changeActive()
        } else {
            preset?.reverb.isActive = true
              slider.color = .red
            changeActive()
        }
    }

}
