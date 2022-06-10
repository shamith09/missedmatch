//
//  LocationManager.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/25/22.
//
import Foundation
import CoreLocation
import SwiftUI
import Alamofire

final class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    var id = ""
 
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        print(location)
        if !id.isEmpty {
            let _ = AF.request("Constants.USER_ROUTE\(id)", method: .put, parameters: LocationUpdate(latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude)))
        }
    }
}
