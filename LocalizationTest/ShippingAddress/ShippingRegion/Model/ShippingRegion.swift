//
//  ShippingRegion.swift
//  weply
//
//  Created by Den Jo on 27/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

protocol ShippingRegion {
    var countryCode: String { get }
    var countryCallingCode: String { get }
    var country: String { get }
    var localizedString: String { get }
}
