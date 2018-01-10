//
//  DoubleExtension.swift
//  Indicators
//
//  Created by Igor Nabokov on 10/01/2018.
//  Copyright © 2018 Igor Nabokov. All rights reserved.
//

import Foundation

extension Double {
    func format(using formatString: String) -> String {
        return String(format: "%\(formatString)f", self)
    }
}
