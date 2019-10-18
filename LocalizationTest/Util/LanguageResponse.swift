//
//  LanguageResponse.swift
//  weply
//
//  Created by Den Jo on 26/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

struct LanguageResponse {
    let languages: [Language]
}

extension LanguageResponse: Decodable {
    
    private enum Key: String, CodingKey {
        case languageCodes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do {
            let codes = try container.decode([String].self, forKey: .languageCodes)
            languages = codes.compactMap { Language(languageCode: $0) }
            
        } catch { throw DecodingError.keyNotFound(Key.languageCodes, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get languageCodes.")) }
      
    }
}
