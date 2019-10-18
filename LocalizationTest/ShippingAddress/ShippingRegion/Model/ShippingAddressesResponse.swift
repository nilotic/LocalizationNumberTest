//
//  ShippingAddressesResponse.swift
//  weply
//
//  Created by Den Jo on 21/12/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

struct ShippingAddressesResponse {
    let shipppingAddresses: [ShippingAddress]
}

extension ShippingAddressesResponse: Decodable {
    
    private enum Key: String, CodingKey {
        case shippingAddresses
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { shipppingAddresses = try container.decode([ShippingAddress].self, forKey: .shippingAddresses) } catch { throw DecodingError.keyNotFound(Key.shippingAddresses, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get shipppingAddresses.")) }
    }
}
