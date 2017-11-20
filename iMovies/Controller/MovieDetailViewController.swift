//
//  MovieDetailViewController.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 02/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData
import AlamofireObjectMapper
import ObjectMapper


class MovieDetailViewController: UIViewController {

    @IBOutlet var detailView: UIView!
    @IBOutlet var noImageLittle: UILabel!
    @IBOutlet var noImageLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var imbdRating: UILabel!
    @IBOutlet var plotTextView: UITextView!
    @IBOutlet var actorsLabel: UILabel!
    @IBOutlet var directorLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var writerLabel: UILabel!
    @IBOutlet var awardsLabel: UILabel!
    @IBOutlet var releasedLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    var movieId : String?
    var movie : MovieDetail?
    var movieDetail : MovieDetail?
    var movieCoreData : NSManagedObject?
    var movieEntity : [MovieDetailEntity]?
    var rightButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradient()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        if let movieId = self.movieId {
            self.getMoviesById(movieId: movieId)
        }
    }
    
    func setGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.detailView.bounds
        gradient.colors = []
        gradient.colors = [UIColor(red: 2, green: 43, blue: 54, alpha: 1),UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor]
        self.detailView.layer.insertSublayer(gradient, at: 0)
    }
    func setRightButton(isWhatched: Bool){
        self.rightButton = UIButton.init(type: .custom)
        self.rightButton?.titleLabel?.textAlignment = .right
        self.rightButton?.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0)
        if isWhatched {
            self.rightButton?.setImage(UIImage(named: "savedIcon"), for: UIControlState.normal)
            self.rightButton?.tag = 1
        } else {
            self.rightButton?.setImage(UIImage(named: "notSavedIcon"), for: UIControlState.normal)
            self.rightButton?.tag = 0
        }
        self.rightButton?.isUserInteractionEnabled = true
        self.rightButton?.addTarget(self, action:  #selector(watchedButton(sender:)), for: .touchUpInside)
        self.rightButton?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.rightButton?.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.rightButton?.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        guard let rightButton = self.rightButton else {
            return
        }
        let buttonBar = UIBarButtonItem.init(customView: rightButton)
        self.navigationItem.rightBarButtonItem = buttonBar
    }
    
    func watchedButton(sender: UIButton) {
        if sender.tag == 0 {
            self.setRightButton(isWhatched: true)
            if let movie = self.movie, let movieId = self.movieId {
                ServiceHelper().saveMovieCoredata(movie: movie)
                self.movieEntity = ServiceHelper().getMovieById(uid: movieId)
            }
        } else {
            self.setRightButton(isWhatched: false)
            if let imdbID = self.movieEntity?.first?.imdbID, let movieId = self.movieId {
                ServiceHelper().removeMovieCoreData(movieId: imdbID)
                self.movieEntity = ServiceHelper().getMovieById(uid: movieId)
            }
        }
    }

    func setupComponents(movie: MovieDetail) {
        self.titleLabel.text = movie.title
        self.awardsLabel.text = movie.awards
        self.writerLabel.text = movie.writer
        self.releasedLabel.text = movie.released
        self.genreLabel.text = movie.genre
        self.directorLabel.text = movie.director
        self.actorsLabel.text = movie.actors
        self.plotTextView.text = movie.plot
        self.yearLabel.text = movie.year
        self.runtimeLabel.text = movie.runtime
        self.typeLabel.text = movie.type
        guard let posterImage = movie.posterImage else{
            return
        }
        if let downloadURL = NSURL(string: posterImage), let imdbRating = movie.imdbRating {
            if posterImage == "N/A" {
                //self.movieImage.image = #imageLiteral(resourceName: "noImage")
                self.noImageLabel.isHidden = false
                self.noImageLittle.isHidden = false
            } else{
                self.backgroundImage.af_setImage(withURL: downloadURL as URL)
                self.movieImage.af_setImage(withURL: downloadURL as URL)
            }
            self.imbdRating.text =  imdbRating+" IMDB"
        }
        self.backgroundImage.addBlackGradientLayer(frame: view.bounds, colors:[.clear, .black])
    }
    
    func getMoviesById(movieId : String) {
        
        self.movieEntity = ServiceHelper().getMovieById(uid: movieId)
        if self.movieEntity?.count != 0 {
            self.fillModelByCoreData()
            self.setRightButton(isWhatched: true)
        } else {
            ServiceHelper().getMovieById(movieId: movieId, handler: {
                (movie) in
                guard let movieValue = movie.value else {
                    return
                }
                self.setupComponents(movie: movieValue)
                self.movie = movie.value
                self.setRightButton(isWhatched: false)
                 self.setupComponents(movie: movieValue)
            })
        }
    }

    func fillModelByCoreData(){
        self.titleLabel.text = self.movieEntity?.first?.title
        self.awardsLabel.text = self.movieEntity?.first?.awards
        self.writerLabel.text = self.movieEntity?.first?.writer
        self.releasedLabel.text = self.movieEntity?.first?.released
        self.genreLabel.text = self.movieEntity?.first?.genre
        self.directorLabel.text = self.movieEntity?.first?.director
        self.actorsLabel.text = self.movieEntity?.first?.actors
        self.typeLabel.text = self.movieEntity?.first?.type
        self.plotTextView.text = self.movieEntity?.first?.plot
        self.imbdRating.text =  self.movieEntity?.first?.imdbRating
        self.yearLabel.text = self.movieEntity?.first?.year
        self.runtimeLabel.text = self.movieEntity?.first?.runtime
        
        guard let posterImage = self.movieEntity?.first?.posterImage else{
            return
        }
        if let downloadURL = NSURL(string: posterImage), let imdbRating = self.movieEntity?.first?.imdbRating {
            if posterImage == "N/A" {
                self.noImageLabel.isHidden = false
                self.noImageLittle.isHidden = false
                
            } else{
                self.backgroundImage.af_setImage(withURL: downloadURL as URL)
                self.movieImage.af_setImage(withURL: downloadURL as URL)
            }
            self.imbdRating.text =  imdbRating+" IMDB"
        }
        self.backgroundImage.addBlackGradientLayer(frame: view.bounds, colors:[.clear, .black])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
