//
//  MembershipNameError.swift
//  weply
//
//  Created by Den Jo on 28/06/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import Foundation

struct MembershipNameError: OptionSet, Error {
    let rawValue: Int
    
    static let none                    = MembershipNameError(rawValue: 0)
    static let empty                   = MembershipNameError(rawValue: 1 << 0)
    static let emptyFirstName          = MembershipNameError(rawValue: 1 << 1)
    static let emptyLastName           = MembershipNameError(rawValue: 1 << 2)
    static let invalidKoreanFirstName  = MembershipNameError(rawValue: 1 << 3)
    static let invalidKoreanLastName   = MembershipNameError(rawValue: 1 << 4)
    static let invalidEnglishFirstName = MembershipNameError(rawValue: 1 << 5)
    static let invalidEnglishLastName  = MembershipNameError(rawValue: 1 << 6)
    static let differentLanguage       = MembershipNameError(rawValue: 1 << 7)
}
