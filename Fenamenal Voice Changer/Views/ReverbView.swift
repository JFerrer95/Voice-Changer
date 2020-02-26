//
//  ReverbView.swift
//  Fenamenal Voice Changer
//
//  Created by jonathan ferrer on 2/26/20.
//  Copyright © 2020 Jonathan Ferrer. All rights reserved.
//

import UIKit

class ReverbView: UIView {

    @IBOutlet weak var button: UIButton!
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
        
        addSubview(isActiveButton)
        isActiveButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        isActiveButton.frame = CGRect(x: self.frame.midX - ( self.frame.width / 4), y: self.frame.origin.y + 20, width: self.frame.width / 4, height: self.frame.width)
        
    }

}
