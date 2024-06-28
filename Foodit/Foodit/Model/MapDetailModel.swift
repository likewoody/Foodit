//
//  MapQueryy.swift
//  Foodit
//
//  Created by Woody on 6/24/24.
//

import UIKit

struct MapDetailModel{
    var name, address, category, review, date: String
    var image: UIImage
    
    init(name: String, address: String, category: String, review: String, date: String, image: UIImage) {
        self.name = name
        self.address = address
        self.category = category
        self.review = review
        self.date = date
        self.image = image
    }
}
