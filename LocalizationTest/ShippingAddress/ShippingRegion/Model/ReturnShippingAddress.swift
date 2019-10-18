//
//  ReturnShippingAddress.swift
//  weply
//
//  Created by Den Jo on 09/04/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import Foundation

struct ReturnShippingAddress: ShippingAddresses {
    let id: Int
    let firstName: String
    let lastName: String
    let address: Address
    let phoneNumber: PhoneNumber
    var isValid: Bool
    var isDefault: Bool
}

extension ReturnShippingAddress {
    
    var shippingAddress: ShippingAddress {
        return ShippingAddress(id: id, firstName: firstName, lastName: lastName, address: address, phoneNumber: phoneNumber, isValid: isValid, isDefault: isDefault)
    }
    
    init(data: ShippingAddress) {
        id          = data.id
        firstName   = data.firstName
        lastName    = data.lastName
        address     = data.address
        phoneNumber = data.phoneNumber
        isValid     = data.isValid
        isDefault   = data.isDefault
    }
}

extension ReturnShippingAddress: Codable {
    
    private enum Key: String, CodingKey {
        case userShippingAddressId
        case firstName
        case lastName
        case countryCallingCode
        case phoneNumber
        case address
        case isValidShippingCountry
        case isDefaultAddress
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do {
            try container.encode(id,          forKey: .userShippingAddressId)
            try container.encode(firstName,   forKey: .firstName)
            try container.encode(lastName,    forKey: .lastName)
            try container.encode(phoneNumber, forKey: .phoneNumber)
            try container.encode(address,     forKey: .address)
            try container.encode(isValid,     forKey: .isValidShippingCountry)
            try container.encode(isDefault,   forKey: .isDefaultAddress)
        } catch { throw error }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { id          = try container.decode(Int.self,         forKey: .userShippingAddressId) }  catch { throw DecodingError.keyNotFound(Key.userShippingAddressId, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get an userShippingAddressId.")) }
        do { firstName   = try container.decode(String.self,      forKey: .firstName) }              catch { throw DecodingError.keyNotFound(Key.firstName, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a firstName.")) }
        do { lastName    = try container.decode(String.self,      forKey: .lastName) }               catch { throw DecodingError.keyNotFound(Key.lastName, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a lastName.")) }
        do { address     = try container.decode(Address.self,     forKey: .address) }                catch { throw DecodingError.keyNotFound(Key.address, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get an address.")) }
        do { phoneNumber = try container.decode(PhoneNumber.self, forKey: .phoneNumber) }            catch { throw DecodingError.keyNotFound(Key.phoneNumber, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a phoneNumber.")) }
        do { isValid     = try container.decode(Bool.self,        forKey: .isValidShippingCountry) } catch { isValid = false }
        do { isDefault   = try container.decode(Bool.self,        forKey: .isDefaultAddress) }       catch { isDefault = false }
    }
}

extension ReturnShippingAddress: Equatable {
    
    static func ==(lhs: ReturnShippingAddress, rhs: ReturnShippingAddress) -> Bool {
        return lhs.id == rhs.id
    }
}
