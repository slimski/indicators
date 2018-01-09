//
//  PressureModel.swift
//  Indicators
//
//  Created by Igor Nabokov on 05/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import Foundation
import CoreMotion
import RxSwift

class PressureModel: SensorProtocol {
    let title = "Pressure"
    let units = "hPa"
    var completion: (() -> ())?
    var values = Variable<[Double: Double]>([Double: Double]())
    var value: Variable<Double> = Variable(0)
    
    init() {
        setupHandler()
    }
    
    func isAvailable() -> Bool {
        return CMAltimeter.isRelativeAltitudeAvailable()
    }
    
    private func setupHandler() {
        if isAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: .main, withHandler: { [weak self] (altitudeData, error) in
                guard let `self` = self,let pressure = altitudeData?.pressure else { return }
                
                let date = Date()
                let time = date.timeIntervalSince(self.startTime)
                self.values.value[time] = round(pressure.doubleValue )
                self.completion?()
            })
        }
    }
    
    private let startTime = Date()
    
    private let altimeter = CMAltimeter()
}
