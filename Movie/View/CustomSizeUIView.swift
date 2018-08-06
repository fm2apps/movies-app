//
//  CustomSizeUIView.swift
//  Movie
//
//  Created by Kareem Ismail on 7/20/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit

class CustomSizeUIView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureSize(){
        self.translatesAutoresizingMaskIntoConstraints = true
        if(UIScreen.main.bounds.height < 812.0){
            self.frame.size.height = 65
        }
        else {
            self.frame.size.height = 90
        }
        self.setNeedsDisplay()
    }
}
