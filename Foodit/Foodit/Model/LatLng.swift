//
//  LatLng.swift
//  Foodit
//
//  Created by Woody on 6/21/24.
//

struct LatLng: Decodable{
    var lat: Double
    var lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}
