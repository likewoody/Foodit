//
//  LatLng.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//

struct Python: Decodable{
    var lat: Double
    var lng: Double
    var address: String
    
    init(lat: Double, lng: Double, address: String) {
        self.lat = lat
        self.lng = lng
        self.address = address
    }
}
