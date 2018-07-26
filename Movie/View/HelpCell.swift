//
//  SettingsCell.swift
//  Converse
//
//  Created by Kareem Ismail on 7/16/18.
//  Copyright © 2018 Whatever. All rights reserved.
//

import UIKit

class HelpCell: UITableViewCell {
    
    @IBOutlet weak var helpLabel: UILabel!

    @IBOutlet weak var helpImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(with text: String, with image:UIImage){
        helpLabel.text = text
        helpImageView.image = image
    }
    
}
