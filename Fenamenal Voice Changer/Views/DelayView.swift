//
//  DelayView.swift
//  Fenamenal Voice Changer
//
//  Created by jonathan ferrer on 3/3/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit

protocol DelayDelegate {
    func delayEnableToggle()
}


class DelayView: UIView {
    var isActiveButton = UIButton()
    var delegate: DelayDelegate?
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
