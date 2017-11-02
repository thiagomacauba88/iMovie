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

class MovieViewController: UIViewController, UISearchBarDelegate, iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var iCarouselView: iCarousel!
    var rightButton: UIButton?
    var moviesList : Movies?
    var pageNumber : Int = 2
    var totalPages : Int?
    var searchBar : UISearchBar?
    var movieSelectedId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupNavigationBar()
        self.searchBar?.delegate = self
        //iCarouselView.reloadData()
        //iCarouselView.type = .rotary
        self.getMoviesList(movieName: "back", pageNumber: "")
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
        self.getMoviesList(movieName: searchBar.text!, pageNumber: "")
        self.tableView.reloadData()
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
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 5
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let tempView = UIView(frame: CGRect(x:0, y:0, width: 200, height: 200))
        tempView.backgroundColor = UIColor.white
        return tempView
    }
    
    func addTapped(sender: UIBarButtonItem) {
        self.createSearchBar()
    }
    func setupNavigationBar() {
        let logo = UIImage(named: "logoImage")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = logo
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        self.rightButton = UIButton.init(type: .custom)
        self.rightButton?.setImage(UIImage(named: "searchIcon"), for: UIControlState.normal)
        self.rightButton?.isUserInteractionEnabled = true
        self.rightButton?.addTarget(self, action:  #selector(addTapped(sender:)), for: .touchUpInside)
        self.rightButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        let buttonBar = UIBarButtonItem.init(customView: self.rightButton!)
        self.navigationItem.rightBarButtonItem = buttonBar
    }
    func createSearchBar() {
        
        self.searchBar = UISearchBar()
        self.searchBar?.showsCancelButton = false
        self.searchBar?.placeholder = "Digite algo"
        self.searchBar?.delegate = self
        
        self.navigationItem.titleView = searchBar
        self.rightButton?.titleLabel?.text = "Cancel"
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
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.moviesList == nil {
            return 0
        } else {
            return (self.moviesList?.search?.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = self.moviesList?.search?[indexPath.row]
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        let yearLabel = cell.contentView.viewWithTag(3) as! UILabel
        titleLabel.text = item?.title
        yearLabel.text = item?.year
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

