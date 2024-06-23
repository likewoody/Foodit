//
//  Post.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

import UIKit

struct Post{
    var id: Int
//    newAddress, oldAddress, phone, operationTime,
    var name,  date, review, category: String
//    var lat, lng: Double
    var image: UIImage
    
    
    init(id: Int, name: String, date: String, review: String, category: String, image: UIImage) {
        self.id = id
        self.name = name
        self.date = date
        self.review = review
        self.category = category
        self.image = image
    }
//    init(id: Int, name: String, newAddress: String, oldAddress: String, phone: String, operationTime: String, date: String, review: String, category: String, lat: Double, lng: Double, image: UIImage) {
//        self.id = id
//        self.name = name
//        self.newAddress = newAddress
//        self.oldAddress = oldAddress
//        self.phone = phone
//        self.operationTime = operationTime
//        self.date = date
//        self.review = review
//        self.category = category
//        self.lat = lat
//        self.lng = lng
//        self.image = image
//    }
    
}

