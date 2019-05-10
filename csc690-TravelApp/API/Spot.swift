//
//  Spot.swift
//  BestTravel
//
//  Created by Jangey Lu on 12/3/18.
//  Copyright © 2018 Jangey Lu. All rights reserved.
//

import Foundation

class Spot {
    var spotName: String
    var id: String
    var description: String
    
    // for icon
    var IconURLprefix: String
    var IconURLsuffix: String = "bg_64.png"
    var IconURL: String
    
    var spotAddress: String
    var spotLat: Double
    var spotLng: Double
    
    init(dictionary: [String: Any]) {
        let venue = dictionary["venue"] as? [String: Any]
        let categories = venue!["categories"] as? [[String: Any]]
        let icon = categories![0]["icon"] as? [String: Any]
        
        spotName = venue!["name"] as? String ?? "No title"
        id = venue!["id"] as? String ?? "No Id"
        description = categories![0]["name"] as? String ?? "No description"
        IconURLprefix = icon!["prefix"] as? String ?? "No IconURLprefix"
        IconURL = IconURLprefix + IconURLsuffix
        
        // for address
        let location = venue!["location"] as? [String: Any]
        let address = location!["address"] as? String ?? "No address"
        let city = location!["city"] as? String ?? "No city"
        let state = location!["state"] as? String ?? "No state"
        let country = location!["country"] as? String ?? "No country"
        let postalCode = location!["postalCode"] as? String ?? "No postalCode"
        let lat = location!["lat"] as? Double ?? 0
        let lng = location!["lng"] as? Double ?? 0
        let addressFormatted = "\(address), \(city), \(state) \(postalCode), \(country)"
        spotAddress = addressFormatted
        spotLat = lat
        spotLng = lng
    }
    
    class func spots(dictionaries: [[String: Any]]) -> [Spot] {
        var spots: [Spot] = []
        for dictionary in dictionaries {
            let spot = Spot(dictionary: dictionary)
            spots.append(spot)
        }
        
        return spots
    }
    
}
