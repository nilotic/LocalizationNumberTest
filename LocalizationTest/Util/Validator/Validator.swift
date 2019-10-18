//
//  Validator.swift
//  weply
//
//  Created by Den Jo on 04/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation
import UIKit


struct Validator {
    
    /*
     ^                                                  Start anchor
     (?=.*[A-Za-z])                                     Ensure string has one alphabet.
     (?=.*[A-Z].*[A-Z])                                 Ensure string has two uppercase letters.
     (?=.*[-/:;()₩&@“.,?!{}#%^*+=_\\|~<>$£¥•.,?!’])     Ensure string has one special case letter.
     (?=.*[0-9])                                        Ensure string has one digit.
     (?=.*[0-9].*[0-9])                                 Ensure string has two digits.
     (?=.*[a-z].*[a-z].*[a-z])                          Ensure string has three lowercase letters.
     .{6,15}                                            Ensure string is of length 6 ~ 15.
     (\\d*)                                             Ensure string contains only numbers
     $                                                  End anchor.
     */
    
    static func validate(email: String?) -> Bool {
        guard let email = email else { return false }
        // return NSPredicate(format:"SELF MATCHES %@", "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$").evaluate(with: email)
        
        let components = email.components(separatedBy: "@")
        guard 2 == components.count, let first = components.first, let last = components.last, first != "" else { return false }
        
        let lastComponents = last.components(separatedBy: ".")
        return 1 < lastComponents.count && lastComponents.last != nil && lastComponents.last != ""
    }
    
    static func validate(firstName: String?, lastName: String?) -> Bool {
        guard let firstName = firstName, let lastName = lastName, firstName != " ", lastName != " " else { return false }
        return 0 < firstName.count && 0 < lastName.count
    }
    
    static func validateMembership(firstName: String?, lastName: String?) throws {
        guard firstName != nil || lastName != nil else { throw MembershipNameError.empty }
        
        let firstName = firstName?.trimmingCharacters(in: .whitespaces)
        let lastName  = lastName?.trimmingCharacters(in: .whitespaces)
        
        if let name = firstName {
            guard name != "" else { throw MembershipNameError.emptyFirstName }
            
            switch name.isEnglish {
            case true:
                guard name.range(of: "^[a-zA-Z ]+$", options: .regularExpression) != nil else { throw MembershipNameError.invalidEnglishFirstName }
                guard let lastName = lastName, lastName.isEmpty == false else { throw MembershipNameError.emptyLastName }
                guard lastName.range(of: "^[a-zA-Z ]+$", options: .regularExpression) != nil else { throw MembershipNameError.differentLanguage }
                return
                
            case false:
                guard name.range(of: "^[ㄱ-ㅎㅏ-ㅣ가-힣 ]+$", options: .regularExpression) != nil else { throw MembershipNameError.invalidKoreanFirstName }
                guard let lastName = lastName, lastName.isEmpty == false else { throw MembershipNameError.emptyLastName }
                guard lastName.range(of: "^[ㄱ-ㅎㅏ-ㅣ가-힣 ]+$", options: .regularExpression) != nil else { throw MembershipNameError.differentLanguage }
                return
            }
        }
        
        if let name = lastName {
            guard name != "" else { throw MembershipNameError.emptyLastName }
            
            switch name.isEnglish {
            case true:
                guard name.range(of: "^[a-zA-Z ]+$", options: .regularExpression) != nil else { throw MembershipNameError.invalidEnglishLastName }
                guard let firstName = firstName, firstName.isEmpty == false, firstName != " " else { throw MembershipNameError.emptyFirstName }
                guard firstName.range(of: "^[a-zA-Z ]+$", options: .regularExpression) != nil else { throw MembershipNameError.differentLanguage }
                return
                
            case false:
                guard name.range(of: "^[ㄱ-ㅎㅏ-ㅣ가-힣 ]+$", options: .regularExpression) != nil else { throw MembershipNameError.invalidKoreanLastName }
                guard let firstName = firstName, firstName.isEmpty == false, firstName != " " else { throw MembershipNameError.emptyFirstName }
                guard firstName.range(of: "^[ㄱ-ㅎㅏ-ㅣ가-힣 ]+$", options: .regularExpression) != nil else { throw MembershipNameError.differentLanguage }
                return
            }
        }
    }
    
    static func validate(password: String?) throws {
        guard let password = password, password != "" else { throw PasswordError.empty }
        let specialCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted
        
        var error: PasswordError = .none
        if password.rangeOfCharacter(from: .uppercaseLetters) == nil && password.rangeOfCharacter(from: .lowercaseLetters) == nil {
            if password.rangeOfCharacter(from: .uppercaseLetters) == nil { error.insert(.invalidUppserCase) }
            if password.rangeOfCharacter(from: .lowercaseLetters) == nil { error.insert(.invalidLowerCase) }
        }
        
        if password.rangeOfCharacter(from: .decimalDigits) == nil                               { error.insert(.invalidNumber) }
        if password.rangeOfCharacter(from: specialCharacterSet) == nil                          { error.insert(.invalidSpecialCharacter) }
        if (Password.range.lowerBound...Password.range.upperBound ~= password.count) == false   { error.insert(.invalidLength) }
        
        guard error != .none else { return }
        throw error
    }
    
    static func validate(authenticationCode: String?) -> Bool {
        guard let authenticationCode = authenticationCode else { return false }
        return NSPredicate(format:"SELF MATCHES %@", "^(\\d*).{6}$").evaluate(with: authenticationCode)
    }
    
    static func validate(address: Address?) -> Bool {
        guard let address = address, let countryCode = address.countryCode, address.country != nil, address.country != "", address.postalCode != nil, address.postalCode != "" else { return false }
        
        switch countryCode {
        case "KR":
            guard let thoroughfare = address.thoroughfare, thoroughfare != "", thoroughfare != " " else { return false }
            guard let subThoroughfare = address.subThoroughfare, subThoroughfare != "", subThoroughfare != " " else { return false }
            return true
            
        default:
            guard let thoroughfare = address.thoroughfare, thoroughfare != "", thoroughfare != " " else { return false }
            guard let locality = address.locality, locality != "", locality != " " else { return false }
            guard let administrativeArea = address.administrativeArea, administrativeArea != "", administrativeArea != " " else { return false }
            return true
        }
    }
    
    static func validate(phoneNumber: PhoneNumber?) -> Bool {
        guard let countryCallingCode = phoneNumber?.countryCallingCode, let number = phoneNumber?.number else { return false }
        return 0 < countryCallingCode.count &&  5 < number.count
    }
}
