//
//  DoubleExtension.swift
//  weply
//
//  Created by Den Jo on 21/02/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import Foundation

extension Double {
    
    func rounded(digits: UInt) -> Double {
        let divisor = pow(10.0, Double(digits))
        return (self * divisor).rounded() / divisor
    }
}
