//
//  RoundedButton.swift
//  Movie
//
//  Created by Kareem Ismail on 7/31/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 8.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView(){
            self.layer.cornerRadius = cornerRadius
        }
    
}
