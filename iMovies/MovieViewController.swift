//
//  ViewController.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 02/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//

import UIKit
import iCarousel
import AlamofireImage
import KRProgressHUD
import CoreData

class MovieViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var clickMovieLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var notFoundMovieView: UIView!
    @IBOutlet var tableView: UITableView!
    var rightButton: UIButton?
    var moviesList : Movies?
    var pageNumber : Int = 2
    var totalPages : Int?
    var searchBar : UISearchBar?
    var movieSelectedId : String?
    var moviesCoreData : [NSManagedObject]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        self.backgroundImage.addBlackGradientLayer(frame: view.bounds, colors:[.clear, .black])
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupNavigationBar()
        self.searchBar?.delegate = self
        
        //self.getMoviesList(movieName: "back", pageNumber: "")
        self.showAddedButton()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.searchBar?.text = nil
        self.searchBar?.setShowsCancelButton(false, animated: true)
        
        // Remove focus from the search bar.
        self.searchBar?.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.moviesCoreData = ServiceHelper().getMoviesCoreData()
        if (self.moviesCoreData?.count)! > 0 {
            self.addButton.isHidden = true
            self.clickMovieLabel.isHidden = true
        } else {
            self.setGradientView()
            self.addButton.isHidden = false
            self.clickMovieLabel.isHidden = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showAddedButton() {
        self.moviesCoreData = ServiceHelper().getMoviesCoreData()
        
        if (self.moviesCoreData?.count)! == 0 {
            self.tableView.isHidden = true
            self.containerView.isHidden = true
            self.clickMovieLabel.isHidden = false
            self.addButton.isHidden = false
            //let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            
//            self.view.backgroundColor = UIColor.clear
//            
//            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = self.view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            
//            self.view.addSubview(blurEffectView)
            
            self.setGradientView()
            
        }
    }
    
    func setGradientView() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        //gradient.colors = [UIColor.black.cgColor,UIColor(red: 128, green: 0, blue: 0, alpha: 1), UIColor.red.cgColor]//UIColor(red: 128, green: 0, blue: 0, alpha: 1).cgColor]
        
        gradient.colors = [UIColor.black.cgColor,UIColor.lightGray.cgColor]//UIColor(red: 128, green: 0, blue: 0, alpha: 1).cgColor]
        //gradient.colors = [UIColor(red: 69, green: 183, blue: 227, alpha: 1).cgColor,UIColor(red: 151, green: 99, blue: 57, alpha: 1).cgColor]//UIColor(red: 128, green: 0, blue: 0, alpha: 1).cgColor]
        
        //69,183,227
        //151,99,57
        view.layer.insertSublayer(gradient, at: 0)
    }
    func totalPages(totalPages : String) -> Int {
            
            let totalResultsInt = Int(totalPages)
            self.totalPages = Int(totalPages)!-Int(totalPages)!%10
            self.totalPages = self.totalPages!/10
            
            if totalResultsInt!%10 != 0{
                self.totalPages? += 1
            }
            
            print (self.totalPages)
            return self.totalPages!

        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.isHidden = false
        self.containerView.isHidden = true
        self.addButton.isHidden = true
        self.clickMovieLabel.isHidden = true
        self.getMoviesList(movieName: searchBar.text!, pageNumber: "")
        self.tableView.reloadData()
        self.setGradientView()
        
    }
    
    func getMoviesList(movieName : String, pageNumber: String) {
        
        ServiceHelper().getMovies(movieName: movieName, pageNumber: pageNumber, handler: {
            (moviesList) in
            
            if moviesList.value?.response != "False" {
                self.totalPages = self.totalPages(totalPages: (moviesList.value?.totalResults)!)
                //self.tableView.reloadData()
                if pageNumber != "" {
                    self.pageNumber += 1
                    for item in (moviesList.value?.search)! {
                        self.moviesList?.search?.append(item)
                    }
                } else {
                    self.moviesList = moviesList.value
                    //self.nextPageToken = (self.videoList?.nextPageToken)!
                }
            } else {
                self.moviesList = nil
            }
            
            self.tableView.reloadData()
            KRProgressHUD.dismiss()
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
            KRProgressHUD.show()
            if self.pageNumber <= self.totalPages! {
                self.getMoviesList(movieName: "back", pageNumber: self.pageNumber.description)
            }
            
        }
    }
    
    
    
    func addTapped(sender: UIBarButtonItem) {
        
        self.createSearchBar()
        
    }
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.title = "iMovie"
        self.navigationItem.title = "iMovie"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
//        let logo = UIImage(named: "logoImage")
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        imageView.image = logo
//        imageView.contentMode = .scaleAspectFit // set imageview's content mode
//        self.navigationItem.titleView = imageView
        
        
        self.rightButton = UIButton.init(type: .custom)
        self.rightButton?.titleLabel?.textAlignment = .right
        self.rightButton?.titleLabel?.font = UIFont(name: "Helvetica" , size: 12)
        self.rightButton?.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0)
        //if self.cancelButtonShowed {
        //    self.rightButton?.setTitle("Cancel", for: .normal)
        //} else {
            self.rightButton?.setImage(UIImage(named: "searchIcon"), for: UIControlState.normal)
        //}
        self.rightButton?.isUserInteractionEnabled = true
        self.rightButton?.addTarget(self, action:  #selector(addTapped(sender:)), for: .touchUpInside)
        self.rightButton?.frame = CGRect(x: 0, y: 0, width: 18, height: 20)
        let buttonBar = UIBarButtonItem.init(customView: self.rightButton!)
        self.navigationItem.rightBarButtonItem = buttonBar
    }
    func createSearchBar() {
        
        self.navigationItem.rightBarButtonItem = nil
        self.searchBar = UISearchBar()
        
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Helvetica", size: 12)!,NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        self.searchBar?.placeholder = "Digite algo"
        self.searchBar?.delegate = self
        
        self.navigationItem.titleView = searchBar
        //self.searchBar?.showsCancelButton = true
        self.searchBar?.setShowsCancelButton(true, animated: true)
        self.searchBar?.becomeFirstResponder()
        //self.setupNavigationBar()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.setShowsCancelButton(false, animated: true)
        self.searchBar?.removeFromSuperview()
        self.setupNavigationBar()
        self.tableView.isHidden = true
        self.notFoundMovieView.isHidden = true
        self.containerView.isHidden = false
        
        
        if self.moviesCoreData?.count == 0 {
            self.addButton.isHidden = false
            self.clickMovieLabel.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegue" {
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            movieDetailViewController.movieId = self.movieSelectedId
        }
    }
    @IBAction func addButton(_ sender: Any) {
        self.createSearchBar()
    }
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        
        if self.moviesList == nil {
            self.tableView.isHidden = true
            if self.searchBar?.text != nil && self.searchBar?.text != ""{
                self.notFoundMovieView.isHidden = false

            }
            
            return 0
        } else {
            self.tableView.isHidden = false
            self.notFoundMovieView.isHidden = true
            self.addButton.isHidden = true
            return (self.moviesList?.search?.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        let item = self.moviesList?.search?[indexPath.row]
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        //let yearLabel = cell.contentView.viewWithTag(3) as! UILabel
        titleLabel.text = item?.title
        //yearLabel.text = item?.year
        let downloadURL = NSURL(string: (item?.posterImage)!)
        imageView.af_setImage(withURL: downloadURL! as URL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = self.moviesList?.search?[indexPath.row]
        self.movieSelectedId = movie?.imdbID
        performSegue(withIdentifier: "movieDetailSegue", sender: self)
        
//        if !self.removeButton.isEnabled {
//            self.countrySelected = country
//            performSegue(withIdentifier: "showDetail", sender: self)
//        }
//        else{
//            print(country.value(forKey: "shortname") as! String)
//            
//            let id = country.value(forKey: "id") as! Int64
//            if !self.selectedCoutries.contains(id){
//                self.selectedCoutries.append(id)
//                self.selectedRowsInTableView.append(indexPath.row)
//            }
//            if self.selectedCoutries.count > 0{
//                self.removeButton.title = "Remover(\(self.selectedCoutries.count))"
//            }
//            else{
//                self.removeButton.title = "Remover todos"
//            }
//            print(self.selectedCoutries)
//        }
        
    }
}

extension UIImageView{
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
}
