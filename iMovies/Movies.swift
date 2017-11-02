//
//  Movies.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 02/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class Movies: Mappable {
    
    var search : [Search]?
    var totalResults : String?
    var error: String?
    var response: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        search <- map["Search"]
        totalResults <- map["totalResults"]
        error <- map["Error"]
        response <- map["Response"]
    }

}

class Search: Mappable {
    
    var title : String?
    var year : String?
    var imdbID : String?
    var posterImage : String?
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        title <- map["Title"]
        year <- map["Year"]
        imdbID <- map["imdbID"]
        posterImage <- map["Poster"]
    }
}
