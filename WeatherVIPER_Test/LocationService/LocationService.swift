//
//  LocationService.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 10.01.2023.
//

import CoreLocation
import UIKit

final class LocationService {
    private let locationManager = CLLocationManager()
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            guard let coordinate = placemarks, error == nil else { return }
            DispatchQueue.main.async {
                completion(coordinate.first?.location?.coordinate)
            }
        }
    }
    
    func locationAuthorization(view: UIViewController) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Authorized")
            startLocationManager(view: view)
        case .denied:
            break
        case .authorizedAlways:
            startLocationManager(view: view)
        case.notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            sleep(2)
            startLocationManager(view: view)
        default:
            break
        }
    }
    
    private func startLocationManager(view: UIViewController) {
        DispatchQueue.main.async {
            self.locationManager.delegate = view as? any CLLocationManagerDelegate
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.pausesLocationUpdatesAutomatically = false
            self.locationManager.startUpdatingLocation()
        }
    }
}

