//
//  MovieDetails.swift
//  Movie
//
//  Created by Kareem Ismail on 7/19/18.
//  Copyright © 2018 FM2Apps LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import os.log

class MovieDetailsVC: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var movieScrollView: UIScrollView!
    @IBOutlet weak var customUIView: CustomSizeUIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    
    @IBOutlet weak var noReviewsLabel: UILabel!
    var movieTitle: String?
    var posterImage: UIImage?
    var date: String?
    var voting: String?
    var movieDescription: String?
    var imageView: UIImageView?
    var movieTrailers: [String]?
    var movieID: String?
    var bannerPath: String?
    var trailers: [(String, String)] = []
    var reviews: [(String, String)] = []
    var movieOrTV:String?
    var originalImage: UIImage?
    var movies: [Movie] = []
    var imagesArray: [(UIImage, Int)] = [] {
        didSet {
            self.imagesArray = self.imagesArray.sorted(by: {$0.1 < $1.1})
            moviesCollectionView.reloadData()
        }
    }
    var segmentedControl = UISegmentedControl(items: ["Details", "Reviews", "Recommended"])
    let favouritesButton = UIButton()
    var favouriteMovies: [FavouriteMovie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTableView.estimatedRowHeight = 150
        reviewsTableView.rowHeight = UITableViewAutomaticDimension
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        segmentedControl.selectedSegmentIndex = 0
        loadingActivity.isHidden = true
        getBannerForMovie(id: bannerPath!) { (success) in
            if success {
                self.getTrailers(forID: self.movieID!) { (success) in
                    if success {
                        self.getReviews(forID: self.movieID!, handler: { (success) in
                            self.setupScrollView()
                            self.reviewsTableView.reloadData()
                        })
                        
                    }
                }
            }
        }
        //customUIView.configureSize()
        movieTitleLabel.text = movieTitle!
        
    }
    
    func getBannerForMovie(id: String, handler: @escaping (_ success: Bool)->()){
        Alamofire.request("\(BASE_BACKDROP_URL)\(id)").responseImage(completionHandler: { (response) in
            guard let image = response.result.value else {return}
            self.posterImage = image
            if self.posterImage != nil {
                handler(true)
            }
        })
    }
    
    func getSimilarMovies() {
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
    
    func getAllImages(handler: @escaping (_ success: Bool)->()){
        loadingActivity.startAnimating()
        loadingActivity.isHidden = false
        loadingLabel.isHidden = false
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
    func getMovies(forPage: String, handler: @escaping (_ success: Bool)->()){
        Alamofire.request("https://api.themoviedb.org/3/\(movieOrTV!)/\(movieID!)/recommendations?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US&page=\(forPage)").responseJSON { response in
            if response.error != nil {
                print(response.error)
            }
            guard let data = response.data else {return}
            if let json = try? JSON(data: data) {
                let moviesArray = json["results"]
                if self.movieOrTV == "movie"{
                    for movie in moviesArray {
                        self.movies.append(Movie(title: movie.1["title"].stringValue, description: movie.1["overview"].stringValue, posterPath: movie.1["poster_path"].stringValue, voteAverage: movie.1["vote_average"].doubleValue, releaseDate: movie.1["release_date"].stringValue, movieID: movie.1["id"].stringValue, backDropPath: movie.1["backdrop_path"].stringValue))
                    }
                }
                else {
                    for movie in moviesArray {
                        self.movies.append(Movie(title: movie.1["name"].stringValue, description: movie.1["overview"].stringValue, posterPath: movie.1["poster_path"].stringValue, voteAverage: movie.1["vote_average"].doubleValue, releaseDate: movie.1["first_air_date"].stringValue, movieID: movie.1["id"].stringValue, backDropPath: movie.1["backdrop_path"].stringValue))
                    }
                }
                
                handler(true)
            }
        }
    }
    
    func setupScrollView(){
        view.addSubview(segmentedControl)
        segmentedControl.frame = CGRect(x: (view.frame.size.width / 2) - 160, y: customUIView.frame.size.height + 5, width: 320, height: 28)
        segmentedControl.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        imageView = UIImageView(image: posterImage!)
        movieScrollView.addSubview(imageView!)
        
        imageView!.frame = CGRect(x: 0.0, y: 0.0, width: movieScrollView.frame.size.width, height: movieScrollView.frame.height/3)
        let isFavourite = FavouriteMovie(title: movieTitle!, id: movieID!, overview: movieDescription!, rating: voting!, image: posterImage!, releaseDate: date!, backDropPath: bannerPath!, movieOrTV: movieOrTV!)
        favouritesButton.setImage(UIImage(named: "noFav"), for: .normal)
        if let favourites = MovieDetailsVC.loadMovies() {
            if favourites.contains(isFavourite){
                favouritesButton.setImage(UIImage(named: "fav"), for: .normal)
            }
        }
        favouritesButton.addTarget(self, action: #selector(favouriteButtonClicked), for: .touchUpInside)
        movieScrollView.addSubview(favouritesButton)
        favouritesButton.frame = CGRect(x: movieScrollView.frame.size.width - 45.0, y: (imageView?.frame.size.height)! - 45.0, width: 44, height: 44)
        favouritesButton.imageEdgeInsets.bottom = 10
        favouritesButton.imageEdgeInsets.top = 10
        favouritesButton.imageEdgeInsets.right = 10
        favouritesButton.imageEdgeInsets.left = 10
        
        movieScrollView.contentSize = CGSize(width: movieScrollView.frame.size.width, height: addMovieDetailsLabels())
        movieScrollView.clipsToBounds = true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex{
        case 0: noReviewsLabel.isHidden = true
        reviewsTableView.isHidden = true
        movieScrollView.isHidden = false
        moviesCollectionView.isHidden = true
        loadingLabel.isHidden = true
        loadingActivity.isHidden = true
        case 1: movieScrollView.isHidden = true
        reviews.count > 0 ? (reviewsTableView.isHidden = false) : (noReviewsLabel.isHidden = false)
        moviesCollectionView.isHidden = true
        loadingLabel.isHidden = true
        loadingActivity.isHidden = true
        default:
            if movies.count == 0 {getSimilarMovies()}
            reviewsTableView.isHidden = true
            movieScrollView.isHidden = true
            noReviewsLabel.isHidden = true
            moviesCollectionView.isHidden = false
            
        }
    }
    
    @objc func favouriteButtonClicked(){
        let favMovie = FavouriteMovie(title: movieTitle!, id: movieID!, overview: movieDescription!, rating: voting!, image: originalImage!, releaseDate: date!, backDropPath: bannerPath!, movieOrTV: movieOrTV!)
        if let moviesInFav = MovieDetailsVC.loadMovies() {
            favouriteMovies = moviesInFav
        }
        saveMovies()
            if(favouriteMovies.contains(favMovie)){
                favouriteMovies.remove(at: favouriteMovies.index(of: favMovie)!)
                favouritesButton.setImage(UIImage(named: "noFav"), for: .normal)
                saveMovies()
            }
            else {
                favouritesButton.setImage(UIImage(named: "fav"), for: .normal)
                if let previousFavs = MovieDetailsVC.loadMovies() {
                    favouriteMovies = []
                    favouriteMovies += previousFavs
                }
                favouriteMovies.append(favMovie)
                saveMovies()
                if let testGoals = MovieDetailsVC.loadMovies() {
                    for everyGoal in testGoals {
                        print(everyGoal.title)
                    }
                }
                else {
                    print("Couldnt load data")
                }
            }
    }
    
    func addMovieDetailsLabels() -> CGFloat{
        var heightSoFar = imageView?.frame.size.height
        heightSoFar! += addLabel(title: "Release Date", text: self.date!, howManyLabelsWhereAddedBefore: 0, heightSoFar: heightSoFar!,isClickable: false, trailerKey: "")
        heightSoFar! += addLabel(title: "Voting Average", text: "\(self.voting!) / 10.0", howManyLabelsWhereAddedBefore: 1, heightSoFar: heightSoFar!,isClickable: false, trailerKey: "")
        heightSoFar! += addLabel(title: "Description", text: movieDescription!, howManyLabelsWhereAddedBefore: 2, heightSoFar: heightSoFar!,isClickable: false, trailerKey: "")
        heightSoFar! += addLabel(title: "Trailers", text: "", howManyLabelsWhereAddedBefore: 3, heightSoFar: heightSoFar!,isClickable: false, trailerKey: "")
        for index in 0 ..< trailers.count {
            heightSoFar! += addLabel(title: "", text: trailers[index].0, howManyLabelsWhereAddedBefore: index + 4, heightSoFar: heightSoFar!, isClickable: true, trailerKey: trailers[index].1)
        }
        return heightSoFar!
    }
    
    func addLabel(title: String, text: String, howManyLabelsWhereAddedBefore: Int, heightSoFar: CGFloat, isClickable: Bool, trailerKey: String)->CGFloat{
        let titleAttrString = NSAttributedString(string: title, attributes: returnStringAttributes(size: 15, isClickable: false))
        let textAttrString = NSAttributedString(string: text, attributes: returnStringAttributes(size: 13, isClickable: isClickable))
        let titleLabel = UILabel()
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        titleLabel.attributedText = titleAttrString
        textLabel.attributedText = textAttrString
        textLabel.frame.size.width = movieScrollView.frame.size.width - 10
        textLabel.textAlignment = .justified
        textLabel.sizeToFit()
        if isClickable {
            let tap = MyTapGesture(target: self, action: #selector(MovieDetailsVC.trailerTapped(sender:)))
            textLabel.isUserInteractionEnabled = true
            textLabel.addGestureRecognizer(tap)
            tap.title = trailerKey
        }
        var lineSeparator = UIView(frame: CGRect(x: 0, y: heightSoFar+textLabel.frame.height+33, width: movieScrollView.frame.size.width, height: 0.4))
        lineSeparator.layer.borderWidth = 0.4
        lineSeparator.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        if !isClickable{
            movieScrollView.addSubview(titleLabel)
            if title != "Trailers"{
                movieScrollView.addSubview(lineSeparator)
                
            }
        }
        movieScrollView.addSubview(textLabel)
        titleLabel.frame = CGRect(x: 0, y: Int(heightSoFar), width: Int(movieScrollView.frame.size.width), height: 30)
        if isClickable {
            titleLabel.frame.size.height = 0
            imageView = UIImageView(image: UIImage(named: "youtubeLogo"))
            movieScrollView.addSubview(imageView!)
            if textLabel.frame.height > 20 {
                imageView!.frame = CGRect(x: 0, y: heightSoFar+titleLabel.frame.size.height+6, width: 20, height: 20)
            }
            else {
                imageView!.frame = CGRect(x: 0, y: heightSoFar+titleLabel.frame.size.height, width: 20, height: 20)
            }
        }
        if isClickable {
            textLabel.frame = CGRect(x: 25, y: heightSoFar+titleLabel.frame.size.height , width: movieScrollView.frame.size.width - 30, height: textLabel.frame.height + 10)
        }
        else {
            textLabel.frame = CGRect(x: 0, y: heightSoFar+titleLabel.frame.size.height, width: movieScrollView.frame.size.width, height: textLabel.frame.height)
        }
        if title == "Trailers" {
            textLabel.frame.size.height = 0
        }
        return textLabel.frame.size.height + titleLabel.frame.size.height + CGFloat(title != "Trailers" ? 5:0)
    }
    
    func returnStringAttributes(size: CGFloat, isClickable: Bool)->[NSAttributedStringKey:NSObject?] {
        if isClickable {
            return [NSAttributedStringKey.foregroundColor: UIColor.white,
                    NSAttributedStringKey.font : UIFont(name: "Apple SD Gothic Neo", size: size)
            ]
        }
        else {
            return [NSAttributedStringKey.foregroundColor: UIColor.white,
                    NSAttributedStringKey.font : UIFont(name: "Apple SD Gothic Neo", size: size)
            ]
        }
    }
    
    func getTrailers(forID: String, handler: @escaping (_ success: Bool)->()){
        Alamofire.request("https://api.themoviedb.org/3/\(movieOrTV!)/\(forID)/videos?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US").responseJSON { (response) in
            guard let data = response.data else {return}
            var trailersArray: JSON?
            if let json = try? JSON(data: data) {
                self.trailers.removeAll()
                trailersArray = json["results"]
                for trailer in trailersArray! {
                    self.trailers.append((trailer.1["name"].stringValue, trailer.1["key"].stringValue))
                }
            }
            if self.trailers.count == trailersArray!.count {
                handler(true)
            }
        }
    }
    
    func getReviews(forID: String, handler: @escaping (_ success: Bool)->()){
        Alamofire.request("https://api.themoviedb.org/3/\(movieOrTV!)/\(forID)/reviews?api_key=e9fedb645e711fbaf2d6802fab60f121&language=en-US").responseJSON { (response) in
            guard let data = response.data else {return}
            var reviewsArray: JSON?
            if let json = try? JSON(data: data) {
                self.reviews.removeAll()
                reviewsArray = json["results"]
                for review in reviewsArray! {
                    self.reviews.append((review.1["author"].stringValue, review.1["content"].stringValue))
                }
            }
            if self.reviews.count == reviewsArray!.count {
                handler(true)
            }
        }
    }
    
    @objc
    func trailerTapped(sender: MyTapGesture){
        if let youtubeURL = URL(string: "youtube://\(sender.title)"),
            UIApplication.shared.openURL(youtubeURL) {
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(sender.title)") {
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath as IndexPath) as? ReviewsCell {
            cell.configureCell(reviewer: reviews[indexPath.row].0, content: reviews[indexPath.row].1)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
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
        return CGSize(width: self.moviesCollectionView.frame.width/3.3, height: self.moviesCollectionView.frame.height / 4)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = Movie(title: movies[indexPath.row].title!, description: movies[indexPath.row].description!, posterPath: nil, voteAverage: movies[indexPath.row].voteAverage!, releaseDate: movies[indexPath.row].releaseDate!, movieID: movies[indexPath.row].movieID!, backDropPath: movies[indexPath.row].backDropPath!)
        let movieDetailsVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsVC
        movieDetailsVC.movieTitle = movie.title!
        movieDetailsVC.movieDescription = movie.description!
        movieDetailsVC.date = movie.releaseDate!
        movieDetailsVC.voting = String(movie.voteAverage!)
        movieDetailsVC.movieID = movie.movieID!
        movieDetailsVC.bannerPath = movie.backDropPath!
        movieDetailsVC.originalImage = imagesArray[indexPath.row].0
        movieDetailsVC.movieOrTV = self.movieOrTV!
        present(movieDetailsVC, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsVC = segue.destination as? MovieDetailsVC {
            let (movie, image) = (sender as? (Movie,UIImage))!
            movieDetailsVC.movieTitle = movie.title!
            movieDetailsVC.movieDescription = movie.description!
            movieDetailsVC.date = movie.releaseDate!
            movieDetailsVC.voting = String(movie.voteAverage!)
            movieDetailsVC.movieID = movie.movieID!
            movieDetailsVC.bannerPath = movie.backDropPath!
            movieDetailsVC.originalImage = image
            movieDetailsVC.movieOrTV = self.movieOrTV!
        }
    }
    private func saveMovies(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favouriteMovies, toFile: FavouriteMovie.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Goals saved successfully", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Goals failed to save", log: OSLog.default, type: .debug)
        }
    }
    
    static func loadMovies()-> [FavouriteMovie]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: FavouriteMovie.ArchiveURL.path) as? [FavouriteMovie]
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var title = String()
}
