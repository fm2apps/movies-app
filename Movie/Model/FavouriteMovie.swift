//
//  FavouriteMovie.swift
//  Movie
//
//  Created by Kareem Ismail on 8/2/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import Foundation
import UIKit
import os.log

class FavouriteMovie: NSObject, NSCoding {
    var title: String
    var id: String
    var overview: String
    var rating: String
    var image: UIImage
    var releaseDate: String
    var backdropPath: String
    var movieOrTV: String
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Favourites")
    
    init(title: String, id: String, overview: String, rating: String, image: UIImage, releaseDate: String, backDropPath: String, movieOrTV: String){
        self.title = title
        self.id = id
        self.overview = overview
        self.rating = rating
        self.releaseDate = releaseDate
        self.image = image
        self.backdropPath = backDropPath
        self.movieOrTV = movieOrTV
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: KeyValues.title)
        aCoder.encode(id, forKey: KeyValues.id)
        aCoder.encode(overview, forKey: KeyValues.overview)
        aCoder.encode(rating, forKey: KeyValues.votingAvg)
        aCoder.encode(releaseDate, forKey: KeyValues.releaseDate)
        aCoder.encode(UIImageJPEGRepresentation(image, 1.0), forKey: KeyValues.image)
        aCoder.encode(backdropPath, forKey: KeyValues.backdropPath)
        aCoder.encode(movieOrTV, forKey: KeyValues.movieOrTV)
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: KeyValues.title) as? String else {
            os_log("Unable to decode title string", log: OSLog.default, type: .debug)
            return nil
        }
        let idd = aDecoder.decodeObject(forKey: KeyValues.id) as! String
        let overview = aDecoder.decodeObject(forKey: KeyValues.overview) as! String
        let rating = aDecoder.decodeObject(forKey: KeyValues.votingAvg) as! String
        let releaseDate = aDecoder.decodeObject(forKey: KeyValues.releaseDate) as! String
        let image = UIImage(data:aDecoder.decodeObject(forKey: KeyValues.image) as! Data,scale:1.0)
        let backdropPath = aDecoder.decodeObject(forKey: KeyValues.backdropPath) as! String
        let movieOrTV = aDecoder.decodeObject(forKey: KeyValues.movieOrTV) as! String
        self.init(title: title, id: idd, overview: overview, rating: rating, image: image!, releaseDate: releaseDate, backDropPath: backdropPath, movieOrTV: movieOrTV)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? FavouriteMovie {
            if (other.title == self.title) && (other.overview == self.overview) {
                return true
            }
        }
        return false
    }
}
