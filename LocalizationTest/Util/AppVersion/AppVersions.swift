//
//  AppVersions.swift
//  weply
//
//  Created by Den Jo on 21/05/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import Foundation

struct AppVersions {
    let version: AppVersion
}

extension AppVersions: Decodable {
    
    private enum Key: String, CodingKey {
        case ios
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        do { version  = try container.decode(AppVersion.self, forKey: .ios) } catch { throw DecodingError.keyNotFound(Key.ios, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to a appVersion.")) }
    }
}
