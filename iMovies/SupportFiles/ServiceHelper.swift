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
            
            if (resultsContext?.count)! > 0{
                for result in resultsContext!{
                    //                    if let userName = result.value(forKey: "name") as? String{
                    //                        print(userName)
                    //
                    //                    }
                }
            }
            return resultsContext!
        }
        catch{
            return resultsContext!
        }
    }
    
    func getMovieById(uid : String) -> [NSManagedObject]{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetailEntity")
        var movie: MovieDetail?
        
        request.predicate = NSPredicate(format: "imdbID = %@", uid)
        request.returnsObjectsAsFaults = false
        var resultsContext : [NSManagedObject]? = nil
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            resultsContext = try context.fetch(request) as? [NSManagedObject]
            movie = resultsContext?.first as? MovieDetail
            /*let result = resultsContext?.first
            self.movieDetail?.actors = result?.value(forKey: "actors") as? String
            self.movieDetail?.director = result?.value(forKey: "director") as? String
            self.movieDetail?.genre = result?.value(forKey: "genre") as? String
            self.movieDetail?.imdbID = result?.value(forKey: "imdID") as? String
            self.movieDetail?.plot = result?.value(forKey: "plot") as? String
            self.movieDetail?.posterImage = result?.value(forKey: "posterImage") as? String
            self.movieDetail?.released = result?.value(forKey: "released") as? String
            self.movieDetail?.runtime = result?.value(forKey: "runtime") as? String
            self.movieDetail?.title = result?.value(forKey: "title") as? String
            self.movieDetail?.year = result?.value(forKey: "year") as? String
            return self.movieDetail!*/
            
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
        
//        request.predicate = NSPredicate(format: "imdbID = %@", id)
//        request.returnsObjectsAsFaults = false
//        var resultsContext : [NSManagedObject]? = nil
//        let context = appDelegate.persistentContainer.viewContext
        
        
        
                do{
                    try context.execute(deleteRequest)
                }catch let error as NSError {
                    print(error)
                }

        
        do{
//            resultsContext = try context.fetch(request) as? [NSManagedObject]
            
//            if (resultsContext?.count)! > 0{
//                for result in resultsContext!{
//                    result.setValue(0, forKey: "isVisited")
//                    do{
//                        try context.save()
//                    }
//                    catch{
//                    }
//                }
//            }
        }
        catch{}
    }
    
    func saveMovieCoredata(movie: MovieDetail){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetailEntity")
        //let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        
//        do{
//            try context.execute(deleteRequest)
//        }catch let error as NSError {
//            print(error)
//        }
        
        
            
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
                print("saved")
            }
            catch{
            }
        
    }
    
    /*func updateVisitDate(index: Int64, visitDate: Date, isVisited: Bool){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountriesEntity")
        request.predicate = NSPredicate(format: "id == %d", index)
        request.returnsObjectsAsFaults = false
        var resultsContext : [NSManagedObject]? = nil
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            resultsContext = try context.fetch(request) as? [NSManagedObject]
            if (resultsContext?.count)! > 0{
                for result in resultsContext!{
                    result.setValue(visitDate, forKey: "visitDate")
                    result.setValue(isVisited, forKey: "isVisited")
                    do{
                        try context.save()
                        print("saved")
                    }
                    catch{}
                }
            }
        }
        catch{}
    }*/

}
