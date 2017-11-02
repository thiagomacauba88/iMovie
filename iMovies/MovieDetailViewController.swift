//
//  MovieDetailViewController.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 02/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailViewController: UIViewController {

    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var plotTextView: UITextView!
    @IBOutlet var actorsLabel: UILabel!
    @IBOutlet var directorLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var releasedLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    var movieId : String?
    var movie : MovieDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMoviesById(movieId: movieId!)
        
        print(movieId)
        // Do any additional setup after loading the view.
    }

    func setupComponents(movie: MovieDetail) {
        
        self.titleLabel.text = movie.title!+" ("+movie.year!+")"
        self.releasedLabel.text = movie.released
        self.genreLabel.text = movie.genre
        self.directorLabel.text = movie.director
        self.actorsLabel.text = movie.actors
        self.plotTextView.text = movie.plot
        self.runtimeLabel.text = movie.runtime
        let downloadURL = NSURL(string: (movie.posterImage)!)
        self.imageView.af_setImage(withURL: downloadURL! as URL)
        
    }
    func getMoviesById(movieId : String) {
        
        ServiceHelper().getMovieById(movieId: movieId, handler: {
            (movie) in
            self.setupComponents(movie: movie.value!)
            self.movie = movie.value
        })
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
