//
//  SensorViewModel.swift
//  Indicators
//
//  Created by Igor Nabokov on 06/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SensorViewModel {
    
    var values: Observable<(Double, Double)>
    
    var title: BehaviorSubject<String>
    
    var units: BehaviorSubject<String>
    
    private let sensor: SensorProtocol
    private let startTime: Date
    private let disposeBag = DisposeBag()
    
    init(sensor: SensorProtocol) {
        self.sensor = sensor
        self.title = BehaviorSubject(value: self.sensor.title)
        self.units = BehaviorSubject(value: self.sensor.units)
        self.startTime = Date()
        let startTime = self.startTime
        values = self.sensor.value.asObservable().map { (value) -> (Double, Double) in
            let date = Date()
            let time = date.timeIntervalSince(startTime)
            return (time, value)
        }
    }
}
