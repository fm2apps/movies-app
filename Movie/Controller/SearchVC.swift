//
//  SearchVC.swift
//  Movie
//
//  Created by Kareem Ismail on 7/31/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class SearchVC: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var genreTableView: UITableView!
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var newestSwtich: UISwitch!
    @IBOutlet weak var popularitySwitch: UISwitch!
    @IBOutlet weak var customUIView: CustomSizeUIView!
    @IBOutlet weak var searchOptionSegment: UISegmentedControl!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var movieConstraint: NSLayoutConstraint!
    @IBOutlet weak var chooseButton: RoundedButton!
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    var byName = true
    var URL_GENRE = GENRE_WITH_NO_SORT
    var genreID = 0
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    var movies: [Movie] = []
    var imagesArray: [(UIImage, Int)] = [] {
        didSet {
            self.imagesArray = self.imagesArray.sorted(by: {$0.1 < $1.1})
            moviesCollectionView.reloadData()
        }
    }
    var movies2: [Movie] = []
    var imagesArray2: [(UIImage, Int)] = [] {
        didSet {
            self.imagesArray2 = self.imagesArray2.sorted(by: {$0.1 < $1.1})
            moviesCollectionView.reloadData()
        }
    }
    var changeY = true
    var genresArray = ["Action", "Adventure", "Animation", "Comedy", "Crime", "Drama", "Documentary" ,"Family","Fantasy"
        , "History"
        , "Horror"
        , "Music"
        , "Mystery"
        , "Romance"
        , "Science Fiction"
        , "TV Movie"
        , "Thriller"
        , "War"
        , "Western"]
    var genreDictionary = ["Action": 28, "Adventure" : 12, "Animation" : 16, "Comedy" : 35, "Crime" : 80, "Drama" : 18 ,"Documentary": 99, "Family" : 10751,"Fantasy" : 14
        , "History": 36
        , "Horror" : 27
        , "Music" : 10402
        , "Mystery" : 9648
        , "Romance" : 10749
        , "Science Fiction" : 878
        , "TV Movie" : 10770
        , "Thriller" : 53
        , "War" : 10752
        , "Western" : 37
          ]
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadingActivity.isHidden = true
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        genreTableView.delegate = self
        genreTableView.dataSource = self
        //customUIView.configureSize()
        searchOptionSegment.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        popularitySwitch.addTarget(self, action: #selector(popSwitchChanged), for: .valueChanged)
        newestSwtich.addTarget(self, action: #selector(newSwitchChanged), for: .valueChanged)

    }
    override func viewDidAppear(_ animated: Bool) {
        if chooseButton.currentTitle == "Choose" {
            genreID = 0
        }

    }
    
    @objc func popSwitchChanged() {
        if popularitySwitch.isOn {
            newestSwtich.setOn(false, animated: true)
        }
    }
    
    @objc func newSwitchChanged(switchState: UISwitch) {
        if newestSwtich.isOn {
            popularitySwitch.setOn(false, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        changeY = true
        loadingActivity.isHidden = false
        movies.removeAll()
        imagesArray.removeAll()
        moviesCollectionView.reloadData()
        if let movieName = searchBar.text {
            view.endEditing(true)
            Alamofire.request("\(SEARCH_URL)&query=\(movieName.replacingOccurrences(of: " ", with: "%20"))").responseJSON { (response) in
                guard let data = response.data else {return}
                if let json = try? JSON(data: data) {
                    let moviesArray = json["results"]
                    if moviesArray.count == 0 {
                        self.showToast(message: "Please Enter a Valid Movie Name")
                        self.loadingActivity.isHidden = true
                        return
                    }
                    
                    for movie in moviesArray {
                        if movie.1["poster_path"].stringValue != "" {
                            self.movies.append(Movie(title: movie.1["title"].stringValue, description: movie.1["overview"].stringValue, posterPath: movie.1["poster_path"].stringValue, voteAverage: movie.1["vote_average"].doubleValue, releaseDate: movie.1["release_date"].stringValue, movieID: movie.1["id"].stringValue, backDropPath: movie.1["backdrop_path"].stringValue))
                        }
                    }
                    self.getAllImages(handler: { (success) in
                        if success {
                            self.imagesArray = self.imagesArray.sorted(by: {$0.1 < $1.1})
                            self.moviesCollectionView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    
    
    func getMovies(forPage: String, handler: @escaping (_ success: Bool)->()){
        Alamofire.request("\(URL_GENRE)\(forPage)&with_genres=\(genreID)").responseJSON { response in
            guard let data = response.data else {return}
            if let json = try? JSON(data: data) {
                let moviesArray = json["results"]
                for movie in moviesArray {
                    if movie.1["poster_path"].stringValue != "" && movie.1["backdrop_path"].stringValue != "" {
                        self.movies2.append(Movie(title: movie.1["title"].stringValue, description: movie.1["overview"].stringValue, posterPath: movie.1["poster_path"].stringValue, voteAverage: movie.1["vote_average"].doubleValue, releaseDate: movie.1["release_date"].stringValue, movieID: movie.1["id"].stringValue, backDropPath: movie.1["backdrop_path"].stringValue))
                    }

                }
                handler(true)
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch searchOptionSegment.selectedSegmentIndex{
        case 0: genreView.isHidden = true
            nameView.isHidden = false
            movieConstraint.constant = 10
        genreTableView.isHidden = true
        moviesCollectionView.reloadData()
        byName = true
            searchBar.isHidden = false
        case 1: nameView.isHidden = true
            genreView.isHidden = false
            movieConstraint.constant = 70
            moviesCollectionView.reloadData()
            byName = false
        default: genreView.isHidden = true
            nameView.isHidden = false
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    

    @IBAction func chooseButtonPressed(_ sender: UIButton) {
        genreTableView.isHidden = false
    }
    
    func getGenreMovies() {
        getMovies(forPage: "1") { (success) in
            self.getMovies(forPage: "2", handler: { (success) in
                self.getMovies(forPage: "3", handler: { (success) in
                    self.getMovies(forPage: "4", handler: { (success) in
                        self.getMovies(forPage: "5", handler: { (success) in
                            self.getAllImages(handler: { (success) in
                                if success {
                                    self.imagesArray2 = self.imagesArray2.sorted(by: {$0.1 < $1.1})
                                    self.moviesCollectionView.reloadData()
                                }
                            })
                        })
                    })
                })
            })
        }
    }
    
    

    @IBAction func searchGenreButtonPressed(_ sender: UIButton) {
        if genreID == 0 {
            showToast(message: "Please Select a Genre")
        }
        else {
            movies2.removeAll()
            imagesArray2.removeAll()
            moviesCollectionView.reloadData()
            if popularitySwitch.isOn {
                URL_GENRE = GENRE_POPULAR
            } else {
                if newestSwtich.isOn {
                    URL_GENRE = GENRE_WITHMIN_RELEASE_DATE
                }
                else {
                    URL_GENRE = GENRE_WITH_NO_SORT
                }
            }
            getGenreMovies()
            nameView.isHidden = false
            searchBar.isHidden = true
        }

    }
    
    
    
    func getAllImages(handler: @escaping (_ success: Bool)->()){
        loadingActivity.startAnimating()
        loadingActivity.isHidden = false
        loadingLabel.isHidden = false
        if byName {
            for index in 0 ..< movies.count {
                Alamofire.request("\(BASE_IMAGE_URL)\(movies[index].posterPath!)").responseImage(completionHandler: { (response) in
                    guard let image = response.result.value else {return}
                    self.imagesArray.append((image, index))
                    self.loadingLabel.text = "Loading \(Int((Double(self.imagesArray.count) / Double(self.movies.count)) * 100))%"
                    if self.imagesArray.count == self.movies.count {
                        self.loadingActivity.stopAnimating()
                        self.loadingActivity.isHidden = true
                        self.loadingLabel.isHidden = true
                        handler(true)
                    }
                })
            }
        }
        else {
            for index in 0 ..< movies2.count {
                Alamofire.request("\(BASE_IMAGE_URL)\(movies2[index].posterPath!)").responseImage(completionHandler: { (response) in
                    guard let image = response.result.value else {return}
                    self.imagesArray2.append((image, index))
                    self.loadingLabel.text = "Loading \(Int((Double(self.imagesArray2.count) / Double(self.movies2.count)) * 100))%"
                    if self.imagesArray2.count == self.movies2.count {
                        self.loadingActivity.stopAnimating()
                        self.loadingActivity.isHidden = true
                        self.loadingLabel.isHidden = true
                        handler(true)
                    }
                })
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if byName {
            return imagesArray.count
        }
        else {
            return imagesArray2.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if byName {
            let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath as IndexPath) as! MovieCell
            cell.configureCell(image: imagesArray[indexPath.row].0)
            return cell
        }
        else {
            let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath as IndexPath) as! MovieCell
            cell.configureCell(image: imagesArray2[indexPath.row].0)
            return cell
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if byName {
            return CGSize(width: self.moviesCollectionView.frame.width/3.2, height: self.moviesCollectionView.frame.height / 3.6)
        }
        else {
            return CGSize(width: self.moviesCollectionView.frame.width/3.2, height: self.moviesCollectionView.frame.height / 3.0)

        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if byName{
        let movie = Movie(title: movies[indexPath.row].title!, description: movies[indexPath.row].description!, posterPath: nil, voteAverage: movies[indexPath.row].voteAverage!, releaseDate: movies[indexPath.row].releaseDate!, movieID: movies[indexPath.row].movieID!, backDropPath: movies[indexPath.row].backDropPath!)
        let movieAndImage = (movie, imagesArray[indexPath.row].0)
        performSegue(withIdentifier: "toDetails", sender: movieAndImage)
        }
        else {
            let movie = Movie(title: movies2[indexPath.row].title!, description: movies2[indexPath.row].description!, posterPath: nil, voteAverage: movies2[indexPath.row].voteAverage!, releaseDate: movies2[indexPath.row].releaseDate!, movieID: movies2[indexPath.row].movieID!, backDropPath: movies2[indexPath.row].backDropPath!)
            let movieAndImage = (movie, imagesArray2[indexPath.row].0)
            performSegue(withIdentifier: "toDetails", sender: movieAndImage)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsVC = segue.destination as? MovieDetailsVC {
            let (movie, image) = (sender as? (Movie,UIImage))!
            movieDetailsVC.movieTitle = movie.title!
            movieDetailsVC.movieDescription = movie.description!
            movieDetailsVC.date = movie.releaseDate!
            movieDetailsVC.voting = String(movie.voteAverage!)
            movieDetailsVC.movieID = movie.movieID!
            movieDetailsVC.originalImage = image
            movieDetailsVC.bannerPath = movie.backDropPath!
            movieDetailsVC.movieOrTV = "movie"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = genreTableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath as IndexPath ) as? GenreCell {
            cell.configureCell(genre: genresArray[indexPath.row])
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        genreTableView.isHidden = true
        genreID = genreDictionary[genresArray[indexPath.row]]!
        chooseButton.setTitle(genresArray[indexPath.row], for: .normal)
    }
    
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125.0, y: self.view.frame.size.height/2.0-17.5, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 15.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }






