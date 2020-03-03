//
//  EffectsPanel.swift
//  Fenamenal Voice Changer
//
//  Created by Jonathan Ferrer on 2/25/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit


class EffectsPanel: UIView {

    var preset: Preset?

    let reverbButton = UIButton()
    let reverbView = ReverbView()
    var reverbDelegate: ReverbDelegate?

    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = .black
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .black

        setupViews()
    }

    func setupViews() {
        self.addSubview(reverbButton)

        let frame = CGRect(x: ( self.frame.midX / 2 ) - (self.frame.width / 5), y: 20, width: self.frame.width / 5, height: self.frame.width / 5)
        reverbButton.setTitle("Reverb", for: .normal)
        reverbButton.backgroundColor = .systemTeal
        reverbButton.setTitleColor(.black, for: .normal)
        reverbButton.frame = frame
        reverbButton.layer.borderColor = UIColor.systemBlue.cgColor
        reverbButton.layer.borderWidth = 5
        reverbButton.addTarget(self, action: #selector(reverbButtonTapped), for: .touchUpInside)
    }

    @objc func reverbButtonTapped() {
        addSubview(reverbView)
        reverbView.frame = reverbButton.frame
        reverbView.preset = preset
        reverbView.delegate = reverbDelegate
        
        UIView.animate(withDuration: 0.5) {
            self.reverbView.translatesAutoresizingMaskIntoConstraints = false
            self.reverbButton.isEnabled = false
            NSLayoutConstraint.activate([
                self.reverbView.topAnchor.constraint(equalTo: self.reverbButton.topAnchor)
                
            ])
            
        }

        
        
    
    }

}
