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
    func reverbTypeChanged(index: Int)
}

class ReverbView: UIView {

    var isActiveButton = UIButton()
    var reverbTypeButton = UIButton()
    var tableView: UITableView = UITableView()
    var slider = AKSlider(property: "Reverb")
    var delegate: ReverbDelegate?
    var preset: Preset? {
        didSet {
            setupViews()
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
            
        
        addSubview(slider)
        slider.range = 0.0...1
        if let value = preset?.reverb.dryWet {
            slider.value = value
        } else {
            slider.value = 0.5
        }
        slider.callback = sliderChanged
        slider.color = preset!.reverb.isActive ? UIColor.green : UIColor.red
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: isActiveButton.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width / 3),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 3),
            slider.heightAnchor.constraint(equalTo: isActiveButton.heightAnchor, multiplier: 2)
        ])
       


        
        
        reverbTypeButton = UIButton()
        reverbTypeButton.backgroundColor = .systemBlue
        
        
        
        guard let preset = preset else { return }
        
        reverbTypeButton.setTitle(preset.reverb.reverbPreset, for: .normal)
        reverbTypeButton.addTarget(self, action: #selector(self.onClickDropButtonAction), for: .touchUpInside)
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
        tableView.isHidden = true
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
            isActiveButton.backgroundColor = .systemGreen
        } else {
          
            isActiveButton.setTitle("Inactive", for: .normal)
            isActiveButton.backgroundColor = .systemRed
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
            slider.color = .systemRed
            changeActive()
        } else {
            preset?.reverb.isActive = true
            slider.color = .systemGreen
            changeActive()
        }
    }
    
    @objc func onClickDropButtonAction(sender: UIButton) {
        if tableView.isHidden {
            animation(toggle: true)
        } else {
            animation(toggle: false)
        }
    }
    func animation(toggle: Bool) {
        
        
        
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = true
            }
    
        }
    }
    
    
    

}

extension ReverbView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preset?.reverb.reverbPresets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = preset?.reverb.reverbPresets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let reverbPreset = preset?.reverb.reverbPresets[indexPath.row] else { return }
        reverbTypeButton.setTitle( reverbPreset, for: .normal)
        preset?.reverb.reverbPreset = reverbPreset
        animation(toggle: false)
        delegate?.reverbTypeChanged(index: indexPath.row)
        
    }

    
}


