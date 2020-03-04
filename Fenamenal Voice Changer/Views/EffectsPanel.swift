//
//  EffectsPanel.swift
//  Fenamenal Voice Changer
//
//  Created by Jonathan Ferrer on 2/25/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit


class EffectsPanel: UIView {

    var preset: Preset? {
        didSet {
           setupViews()
        }
    }

    let reverbButton = UIButton()
    var reverbView: ReverbView = ReverbView()
    var reverbDelegate: ReverbDelegate?
    
    let delayButton = UIButton()
    var delayView: DelayView = DelayView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = .black
//        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .black

//        setupViews()
    }

    func setupViews() {
        self.addSubview(reverbButton)
        self.addSubview(delayButton)
        
        reverbButton.translatesAutoresizingMaskIntoConstraints = false
        delayButton.translatesAutoresizingMaskIntoConstraints = false

//        let reverbFrame = CGRect(x: ( self.frame.midX / 2 ) - (self.frame.width / 5), y: 20, width: self.frame.width / 5, height: self.frame.width / 5)
//        reverbButton.frame = reverbFrame
        reverbButton.setTitle("Reverb", for: .normal)
        reverbButton.backgroundColor = .systemTeal
        reverbButton.setTitleColor(.black, for: .normal)
        reverbButton.layer.borderColor = UIColor.systemBlue.cgColor
        reverbButton.layer.borderWidth = 5
        reverbButton.addTarget(self, action: #selector(reverbButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            reverbButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            reverbButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            reverbButton.widthAnchor.constraint(equalToConstant: self.frame.width / 5),
            reverbButton.heightAnchor.constraint(equalToConstant: self.frame.width / 5)
        ])
        
        
        
//        let delayFrame = CGRect(x: ( self.frame.midX / 2 ) + (2 * (self.frame.width / 5)), y: 20, width: self.frame.width / 5, height: self.frame.width / 5)
//        delayButton.frame = delayFrame
        
        delayButton.setTitle("Delay", for: .normal)
        delayButton.backgroundColor = .systemTeal
        delayButton.setTitleColor(.black, for: .normal)
        delayButton.layer.borderColor = UIColor.systemBlue.cgColor
        delayButton.layer.borderWidth = 5
        delayButton.addTarget(self, action: #selector(delayButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
                   delayButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                   delayButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                   delayButton.widthAnchor.constraint(equalToConstant: self.frame.width / 5),
                   delayButton.heightAnchor.constraint(equalToConstant: self.frame.width / 5)
               ])
        
    }
    
    @objc func delayButtonTapped() {
        delayView = DelayView()
        delayView.isHidden = false
        
        addSubview(delayView)
        delayView.translatesAutoresizingMaskIntoConstraints = false
        delayView.frame = delayButton.frame
        delayView.preset = preset
        
        //MARK: - TODO: - set up delegate
        
        UIView.animate(withDuration: 0.5) {

            NSLayoutConstraint.activate([
                self.delayView.topAnchor.constraint(equalTo: self.topAnchor),
                self.delayView.widthAnchor.constraint(equalToConstant: self.frame.width),
                self.delayView.heightAnchor.constraint(equalToConstant: self.frame.height)
            ])
            self.layoutIfNeeded()
        }
        
    }

    @objc func reverbButtonTapped() {
        reverbView = ReverbView()
        reverbView.isHidden = false
      
        addSubview(reverbView)
        self.reverbView.translatesAutoresizingMaskIntoConstraints = false
        reverbView.frame = reverbButton.frame
        reverbView.preset = preset
        reverbView.delegate = reverbDelegate
        
        UIView.animate(withDuration: 0.5) {

            NSLayoutConstraint.activate([
                self.reverbView.topAnchor.constraint(equalTo: self.topAnchor),
                self.reverbView.widthAnchor.constraint(equalToConstant: self.frame.width),
                self.reverbView.heightAnchor.constraint(equalToConstant: self.frame.height)
            ])
            self.layoutIfNeeded()
        }
 
    }
    
   
        
    

}
