//
//  ServiceHelper.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 02/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ServiceHelper: NSObject {

    var movieDetail : MovieDetail?
    let baseuUrl = "http://www.omdbapi.com/?apikey=dcdc9b0&"
    
    func getMovies(movieName: String, pageNumber: String, handler: @escaping (_ msg: DataResponse<Movies>) -> ()){
        var url = baseuUrl + "s="+movieName
        if pageNumber != "" {
            url = url+"&page="+pageNumber
        }
        Alamofire.request(url).responseObject { (response: DataResponse<Movies>) in
            switch response.result {
            case .success:
                handler(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMovieById(movieId: String, handler: @escaping (_ msg: DataResponse<MovieDetail>) -> ()){
        let url = baseuUrl + "i="+movieId
        Alamofire.request(url).responseObject { (response: DataResponse<MovieDetail>) in
            switch response.result {
            case .success:
                handler(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMoviesCoreData() -> [NSManagedObject]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetailEntity")
        request.returnsObjectsAsFaults = false
        var resultsContext : [NSManagedObject]? = nil
        let context = appDelegate.persistentContainer.viewContext
        do{
            resultsContext = try context.fetch(request) as? [NSManagedObject]
//            if (resultsContext?.count)! > 0{
//                for result in resultsContext!{
//                    //                    if let userName = result.value(forKey: "name") as? String{
//                    //                        print(userName)
//                    //
//                    //                    }
//                }
//            }
            return resultsContext!
        }
        catch{
            return resultsContext!
        }
    }
    
    func getMovieById(uid : String) -> [NSManagedObject]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetailEntity")
        //var movie: MovieDetail?
        request.predicate = NSPredicate(format: "imdbID = %@", uid)
        request.returnsObjectsAsFaults = false
        var resultsContext : [NSManagedObject]? = nil
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            resultsContext = try context.fetch(request) as? [NSManagedObject]
            //movie = resultsContext?.first as? MovieDetail
            return resultsContext!
        }
        catch{
            return resultsContext!
        }
    }

    func removeMovieCoreData(movieId : String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetailEntity")
        fetchRequest.predicate = NSPredicate(format: "imdbID = %@", movieId)
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        do{
            try context.execute(deleteRequest)
        }catch let error as NSError {
            print(error)
        }
    }
    
    func saveMovieCoredata(movie: MovieDetail){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let movieCoreData = NSEntityDescription.insertNewObject(forEntityName: "MovieDetailEntity", into: context)
        movieCoreData.setValue(movie.actors, forKey: "actors")
        movieCoreData.setValue(movie.imdbID, forKey: "imdbID")
        movieCoreData.setValue(movie.director, forKey: "director")
        movieCoreData.setValue(movie.posterImage, forKey: "posterImage")
        movieCoreData.setValue(movie.released, forKey: "released")
        movieCoreData.setValue(movie.runtime, forKey: "runtime")
        movieCoreData.setValue(movie.title, forKey: "title")
        movieCoreData.setValue(movie.year, forKey: "year")
        do{
            try context.save()
        }
        catch let error as NSError {
            print(error)
        }
    }
}
