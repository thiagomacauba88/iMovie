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
        
        //self.iCarouselView
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getMovieCoredata()
        //self.iCarouselView.reloadData()
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
        gradient.colors = [UIColor.black.cgColor,UIColor(red: 128, green: 0, blue: 0, alpha: 1), UIColor.red.cgColor]//UIColor(red: 128, green: 0, blue: 0, alpha: 1).cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setBackgroundImage() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        self.backgroundImage.addSubview(blurView)
    }
    
        //
        //+" ("+self.moviesCoreData?.first?.value(forKey: "year")+")"
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
    
    
//    func loadCompents(){
//        
//        self.countriesCoreData = Networker().getCountriesCoreData() as [NSManagedObject]
//        
//        for countryCoreData in countriesCoreData{
//            if let uid = countryCoreData.value(forKey: "id") as? Int64{
//                self.country?.uid = uid
//            }
//            if let callingCode = countryCoreData.value(forKey: "callingCode") as? String{
//                self.country?.callingCode = callingCode
//            }
//            if let culture = countryCoreData.value(forKey: "culture") as? String{
//                self.country?.culture = culture
//            }
//            if let iso = countryCoreData.value(forKey: "iso") as? String{
//                self.country?.iso = iso
//            }
//            if let longname = countryCoreData.value(forKey: "longname") as? String{
//                self.country?.longname = longname
//            }
//            if let shortname = countryCoreData.value(forKey: "shortname") as? String{
//                self.country?.shortname = shortname
//            }
//            if let status = countryCoreData.value(forKey: "status") as? Int{
//                self.country?.status = status
//            }
//            self.countries.append(self.country!)
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if self.moviesCoreData == nil {
            return 0
        }
        return (self.moviesCoreData?.count)!
    }
    
    
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
         //self.titleLabel.text = self.moviesCoreData?[carousel.currentItemIndex].value(forKey: "title") as? String
        
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        self.movieSelected = self.moviesCoreData?[index]
        performSegue(withIdentifier: "movieDetailSegue", sender: self)
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if self.moviesCoreData?.count != 0 {
//            self.titleLabel.text = self.moviesCoreData?[carousel.currentItemIndex].value(forKey: "title") as? String
//            
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
        //tempView.backgroundColor = UIColor.black
        return tempView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegue" {
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            movieDetailViewController.movieId = self.movieSelected?.value(forKey: "imdbID") as? String
        }
    }

}
