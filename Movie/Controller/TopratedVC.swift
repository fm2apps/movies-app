//
//  TopRatedVC.swift
//  Movie
//
//  Created by Kareem Ismail on 7/18/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
class TopratedVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var topView: CustomSizeUIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    var movies: [Movie] = []
    var imagesArray: [(UIImage, Int)] = [] {
        didSet {
            self.imagesArray = self.imagesArray.sorted(by: {$0.1 < $1.1})
            moviesCollectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //topView.configureSize()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        getTopRatedMovies()
    }
    
    
    func getTopRatedMovies() {
        getMovies(forPage: "1") { (success) in
            self.getMovies(forPage: "2", handler: { (success) in
                self.getMovies(forPage: "3", handler: { (success) in
                    self.getMovies(forPage: "4", handler: { (success) in
                        self.getAllImages(handler: { (success) in
                            if success {
                                self.imagesArray = self.imagesArray.sorted(by: {$0.1 < $1.1})
                                self.moviesCollectionView.reloadData()
                            }
                        })
                    })
                })
            })
            
        }
    }
    
    func getMovies(forPage: String, handler: @escaping (_ success: Bool)->()){
        Alamofire.request("\(GET_TOPRATED_URL)\(forPage)").responseJSON { response in
            guard let data = response.data else {return}
            if let json = try? JSON(data: data) {
                let moviesArray = json["results"]
                for movie in moviesArray {
                    self.movies.append(Movie(title: movie.1["title"].stringValue, description: movie.1["overview"].stringValue, posterPath: movie.1["poster_path"].stringValue, voteAverage: movie.1["vote_average"].doubleValue, releaseDate: movie.1["release_date"].stringValue, movieID: movie.1["id"].stringValue, backDropPath: movie.1["backdrop_path"].stringValue))
                }
                handler(true)
            }
        }
    }
    
    
    func getAllImages(handler: @escaping (_ success: Bool)->()){
        loadingActivity.startAnimating()
        for index in 0 ..< movies.count {
            Alamofire.request("\(BASE_IMAGE_URL)\(movies[index].posterPath!)").responseImage(completionHandler: { (response) in
                guard let image = response.result.value else {return}
                self.imagesArray.append((image, index))
                self.loadingLabel.text = "Loading \(Int((Double(self.imagesArray.count) / 80.0) * 100))%"
                if self.imagesArray.count == self.movies.count {
                    self.loadingActivity.stopAnimating()
                    self.loadingActivity.isHidden = true
                    self.loadingLabel.isHidden = true
                    handler(true)
                }
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath as IndexPath) as! MovieCell
        cell.configureCell(image: imagesArray[indexPath.row].0)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.moviesCollectionView.frame.width/3.2, height: self.moviesCollectionView.frame.height / 4)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = Movie(title: movies[indexPath.row].title!, description: movies[indexPath.row].description!, posterPath: nil, voteAverage: movies[indexPath.row].voteAverage!, releaseDate: movies[indexPath.row].releaseDate!, movieID: movies[indexPath.row].movieID!, backDropPath: movies[indexPath.row].backDropPath!)
        let movieAndImage = (movie, imagesArray[indexPath.row].0)
        performSegue(withIdentifier: "toDetails", sender: movieAndImage)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsVC = segue.destination as? MovieDetailsVC {
            let (movie, image) = (sender as? (Movie,UIImage))!
            movieDetailsVC.movieTitle = movie.title!
            movieDetailsVC.movieDescription = movie.description!
            movieDetailsVC.date = movie.releaseDate!
            movieDetailsVC.originalImage = image
            movieDetailsVC.voting = String(movie.voteAverage!)
            movieDetailsVC.movieID = movie.movieID!
            movieDetailsVC.bannerPath = movie.backDropPath!
            movieDetailsVC.movieOrTV = "movie"
        }
    }}
