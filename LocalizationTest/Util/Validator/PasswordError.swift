//
//  PasswordError.swift
//  weply
//
//  Created by Den Jo on 28/06/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import Foundation

struct Password {
    static let range = 8...32
}

struct PasswordError: OptionSet, Error {
    let rawValue: Int
    
    static let none                     = PasswordError(rawValue: 0)
    static let empty                    = PasswordError(rawValue: 1 << 0)
    static let invalidUppserCase        = PasswordError(rawValue: 1 << 1)
    static let invalidLowerCase         = PasswordError(rawValue: 1 << 2)
    static let invalidNumber            = PasswordError(rawValue: 1 << 3)
    static let invalidSpecialCharacter  = PasswordError(rawValue: 1 << 4)
    static let invalidLength            = PasswordError(rawValue: 1 << 5)
}
