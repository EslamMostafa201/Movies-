//
//  MovieModel.swift
//  Movies
//
//  Created by Admin on 1/3/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import Foundation
import RealmSwift

class MovieModel: Object{
    @objc dynamic var id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var overView : String = ""
    @objc dynamic var geners : String = ""
//    @objc dynamic var cast = Array<String>()

    @objc dynamic var picture = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
