//
//  LocationUpdate.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 6/7/22.
//

import Foundation

struct LocationUpdate: Codable {
    var location_update = true
    var latitude: Double
    var longitude: Double
}
