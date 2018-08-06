//  Constants.swift
//  Movie
//  Created by Kareem Ismail on 7/18/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.

import Foundation


let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: Date()))!

let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/w300"
let GET_POPULAR_URL = "https://api.themoviedb.org/3/movie/popular?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&page="
let GET_NOWPLAYING_URL = "https://api.themoviedb.org/3/movie/now_playing?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&page="
let GET_TOPRATED_URL = "https://api.themoviedb.org/3/movie/top_rated?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&page="
let GET_POPULARTV_URL = "https://api.themoviedb.org/3/tv/popular?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&page="
let TO_ABOUT_US = "toAboutUs"
let TO_TERMS = "toTerms"
let TO_ABOUT_MOVIES = "toAboutMovies"
let BASE_BACKDROP_URL = "https://image.tmdb.org/t/p/w780"
let SEARCH_URL = "https://api.themoviedb.org/3/search/movie?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&page=1&include_adult=false"

let GENRE_POPULAR = "https://api.themoviedb.org/3/discover/movie?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page="
let GENRE_RELEASEDATE = "https://api.themoviedb.org/3/discover/movie?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&sort_by=release_date.desc&include_adult=false&include_video=false&page="
let GENRE_WITH_NO_SORT = "https://api.themoviedb.org/3/discover/movie?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&include_adult=false&include_video=false&page="

let GENRE_WITHMIN_RELEASE_DATE = "https://api.themoviedb.org/3/discover/movie?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&include_adult=false&include_video=false&primary_release_date.gte=\(currentYearInt)&page="

