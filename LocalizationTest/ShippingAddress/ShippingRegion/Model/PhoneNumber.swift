//
//  PhoneNumber.swift
//  weply
//
//  Created by Den Jo on 11/12/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

struct PhoneNumber: Codable, Equatable {
    var countryCallingCode: String?
    var number: String?
}

extension PhoneNumber {
    
    var nationalConvetionPhoneNumber: String? {
        guard let countryCallingCode = countryCallingCode, let number = number, countryCallingCode != "" else { return nil }
        return "+\(countryCallingCode) \(number)"
    }
}
