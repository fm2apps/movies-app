//
//  AboutFMCell.swift
//  Converse
//
//  Created by Kareem Ismail on 7/17/18.
//  Copyright © 2018 Whatever. All rights reserved.
//

import UIKit

class AboutUsCell: UITableViewCell {
    
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell(_ title: String, text: String){
        titleLabel.text = title
        txtLabel.text = text 
    }
    
}
