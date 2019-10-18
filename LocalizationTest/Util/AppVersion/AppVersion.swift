//
//  AppVersion.swift
//  weply
//
//  Created by Den Jo on 21/05/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import Foundation

struct AppVersion {
    let latestVersion: String
    let updateVersion: String
    let minimumVersion: String
}

extension AppVersion: Codable {
    
    private enum Key: String, CodingKey {
        case latestVersion
        case optionalUpdateVersion
        case minVersion
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do {
            try container.encode(latestVersion,  forKey: .latestVersion)
            try container.encode(updateVersion,  forKey: .optionalUpdateVersion)
            try container.encode(minimumVersion, forKey: .minVersion)
        } catch { throw error }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { latestVersion  = try container.decode(String.self, forKey: .latestVersion) }         catch { throw DecodingError.keyNotFound(Key.latestVersion, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to a latestVersion.")) }
        do { updateVersion  = try container.decode(String.self, forKey: .optionalUpdateVersion) } catch { throw DecodingError.keyNotFound(Key.optionalUpdateVersion, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to an optionalUpdateVersion.")) }
        do { minimumVersion = try container.decode(String.self, forKey: .minVersion) }            catch { throw DecodingError.keyNotFound(Key.minVersion, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to a minimumVersion.")) }
    }
}
