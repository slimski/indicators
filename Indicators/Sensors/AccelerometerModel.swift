//
//  AccelerometerModel.swift
//  Indicators
//
//  Created by Igor Nabokov on 06/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import Foundation
import CoreMotion
import RxSwift

class AccelerometerModel: SensorProtocol {
    let title = "Accelerometer"
    let units = "g"
    let valueFormat = ".2"
    let mainColorHex = "#F04848"

    var completion: (() -> Void)?

    var value: Variable<Double> = Variable(0)

    private let motionManager = CMMotionManager()

    func isAvailable() -> Bool {
        return motionManager.isAccelerometerAvailable
    }

    init() {
        setupHandler()
    }

    private func setupHandler() {
        if isAvailable() {
            motionManager.accelerometerUpdateInterval = 1
            motionManager.startAccelerometerUpdates(to: .main, withHandler: { [weak self] (accelerometerData, error) in
                guard let `self` = self,let acceleration = accelerometerData?.acceleration else { return }

                self.value.value = acceleration.x
            })
        }
    }
}
