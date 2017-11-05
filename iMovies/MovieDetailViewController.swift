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
        
        //ServiceHelper().removeMovieCoreData(movieId: (self.movieCoreData?.value(forKey: "imdbID") as? String)!)
        //ServiceHelper().saveMovieCoredata(movie: self.movie!)
        self.getMoviesById(movieId: self.movieId!)
        
        print(movieId)
        // Do any additional setup after loading the view.
    }
    
    func setRightButton(isWhatched: Bool){
        self.rightButton = UIButton.init(type: .custom)
        self.rightButton?.titleLabel?.textAlignment = .right
        //self.rightButton?.titleLabel?.font = UIFont(name: "Helvetica" , size: 12)
        self.rightButton?.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0)
        //if self.cancelButtonShowed {
        //    self.rightButton?.setTitle("Cancel", for: .normal)
        //} else {
        if isWhatched {
            self.rightButton?.setImage(UIImage(named: "savedIcon"), for: UIControlState.normal)
            self.rightButton?.tag = 1
        } else {
            self.rightButton?.setImage(UIImage(named: "notSavedIcon"), for: UIControlState.normal)
            self.rightButton?.tag = 0
        }
        
        //}
        self.rightButton?.isUserInteractionEnabled = true
        self.rightButton?.addTarget(self, action:  #selector(watchedButton(sender:)), for: .touchUpInside)
        self.rightButton?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let buttonBar = UIBarButtonItem.init(customView: self.rightButton!)
        self.navigationItem.rightBarButtonItem = buttonBar
    }
    
    func watchedButton(sender: UIButton) {
        
        if sender.tag == 0 {
            self.setRightButton(isWhatched: true)
            ServiceHelper().saveMovieCoredata(movie: self.movie!)
            self.moviesCoreData = ServiceHelper().getMovieById(uid: movieId!)
            //self.movieCoreData = self.moviesCoreData?.first
        } else {
            self.setRightButton(isWhatched: false)
            ServiceHelper().removeMovieCoreData(movieId: (self.movieCoreData?.value(forKey: "imdbID") as? String)!)
            self.moviesCoreData = ServiceHelper().getMovieById(uid: movieId!)
        }
    }

    func setBackgroundImage() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        self.backgroundImage.addSubview(blurView)
    }
    func setupComponents(movie: MovieDetail) {
    
        self.title = movie.title!
        self.yearLabel.text = movie.year
        self.releasedLabel.text = movie.released
        self.genreLabel.text = movie.genre
        self.directorLabel.text = movie.director
        self.actorsLabel.text = movie.actors
        self.plotTextView.text = movie.plot
        self.runtimeLabel.text = movie.runtime
        
        let downloadURL = NSURL(string: (movie.posterImage)!)
        self.imageView.af_setImage(withURL: downloadURL! as URL)
        self.backgroundImage.af_setImage(withURL: downloadURL! as URL)
        self.backgroundImage.addBlackGradientLayer(frame: view.bounds, colors:[.clear, .black])
        self.setBackgroundImage()
    }
    func getMoviesById(movieId : String) {
        
        self.moviesCoreData = ServiceHelper().getMovieById(uid: movieId)
        if self.moviesCoreData?.count != 0 {
            self.movieCoreData = self.moviesCoreData?.first
            //self.setupComponents(movie: self.fillModelByCoreData())
            self.fillModelByCoreData()
            self.setRightButton(isWhatched: true)
        } else {
            ServiceHelper().getMovieById(movieId: movieId, handler: {
                (movie) in
                self.setupComponents(movie: movie.value!)
                self.movie = movie.value
                self.setRightButton(isWhatched: false)
                //ServiceHelper().saveMovieCoredata(movie: self.movie!)
                 self.setupComponents(movie: self.movie!)
            })
        }
        
        
        /*ServiceHelper().getMovieById(movieId: movieId, handler: {
            (movie) in
            self.setupComponents(movie: movie.value!)
            self.movie = movie.value
            /*ServiceHelper().saveMovieCoredata(movie: self.movie!)
            
            if let movieId = self.movieId{
                self.movieCoreData = ServiceHelper().getMovieById(uid: movieId)
                self.movie?.actors = self.movieCoreData?.value(forKey: "actors") as? String
                self.movie?.director = self.movieCoreData?.value(forKey: "director") as? String
                self.movie?.genre = self.movieCoreData?.value(forKey: "genre") as? String
                self.movie?.imdbID = self.movieCoreData?.value(forKey: "imdID") as? String
                self.movie?.plot = self.movieCoreData?.value(forKey: "plot") as? String
                self.movie?.posterImage = self.movieCoreData?.value(forKey: "posterImage") as? String
                self.movie?.released = self.movieCoreData?.value(forKey: "released") as? String
                self.movie?.runtime = self.movieCoreData?.value(forKey: "runtime") as? String
                self.movie?.title = self.movieCoreData?.value(forKey: "title") as? String
                self.movie?.year = self.movieCoreData?.value(forKey: "year") as? String
            }
            self.setupComponents(movie: self.movie!)*/
        })*/
    }
    
    func fillModelByCoreData()/* -> MovieDetail*/{
        
        
        self.title = self.movieCoreData?.value(forKey: "title") as? String
        
        self.yearLabel.text = self.movieCoreData?.value(forKey: "year") as? String
        self.releasedLabel.text = self.movieCoreData?.value(forKey: "released") as? String
        self.genreLabel.text = self.movieCoreData?.value(forKey: "genre") as? String
        self.directorLabel.text = self.movieCoreData?.value(forKey: "director") as? String
        self.actorsLabel.text = self.movieCoreData?.value(forKey: "actors") as? String
        self.plotTextView.text = self.movieCoreData?.value(forKey: "plot") as? String
        self.runtimeLabel.text = self.movieCoreData?.value(forKey: "runtime") as? String
        self.setBackgroundImage()
        let downloadURL = NSURL(string: (self.movieCoreData?.value(forKey: "posterImage") as? String)!)
        self.imageView.af_setImage(withURL: downloadURL! as URL)
        self.backgroundImage.af_setImage(withURL: downloadURL! as URL)
        self.backgroundImage.addBlackGradientLayer(frame: view.bounds, colors:[.clear, .black])
        
//        self.movie?.actors = self.movieCoreData?.value(forKey: "actors") as? String
//        self.movie?.director = self.movieCoreData?.value(forKey: "director") as? String
//        self.movie?.genre = self.movieCoreData?.value(forKey: "genre") as? String
//        self.movie?.imdbID = self.movieCoreData?.value(forKey: "imdID") as? String
//        self.movie?.plot = self.movieCoreData?.value(forKey: "plot") as? String
//        self.movie?.posterImage = self.movieCoreData?.value(forKey: "posterImage") as? String
//        self.movie?.released = self.movieCoreData?.value(forKey: "released") as? String
//        self.movie?.runtime = self.movieCoreData?.value(forKey: "runtime") as? String
//        self.movie?.title = self.movieCoreData?.value(forKey: "title") as? String
//        self.movie?.year = self.movieCoreData?.value(forKey: "year") as? String
        
        //return self.movie!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}