//
//  Post.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

import UIKit

struct Post{
    var id: Int
    var name, address, date, review, category: String
    var lat, lng: Double
    var image: UIImage
    
    init(id: Int, name: String, address: String, date: String, review: String, category: String, lat: Double, lng: Double, image: UIImage) {
        self.id = id
        self.name = name
        self.address = address
        self.date = date
        self.review = review
        self.category = category
        self.lat = lat
        self.lng = lng
        self.image = image
    }
}
