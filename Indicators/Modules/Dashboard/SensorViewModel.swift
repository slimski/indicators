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
    let sensor: SensorProtocol
    var values: Observable<(Double, Double)>!
    
    var title: BehaviorSubject<String>
    
    var units: BehaviorSubject<String>
    
    let startTime = Date()
    let disposeBag = DisposeBag()
    
    init(sensor: SensorProtocol) {
        self.sensor = sensor
        self.title = BehaviorSubject(value: self.sensor.title)
        self.units = BehaviorSubject(value: self.sensor.units)
        self.setup()
    }
    
    func setup() {
        values = self.sensor.value.asObservable().map { [weak self] (value) -> (Double, Double) in
            guard let `self` = self else { return (0,0)}
            let date = Date()
            let time = date.timeIntervalSince(self.startTime)
            return (time, value)
        }
    }
}
