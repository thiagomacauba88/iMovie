//
//  ServiceHelper.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 02/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//

import UIKit
import Alamofire

class ServiceHelper: NSObject {

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
        
        var url = baseuUrl + "i="+movieId
        
        Alamofire.request(url).responseObject { (response: DataResponse<MovieDetail>) in
            
            switch response.result {
                
            case .success:
                
                handler(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func getCountriesCoreData() -> [NSManagedObject]{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountriesEntity")
        
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
    
    func getCountryById(uid : Int64) -> [NSManagedObject]{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountriesEntity")
        request.predicate = NSPredicate(format: "id == %d", uid)
        request.returnsObjectsAsFaults = false
        var resultsContext : [NSManagedObject]? = nil
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            resultsContext = try context.fetch(request) as? [NSManagedObject]
            return resultsContext!
        }
            
        catch{
            return resultsContext!
        }
    }
    

    func removeVisitedCountry(id: Array<Int64>){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountriesEntity")
        
        request.predicate = NSPredicate(format: "id IN %@", id)
        request.returnsObjectsAsFaults = false
        var resultsContext : [NSManagedObject]? = nil
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            resultsContext = try context.fetch(request) as? [NSManagedObject]
            
            if (resultsContext?.count)! > 0{
                for result in resultsContext!{
                    result.setValue(0, forKey: "isVisited")
                    do{
                        try context.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch{}
    }
    
    func updateVisitDate(index: Int64, visitDate: Date, isVisited: Bool){
        
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
