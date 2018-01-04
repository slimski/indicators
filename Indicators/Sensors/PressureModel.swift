//
//  PressureModel.swift
//  Indicators
//
//  Created by Igor Nabokov on 05/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import Foundation
import CoreMotion

class PressureModel {
    static let instance = PressureModel()
    let title = "Pressure"
    let units = "hPa"
    var completion: (() -> ())?
    var values = [Double: Double]()
    
    private let startTime = Date()
    private let altitudeHandler: CMAltitudeHandler =  { (altitudeData, error) in
        guard let pressure = altitudeData?.pressure else { return }
        
        let date = Date()
        let time = date.timeIntervalSince(instance.startTime)
        instance.values[time] = round(pressure.doubleValue * 10)
        instance.completion?()
    }
    
    private let altimeter = CMAltimeter()
    
    init() {
        if isAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: .main, withHandler: altitudeHandler)
        }
    }
    
    func isAvailable() -> Bool {
        return CMAltimeter.isRelativeAltitudeAvailable()
    }
}
