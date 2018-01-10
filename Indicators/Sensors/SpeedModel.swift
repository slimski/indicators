//
//  SpeedModel.swift
//  Indicators
//
//  Created by Igor Nabokov on 10/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import Foundation
import RxSwift

class SpeedModel: SensorProtocol {
    let title = "Speed"

    let units = "km/h"

    let shortUnits = "km/h"

    var value = Variable<Double>(0)

    func isAvailable() -> Bool {
        return true
    }

    let valueFormat = ".0"

    let mainColorHex = "#4864F0"

    init() {
        setup()
    }

    private let disposeBag = DisposeBag()

    private func setup() {
        GeolocationService.instance.authorized.drive().disposed(by: disposeBag)
        GeolocationService.instance.speed.drive(value).disposed(by: disposeBag)
    }
}
