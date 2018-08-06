//
//  ReviewsCell.swift
//  Movie
//
//  Created by Kareem Ismail on 7/30/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit

class ReviewsCell: UITableViewCell {
    @IBOutlet weak var reviewerLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(reviewer: String, content: String){
        reviewerLabel.text = reviewer
        contentLabel.text = content
    }

}
