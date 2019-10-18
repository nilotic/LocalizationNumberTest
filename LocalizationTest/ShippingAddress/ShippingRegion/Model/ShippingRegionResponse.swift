//
//  ShippingRegionResponse.swift
//  weply
//
//  Created by Den Jo on 06/12/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

struct ShippingRegionResponse: Decodable {
    let countries: [ShippingRegionDetail]
}
