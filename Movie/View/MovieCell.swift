//
//  MovieCell.swift
//  Movie
//
//  Created by Kareem Ismail on 7/20/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(image: UIImage) {
        movieImage.image = image
        self.layer.cornerRadius = 10
        self.layer.shadowColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = true
    }
}
