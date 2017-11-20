//
//  MovieDetail.swift
//  
//
//  Created by Thiago Henrique Pereira Freitas on 02/11/17.
//
//

import UIKit
import AlamofireObjectMapper
import ObjectMapper

class MovieDetail: Mappable {
    
    var title : String?
    var year : String?
    var released : String?
    var genre : String?
    var director : String?
    var actors : String?
    var plot : String?
    var runtime : String?
    var posterImage : String?
    var imdbID : String?
    var imdbRating : String?
    var type : String?
    var writer : String?
    var awards: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        title <- map["Title"]
        year <- map["Year"]
        released <- map["Released"]
        genre <- map["Genre"]
        director <- map["Director"]
        actors <- map["Actors"]
        plot <- map["Plot"]
        runtime <- map["Runtime"]
        posterImage <- map["Poster"]
        imdbID <- map["imdbID"]
        imdbRating <- map["imdbRating"]
        type <- map["Type"]
        writer <- map["Writer"]
        awards <- map["Awards"]
    }
}
