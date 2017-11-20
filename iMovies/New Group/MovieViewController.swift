//
//  ViewController.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 02/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//

import UIKit
import iCarousel
import Alamofire
import AlamofireImage
import KRProgressHUD
import CoreData

class MovieViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var notFoundLabel: UILabel!
    @IBOutlet var clickMovieLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var notFoundMovieView: UIView!
    @IBOutlet var tableView: UITableView!
    var rightButton: UIButton?
    var moviesList : Movies?
    var pageNumber : Int = 2
    var totalPages : Int = 0
    var searchBar : UISearchBar?
    var movieSelectedId : String?
    var movieEntity : [MovieDetailEntity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupNavigationBar()
        self.searchBar?.delegate = self
        self.showAddedButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.titleView = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.movieEntity = ServiceHelper().getMoviesCoreData()
        guard let moviesCount = self.movieEntity?.count else {
            return
        }
        if moviesCount > 0 {
            self.addButton.isHidden = true
            self.clickMovieLabel.isHidden = true
            self.containerView.isHidden = false
        } else {
            self.setGradientView()
            self.addButton.isHidden = false
            self.clickMovieLabel.isHidden = false
        }
        if self.navigationItem.titleView == nil{
            self.tableView.isHidden = true
        }
        self.setupNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showAddedButton() {
        self.movieEntity = ServiceHelper().getMoviesCoreData()
        guard let moviesCount = self.movieEntity?.count else {
            return
        }
        if moviesCount == 0 {
            self.tableView.isHidden = true
            self.containerView.isHidden = true
            self.clickMovieLabel.isHidden = false
            self.addButton.isHidden = false
            self.setGradientView()
        }
    }
    
    func setGradientView() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        //7 54 67
        gradient.colors = [UIColor(red: 2, green: 43, blue: 54, alpha: 1),UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor]//
        //gradient.colors = [UIColor.black.cgColor,UIColor.black.cgColor,UIColor.darkGray.cgColor,UIColor.darkGray.cgColor, UIColor.gray.cgColor,UIColor.gray.cgColor, UIColor.lightGray.cgColor,UIColor.lightGray.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    func totalPages(totalPages : String) -> Int {
//        let totalResultsInt = Int(totalPages)
//
//            self.totalPages = Int(totalPages)!-Int(totalPages)!%10
//            self.totalPages = self.totalPages!/10
//            if totalResultsInt!%10 != 0{
//                self.totalPages? += 1
//            }
//            return self.totalPages!
        
        if let totalResultsInt = Int(totalPages) {
        
            self.totalPages = totalResultsInt-totalResultsInt%10
            
            self.totalPages = self.totalPages/10
            if totalResultsInt%10 != 0{
                self.totalPages += 1
            }
        }
        return self.totalPages

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.isHidden = false
        self.containerView.isHidden = true
        self.addButton.isHidden = true
        self.clickMovieLabel.isHidden = true
        let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "+")
        if let searchTxt = searchText {
            self.getMoviesList(movieName: searchTxt, pageNumber: "")
        }
        self.tableView.reloadData()
        self.setGradientView()
    }
    /*
 func getMoviesList(movieName : String, pageNumber: String) {
 ServiceHelper().getMovies(movieName: movieName, pageNumber: pageNumber, handler: {
 (moviesList) in
 if moviesList.value?.response != "False" {
 guard let totalResults = moviesList.value?.totalResults else {
 return
 }
 self.totalPages = self.totalPages(totalPages: totalResults)
 if pageNumber != "" {
 self.pageNumber += 1
 guard let search = moviesList.value?.search else {
 return
 }
 for item in search {
 self.moviesList?.search?.append(item)
 }
 } else {
 self.moviesList = moviesList.value
 }
 } else {
 self.moviesList = nil
 }
 self.tableView.reloadData()
 KRProgressHUD.dismiss()
 }, failure: (error) in
 print(error)
 )
 }
 */
    func getMoviesList(movieName : String, pageNumber: String) {
        ServiceHelper().getMovies(movieName: movieName, pageNumber: pageNumber, handler: {
            (moviesList) in
            if moviesList.value?.response != "False" {
                guard let totalResults = moviesList.value?.totalResults else {
                    return
                }
                self.totalPages = self.totalPages(totalPages: totalResults)
                if pageNumber != "" {
                    self.pageNumber += 1
                    guard let search = moviesList.value?.search else {
                        return
                    }
                    for item in search {
                        self.moviesList?.search?.append(item)
                    }
                } else {
                    self.moviesList = moviesList.value
                }
                KRProgressHUD.dismiss()
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
            if self.pageNumber <= self.totalPages {
                let searchText = self.searchBar?.text?.replacingOccurrences(of: " ", with: "+")
                if let searchTxt = searchText {
                    self.getMoviesList(movieName: searchTxt, pageNumber: self.pageNumber.description)
                }
            }
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
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
        self.rightButton = UIButton.init(type: .custom)
        self.rightButton?.titleLabel?.textAlignment = .right
        self.rightButton?.titleLabel?.font = UIFont(name: "Helvetica" , size: 12)
        self.rightButton?.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0)
        self.rightButton?.setImage(UIImage(named: "searchIcon"), for: UIControlState.normal)
        self.rightButton?.isUserInteractionEnabled = true
        self.rightButton?.addTarget(self, action:  #selector(addTapped(sender:)), for: .touchUpInside)
        self.rightButton?.frame = CGRect(x: 0, y: 0, width: 18, height: 20)
        guard let rightButton = self.rightButton else {
            return
        }
        let buttonBar = UIBarButtonItem.init(customView: rightButton)
        self.rightButton?.widthAnchor.constraint(equalToConstant: 18.0).isActive = true
        self.rightButton?.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.navigationItem.rightBarButtonItem = buttonBar
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar?.endEditing(true)
    }
    func createSearchBar() {
        self.navigationItem.rightBarButtonItem = nil
        self.searchBar = UISearchBar()
        guard let font = UIFont(name: "Helvetica", size: 12) else {
            return
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSFontAttributeName : font,NSForegroundColorAttributeName : UIColor.white], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.searchBar?.barStyle = UIBarStyle.blackOpaque
        

        self.searchBar?.placeholder = "Tap a movie name"
        
        

        self.searchBar?.delegate = self
        self.navigationItem.titleView = searchBar
        self.searchBar?.setShowsCancelButton(true, animated: true)
        self.searchBar?.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.setShowsCancelButton(false, animated: true)
        self.searchBar?.removeFromSuperview()
        self.navigationItem.titleView = nil
        self.setupNavigationBar()
        self.tableView.isHidden = true
        self.notFoundMovieView.isHidden = true
        self.containerView.isHidden = false
        if self.movieEntity?.count == 0 {
            self.addButton.isHidden = false
            self.clickMovieLabel.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar?.endEditing(true)
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
            if !(NetworkReachabilityManager()?.isReachable)! {
                self.tableView.isHidden = true
                self.notFoundMovieView.isHidden = false
                self.notFoundLabel.text = "No internet connection!"
            } else {
                self.notFoundLabel.text = "Movie not Found!"
            }
            if let count = self.moviesList?.search?.count {
                return count
            } else {
                return 0
            }
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
        if let title = item?.title, let year = item?.year, let image = item?.posterImage {
            titleLabel.text = title+" ("+year+")"
            if image == "N/A" {
                imageView.image = #imageLiteral(resourceName: "noImage")
            } else {
                if let downloadURL = NSURL(string: image) {
                    imageView.af_setImage(withURL: downloadURL as URL)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.moviesList?.search?[indexPath.row]
        self.movieSelectedId = movie?.imdbID
        performSegue(withIdentifier: "movieDetailSegue", sender: self)
    }
}

