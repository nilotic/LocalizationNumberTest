//
//  LocationManager.swift
//  weply
//
//  Created by Den Jo on 21/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import CoreLocation
import LocalAuthentication

// MARK: - Define
struct LocationNotificationName {
    static let disabled = NSNotification.Name("LocationDisabledNotification")
    static let denied   = NSNotification.Name("LocationDeniedNotification")
}

final class LocationManager: NSObject {
    
    // MARK: - Singleton
    static let shared = LocationManager()
    private override init() {       // This prevents others from using the default initializer for this calls
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter  = kCLDistanceFilterNone
        locationManager.delegate        = self
    }
    
    
    
    // MARK: - Value
    // MARK: Private
    private let locationManager = CLLocationManager()
    
    // Cache
    private var timer: Timer? = nil
    private var completion: ((_ location: CLLocation?) -> Void)? = nil
    private var locationCache: CLLocation? = nil
    
    
    
    // MARK: - Public
    // MARK: Public
    func requestLocation(completion: ((_ location: CLLocation?) -> Void)? = nil) {
        guard CLLocationManager.locationServicesEnabled() == true else {
            completion?(nil)
            NotificationCenter.default.post(name: LocationNotificationName.disabled, object: nil)
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.completion = completion
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            completion?(nil)
            NotificationCenter.default.post(name: LocationNotificationName.denied, object: nil)
            
        case .restricted:
            completion?(nil)
            
        case .authorizedAlways, .authorizedWhenInUse:
            // Use the cache if the cache isn't expired
            guard let locationCache = locationCache else {
                self.completion = completion
                  
                locationManager.requestLocation()
                timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { timer in
                    self.completion?(nil)
                }
                return
            }
            
            completion?(locationCache)
            
        default:
            completion?(nil)
        }
    }
}



// MARK: - CLLocationManager Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:   locationManager.requestLocation()
        case .restricted, .denied:                      completion?(nil)
        default:                                        break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        timer?.invalidate()
        completion?(locations.last)
        
        
        // Cache
        locationCache = locations.last
        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {    // Expire the cache after 30 seconds
            self.locationCache = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
    }
}
