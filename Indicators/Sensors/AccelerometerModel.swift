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
    
    var completion: (() -> ())?
    
//    var values =  Variable<[Double : Double]>([Double : Double]())
//    var observableValues: Observable<[Double: Double]>
    var value: Variable<Double> = Variable(0)
    
    private let motionManager = CMMotionManager()
    
    func isAvailable() -> Bool {
        return motionManager.isAccelerometerAvailable
    }
    
    init() {
        setupHandler()
//        observableValues = values.asObservable()
    }
    private let startTime = Date()
    private func setupHandler() {
        if isAvailable() {
            motionManager.accelerometerUpdateInterval = 1
            motionManager.startAccelerometerUpdates(to: .main, withHandler: { [weak self] (accelerometerData, error) in
                guard let `self` = self,let acceleration = accelerometerData?.acceleration else { return }
                
                let date = Date()
                let time = date.timeIntervalSince(self.startTime)
//                var values = self.values
//                self.values.value[time] = acceleration.x
//                self.values = values
                self.value.value = acceleration.x
//                self.completion?()
            })
        }
    }
}
