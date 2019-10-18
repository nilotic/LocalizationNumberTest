//
//  Language.swift
//  weply
//
//  Created by Den Jo on 22/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation

struct Language: Equatable {
    let code: LanguageCode
}

extension Language {
    
    init?(languageCode: String?) {
        guard let languageCode = languageCode, let code = LanguageCode(rawValue: languageCode) else { return nil }
        self.code = code
    }
    
    var localizedString: String? {
        return Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue : code.rawValue])).localizedString(forLanguageCode: code.rawValue)
    }
}

extension Language: Codable {
    
    private enum Key: String, CodingKey {
        case code
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(code.rawValue, forKey: .code) } catch { throw error }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do {
            guard let languageCode = LanguageCode(rawValue: try container.decode(String.self, forKey: .code)) else {
                throw DecodingError.keyNotFound(Key.code, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a language code."))
            }
            code = languageCode
            
        } catch { throw DecodingError.keyNotFound(Key.code, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get a language code.")) }
    }
}
