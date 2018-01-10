//
//  GeolocationService.swift
//  RxExample
//
//  Created by Carlos García on 19/01/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

class GeolocationService {

    static let instance = GeolocationService()
    private (set) var authorized: Driver<Bool>
    private (set) var location: Driver<CLLocationCoordinate2D>
    private (set) var altitude: Driver<CLLocationDistance>
    private (set) var speed: Driver<CLLocationSpeed>

    private let locationManager = CLLocationManager()

    private init() {

        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        authorized = Observable.deferred { [weak locationManager] in
                let status = CLLocationManager.authorizationStatus()
                guard let locationManager = locationManager else {
                    return Observable.just(status)
                }
                return locationManager
                    .rx.didChangeAuthorizationStatus
                    .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map {
                switch $0 {
                case .authorizedAlways:
                    return true
                default:
                    return false
                }
            }

        let managerData = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }

        location = managerData.map { $0.coordinate }

        altitude = managerData.map { $0.altitude }

        speed = managerData.map { $0.speed }

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
