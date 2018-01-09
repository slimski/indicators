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
    let valueFormat = ".0"
    let mainColorHex = "#F04848"
    
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
                self.value.value = round(pressure.doubleValue * 10)
            })
        }
    }
    
    private let startTime = Date()
    
    private let altimeter = CMAltimeter()
}
