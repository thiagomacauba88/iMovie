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

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var teste: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var plotTextView: UITextView!
    @IBOutlet var actorsLabel: UILabel!
    @IBOutlet var directorLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var releasedLabel: UILabel!
    
    var movieId : String?
    var movie : MovieDetail?
    var movieDetail : MovieDetail?
    var movieCoreData : NSManagedObject?
    var moviesCoreData : [NSManagedObject]?
    var rightButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        if let movieId = self.movieId {
            self.getMoviesById(movieId: movieId)
        }
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
                self.moviesCoreData = ServiceHelper().getMovieById(uid: movieId)
            }
        } else {
            self.setRightButton(isWhatched: false)
            if let imdbID = self.movieCoreData?.value(forKey: "imdbID") as? String, let movieId = self.movieId {
                ServiceHelper().removeMovieCoreData(movieId: imdbID)
                self.moviesCoreData = ServiceHelper().getMovieById(uid: movieId)
            }
        }
    }

    func setBackgroundImage() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        self.backgroundImage.addSubview(blurView)
    }
    func setupComponents(movie: MovieDetail) {
    
        self.titleLabel.text = movie.title
        self.yearLabel.text = movie.year
        self.releasedLabel.text = movie.released
        self.genreLabel.text = movie.genre
        self.directorLabel.text = movie.director
        self.actorsLabel.text = movie.actors
        self.plotTextView.text = movie.plot
        self.runtimeLabel.text = movie.runtime
        guard let posterImage = movie.posterImage else{
            return
        }
        if let downloadURL = NSURL(string: posterImage) {
            self.backgroundImage.af_setImage(withURL: downloadURL as URL)
        }
        self.backgroundImage.addBlackGradientLayer(frame: view.bounds, colors:[.clear, .black])
    }
    
    func getMoviesById(movieId : String) {
        
        self.moviesCoreData = ServiceHelper().getMovieById(uid: movieId)
        if self.moviesCoreData?.count != 0 {
            self.movieCoreData = self.moviesCoreData?.first
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
        self.titleLabel.text = self.movieCoreData?.value(forKey: "title") as? String
        self.yearLabel.text = self.movieCoreData?.value(forKey: "year") as? String
        self.releasedLabel.text = self.movieCoreData?.value(forKey: "released") as? String
        self.genreLabel.text = self.movieCoreData?.value(forKey: "genre") as? String
        self.directorLabel.text = self.movieCoreData?.value(forKey: "director") as? String
        self.actorsLabel.text = self.movieCoreData?.value(forKey: "actors") as? String
        self.plotTextView.text = self.movieCoreData?.value(forKey: "plot") as? String
        self.runtimeLabel.text = self.movieCoreData?.value(forKey: "runtime") as? String
        
        guard let posterImage = self.movieCoreData?.value(forKey: "posterImage") as? String else{
            return
        }
        if let downloadURL = NSURL(string: posterImage) {
            self.backgroundImage.af_setImage(withURL: downloadURL as URL)
        }
        self.backgroundImage.addBlackGradientLayer(frame: view.bounds, colors:[.clear, .black])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
