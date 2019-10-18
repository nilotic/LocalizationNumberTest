//
//  Currency.swift
//  weply
//
//  Created by Den Jo on 04/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation


// MARK: - Int
extension Int {
    
    func currency(from currencyCode: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = currencyCode
        numberFormatter.numberStyle  = .currency
        
        if currencyCode == "USD"    { numberFormatter.locale = Locale(identifier: "en_US") }
        if currencyCode == "KRW"    { numberFormatter.locale = Locale(identifier: "ko") }
        if currencyCode == "JPY"    { numberFormatter.locale = Locale(identifier: "ja") }
        
        return numberFormatter.string(for: self)
    }
}



// MARK: - UInt
extension UInt {
    
    func currency(from currencyCode: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = currencyCode
        numberFormatter.numberStyle  = .currency
        
        if currencyCode == "USD"    { numberFormatter.locale = Locale(identifier: "en_US") }
        if currencyCode == "KRW"    { numberFormatter.locale = Locale(identifier: "ko") }
        if currencyCode == "JPY"    { numberFormatter.locale = Locale(identifier: "ja") }
        
        return numberFormatter.string(for: self)
    }
}



// MARK: - Float
extension Float {
    
    func currency(from currencyCode: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = currencyCode
        numberFormatter.numberStyle  = .currency
        
        if currencyCode == "USD"    { numberFormatter.locale = Locale(identifier: "en_US") }
        if currencyCode == "KRW"    { numberFormatter.locale = Locale(identifier: "ko") }
        if currencyCode == "JPY"    { numberFormatter.locale = Locale(identifier: "ja") }
        
        return numberFormatter.string(for: self)
    }
}



// MARK: - Double
extension Double {
    
    func currency(from currencyCode: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = currencyCode
        numberFormatter.numberStyle  = .currency
        
        if currencyCode == "USD"    { numberFormatter.locale = Locale(identifier: "en_US") }
        if currencyCode == "KRW"    { numberFormatter.locale = Locale(identifier: "ko") }
        if currencyCode == "JPY"    { numberFormatter.locale = Locale(identifier: "ja") }
        
        return numberFormatter.string(for: self)
    }
}

