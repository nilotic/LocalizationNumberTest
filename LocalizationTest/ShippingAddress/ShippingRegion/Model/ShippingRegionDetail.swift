//
//  ShippingRegionDetail.swift
//  weply
//
//  Created by Den Jo on 27/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

struct ShippingRegionDetail: ShippingRegion, Equatable {
    let countryCode: String
    let countryCallingCode: String
    let country: String
    let localizedString: String
}

extension ShippingRegionDetail: Decodable {
    
    private enum Key: String, CodingKey {
        case countryCode
        case countryCallingCode
        case country
        case displayName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { countryCode        = try container.decode(String.self, forKey: .countryCode) }        catch { throw DecodingError.keyNotFound(Key.countryCode, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a countryCode.")) }
        do { countryCallingCode = try container.decode(String.self, forKey: .countryCallingCode) } catch { throw DecodingError.keyNotFound(Key.countryCallingCode, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a countryCallingCode.")) }
        do { country            = try container.decode(String.self, forKey: .country) }            catch { throw DecodingError.keyNotFound(Key.country, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a country.")) }
        do { localizedString    = try container.decode(String.self, forKey: .displayName) }        catch { throw DecodingError.keyNotFound(Key.displayName, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a displayName.")) }
    }
}
