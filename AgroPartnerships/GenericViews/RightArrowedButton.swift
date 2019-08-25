//
//  RightArrowedButton.swift
//  AgroPartnerships
//
//  Created by Kanyinsola Fapohunda on 25/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit

class RightArrowedButton: UIButton {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        
        self.contentHorizontalAlignment = .right
        addDropDownIndicator()
        titleLabel?.textColor = UIColor.appGreen2
    }
    
    func addDropDownIndicator() {
        let main = UIView()
        addSubview(main)
        
        main.translatesAutoresizingMaskIntoConstraints = false
        main.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true
        
        let dropDownIndicator = UIImageView();
        dropDownIndicator.contentMode = .scaleAspectFit
        main.addSubview(dropDownIndicator)
        dropDownIndicator.translatesAutoresizingMaskIntoConstraints = false
        dropDownIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: 12).isActive = true;
        dropDownIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true;
        dropDownIndicator.widthAnchor.constraint(equalToConstant: 8).isActive = true
        dropDownIndicator.heightAnchor.constraint(equalToConstant: 13).isActive = true
        dropDownIndicator.image = UIImage(named: "disclosure")
    }
}
