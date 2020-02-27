//
//  ReverbView.swift
//  Fenamenal Voice Changer
//
//  Created by jonathan ferrer on 2/26/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit

class ReverbView: UIView {


    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var isActiveButton = UIButton()
    
    
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
        
        isActiveButton = UIButton(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: 100, height: 50))
        isActiveButton.setTitle("Test Button", for: .normal)
        isActiveButton.backgroundColor = .systemBlue
        isActiveButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        addSubview(isActiveButton)
 
    }
    
    
    

    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
    }

}
