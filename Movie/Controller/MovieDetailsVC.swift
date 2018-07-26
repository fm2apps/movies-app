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

class MovieDetailsVC: UIViewController, UIGestureRecognizerDelegate {
    
   
    @IBOutlet weak var movieScrollView: UIScrollView!
    @IBOutlet weak var customUIView: CustomSizeUIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
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
    var movieOrTV:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        getBannerForMovie(id: bannerPath!) { (success) in
            if success {
                self.getTrailers(forID: self.movieID!) { (success) in
                    if success {
                        self.setupScrollView()
                    }
                }
            }
        }
        
        
        customUIView.configureSize()
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
    
    func setupScrollView(){
        imageView = UIImageView(image: posterImage!)
        //let imagePosterXPosition: CGFloat = movieScrollView.frame.size.width / 4.0
        movieScrollView.addSubview(imageView!)
        imageView!.frame = CGRect(x: 0.0, y: 0.0, width: movieScrollView.frame.size.width, height: movieScrollView.frame.height/3)
        movieScrollView.contentSize = CGSize(width: movieScrollView.frame.size.width, height: addMovieDetailsLabels())
        //addHorizontalScrollView()
        movieScrollView.clipsToBounds = true
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func addMovieDetailsLabels() -> CGFloat{
        var heightSoFar = imageView?.frame.size.height
        heightSoFar! += addLabel(title: "Release Date", text: self.date!, howManyLabelsWhereAddedBefore: 0, heightSoFar: heightSoFar!,isClickable: false, trailerKey: "")
        heightSoFar! += addLabel(title: "Voting Average", text: self.voting!, howManyLabelsWhereAddedBefore: 1, heightSoFar: heightSoFar!,isClickable: false, trailerKey: "")
        heightSoFar! += addLabel(title: "Description", text: movieDescription!, howManyLabelsWhereAddedBefore: 2, heightSoFar: heightSoFar!,isClickable: false, trailerKey: "")
         heightSoFar! += addLabel(title: "Trailers", text: "", howManyLabelsWhereAddedBefore: 3, heightSoFar: heightSoFar!,isClickable: false, trailerKey: "")
        for index in 0 ..< trailers.count {
            heightSoFar! += addLabel(title: "", text: trailers[index].0, howManyLabelsWhereAddedBefore: index + 4, heightSoFar: heightSoFar!, isClickable: true, trailerKey: trailers[index].1)
        }
        return heightSoFar!
    }
    
    func addHorizontalScrollView(){ // to be added
        let horizontalScrollView = UIScrollView()
        horizontalScrollView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        movieScrollView.addSubview(horizontalScrollView)
        horizontalScrollView.leftAnchor.constraint(equalTo: movieScrollView.leftAnchor, constant: 0.0).isActive = true
        horizontalScrollView.rightAnchor.constraint(equalTo: movieScrollView.rightAnchor, constant: 1000.0).isActive = true
        horizontalScrollView.topAnchor.constraint(equalTo: movieScrollView.topAnchor, constant: 100.0).isActive = true
        horizontalScrollView.bottomAnchor.constraint(equalTo: movieScrollView.bottomAnchor, constant: 120).isActive = true
        let image = UIImageView(image: imageView?.image)
        image.frame.size.width = 50.0
        image.frame.size.height = 50.0
        horizontalScrollView.addSubview(image)
        horizontalScrollView.addSubview(image)
        horizontalScrollView.addSubview(image)
        horizontalScrollView.addSubview(image)
        horizontalScrollView.addSubview(image)
    }
    
    func addLabel(title: String, text: String, howManyLabelsWhereAddedBefore: Int, heightSoFar: CGFloat, isClickable: Bool, trailerKey: String)->CGFloat{
        let titleAttrString = NSAttributedString(string: title, attributes: returnStringAttributes(size: 15, isClickable: false))
        let textAttrString = NSAttributedString(string: text, attributes: returnStringAttributes(size: 13, isClickable: isClickable))
        let titleLabel = UILabel()
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        titleLabel.attributedText = titleAttrString
        textLabel.attributedText = textAttrString
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    @objc
    func trailerTapped(sender: MyTapGesture){
        if let youtubeURL = URL(string: "youtube://\(sender.title)"),
            UIApplication.shared.openURL(youtubeURL) {
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(sender.title)") {
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var title = String()
}
