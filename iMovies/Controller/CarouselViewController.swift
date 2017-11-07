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
    var moviesCoreData : [NSManagedObject]?
    var movieSelected : NSManagedObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iCarouselView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getMovieCoredata()
    }
    
    func getMovieCoredata () {
        
        self.moviesCoreData = ServiceHelper().getMoviesCoreData()
        if (self.moviesCoreData?.count)! > 0 {
            self.titleLabel.text = self.moviesCoreData?.first?.value(forKey: "title") as? String
            self.titleLabel.text = self.titleLabel.text!+" ("
            self.titleLabel.text = self.titleLabel.text!+(self.moviesCoreData?.first?.value(forKey: "year")as? String)!+")"
            self.setBackgroundImage()
            let imageUrl = self.moviesCoreData?.first?.value(forKey: "posterImage") as? String
            let downloadURL = NSURL(string: imageUrl!)
            self.backgroundImage.af_setImage(withURL: downloadURL! as URL)
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
        if self.moviesCoreData == nil {
            return 0
        }
        return (self.moviesCoreData?.count)!
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        self.movieSelected = self.moviesCoreData?[index]
        performSegue(withIdentifier: "movieDetailSegue", sender: self)
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if self.moviesCoreData?.count != 0 {
            self.titleLabel.text = self.moviesCoreData?[carousel.currentItemIndex].value(forKey: "title") as? String
            self.titleLabel.text = self.titleLabel.text!+" ("
            self.titleLabel.text = self.titleLabel.text!+(self.moviesCoreData?[carousel.currentItemIndex].value(forKey: "year")as? String)!+")"
            let imageUrl = self.moviesCoreData?[carousel.currentItemIndex].value(forKey: "posterImage") as? String
            let downloadURL = NSURL(string: imageUrl!)
            self.backgroundImage.af_setImage(withURL: downloadURL! as URL)
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageUrl = self.moviesCoreData?[index].value(forKey: "posterImage") as? String
        let tempView = UIView(frame: CGRect(x:0, y:0, width: self.iCarouselView.frame.width, height: self.iCarouselView.frame.height))
        tempView.backgroundColor = UIColor.clear
        let frame = CGRect(x:0, y:0, width: self.iCarouselView.frame.width, height: self.iCarouselView.frame.height)
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.frame = frame
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        let downloadURL = NSURL(string: imageUrl!)
        imageView.af_setImage(withURL: downloadURL! as URL)
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
