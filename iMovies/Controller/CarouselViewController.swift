//
//  CarouselViewController.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 03/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//
//

import UIKit
import iCarousel
import CoreData
import AlamofireImage

class CarouselViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {

    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var iCarouselView: iCarousel!
    @IBOutlet var titleLabel: UILabel!
    var movieEntity : [MovieDetailEntity]?
    var movieSelected : NSManagedObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iCarouselView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getMovieCoredata()
    }
    
    func getMovieCoredata () {
        
        self.movieEntity = ServiceHelper().getMoviesCoreData()
        guard let count = self.movieEntity?.count else {
            return
        }
        if count > 0 {
            self.titleLabel.text = self.movieEntity?.first?.title
            guard let titleLabelText = self.titleLabel.text else {
                return
            }
            self.titleLabel.text = titleLabelText+" ("
            guard let firstMovie = self.movieEntity?.first?.year else {
                return
            }
            if let titleText = self.titleLabel.text {
                self.titleLabel.text = titleText+firstMovie+")"
            }
            self.setBackgroundImage()
            if let imageUrl = self.movieEntity?.first?.posterImage {
                if let downloadURL = NSURL(string: imageUrl) {
                    self.backgroundImage.af_setImage(withURL: downloadURL as URL)
                }
            }
            self.backgroundImage.addBlackGradientLayer(frame: view.bounds, colors:[.clear, .black])
        } else {
            self.titleLabel.text = ""
            self.setGradientView()
        }
        iCarouselView.reloadData()
        iCarouselView.type = .rotary
        iCarouselView.scrollSpeed = 0.3
    }
    
    func setGradientView() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.black.cgColor,UIColor.darkGray.cgColor, UIColor.gray.cgColor, UIColor.lightGray.cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setBackgroundImage() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        self.backgroundImage.addSubview(blurView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if self.movieEntity == nil {
            return 0
        }
        if let count = self.movieEntity?.count {
            return count
        } else {
            return 0
        }
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        self.movieSelected = self.movieEntity?[index]
        performSegue(withIdentifier: "movieDetailSegue", sender: self)
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        guard let count = self.movieEntity?.count else {
            return
        }
        if count != 0 {
            self.titleLabel.text = self.movieEntity?[carousel.currentItemIndex].title
            if var titleText = self.titleLabel.text, let year = self.movieEntity?[carousel.currentItemIndex].year {
                titleText = titleText+" ("
                titleText = titleText+year+")"
                self.titleLabel.text = titleText
            }
            
            //self.titleLabel.text = self.titleLabel.text!+(self.movieEntity?[carousel.currentItemIndex].year)!+")"
            guard let imageUrl = self.movieEntity?[carousel.currentItemIndex].posterImage else {
                return
            }
            if let downloadURL = NSURL(string: imageUrl) {
                self.backgroundImage.af_setImage(withURL: downloadURL as URL)
            }
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageUrl = self.movieEntity?[index].posterImage
        let tempView = UIView(frame: CGRect(x:0, y:0, width: self.iCarouselView.frame.width, height: self.iCarouselView.frame.height))
        tempView.backgroundColor = UIColor.clear
        let frame = CGRect(x:0, y:0, width: self.iCarouselView.frame.width, height: self.iCarouselView.frame.height)
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.frame = frame
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        if let image = imageUrl {
            let downloadURL = NSURL(string: image)
            if let url = downloadURL {
                imageView.af_setImage(withURL: url as URL)
            }
        }
        tempView.addSubview(imageView)
        return tempView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegue" {
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            movieDetailViewController.movieId = self.movieSelected?.value(forKey: "imdbID") as? String
        }
    }
}
