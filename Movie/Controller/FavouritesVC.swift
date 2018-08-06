//
//  FavouritesVC.swift
//  Movie
//
//  Created by Kareem Ismail on 8/2/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit

class FavouritesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    @IBOutlet weak var noFavImage: UIImageView!
    @IBOutlet weak var customSizeUIView: CustomSizeUIView!
    var favouriteMovies: [FavouriteMovie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        if let moviesInFav = MovieDetailsVC.loadMovies() {
            favouriteMovies = moviesInFav
        }
        
        if favouriteMovies.count == 0 {
            noFavLabel.isHidden = false
            noFavImage.isHidden = false
        }
        //customSizeUIView.configureSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let moviesInFav = MovieDetailsVC.loadMovies() {
            favouriteMovies = moviesInFav
        }
        moviesCollectionView.reloadData()
        if favouriteMovies.count == 0 {
            noFavLabel.isHidden = false
            noFavImage.isHidden = false
        }
        else {
            noFavLabel.isHidden = true
            noFavImage.isHidden = true
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath as IndexPath) as! MovieCell
        cell.configureCell(image: favouriteMovies[indexPath.row].image)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.moviesCollectionView.frame.width/3.2, height: self.moviesCollectionView.frame.height / 4)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = Movie(title: favouriteMovies[indexPath.row].title, description: favouriteMovies[indexPath.row].overview, posterPath: favouriteMovies[indexPath.row].backdropPath, voteAverage: Double(favouriteMovies[indexPath.row].rating)!, releaseDate: favouriteMovies[indexPath.row].releaseDate, movieID: favouriteMovies[indexPath.row].id, backDropPath: favouriteMovies[indexPath.row].backdropPath)
        let movieAndImage = (movie, favouriteMovies[indexPath.row].image, favouriteMovies[indexPath.row].movieOrTV)
        performSegue(withIdentifier: "toDetails", sender: movieAndImage)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsVC = segue.destination as? MovieDetailsVC {
            let (movie, image, movieTV) = (sender as? (Movie,UIImage, String))!
            movieDetailsVC.movieTitle = movie.title!
            movieDetailsVC.movieDescription = movie.description!
            movieDetailsVC.date = movie.releaseDate!
            movieDetailsVC.originalImage = image
            movieDetailsVC.voting = String(movie.voteAverage!)
            movieDetailsVC.movieID = movie.movieID!
            movieDetailsVC.bannerPath = movie.backDropPath!
            movieDetailsVC.movieOrTV = movieTV
        }
    }
    
    

}
