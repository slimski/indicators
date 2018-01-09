//
//  SensorProtocol.swift
//  Indicators
//
//  Created by Igor Nabokov on 06/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import Foundation
import RxSwift

protocol SensorProtocol {
    var title: String { get }
    var units: String { get }
    var completion: (() -> ())? { get set }
//    var values: Variable<[Double: Double]> { get }
    var value: Variable<Double> { get }
    func isAvailable() -> Bool
    
}
