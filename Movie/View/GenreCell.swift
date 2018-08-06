//
//  GenreCell.swift
//  Movie
//
//  Created by Kareem Ismail on 8/2/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit

class GenreCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell (genre: String){
        self.genreLabel.text = genre
    }

}
