//
//  MovieBrain.swift
//  Movie
//
//  Created by Kareem Ismail on 7/29/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import Foundation

struct MovieBrain {
    enum whichController {
        case popular
        case toprated
        case nowplaying
        case tvshows
    }
    var movies: [Movie]
    //var imagesArray: [(, Int)]
}

