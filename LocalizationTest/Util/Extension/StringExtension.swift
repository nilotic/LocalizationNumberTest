//
//  StringExtension.swift
//  weply
//
//  Created by Den Jo on 04/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation


extension String {
    
    var koreanConsonant: String? {
        guard let character = first, let utf16 = String(character).utf16.first else { return nil }
        
        switch utf16 {
        case UInt16(0xac00)...UInt16(0xb097):       return "ㄱ"
        case UInt16(0xb098)...UInt16(0xb2e3):       return "ㄴ"
        case UInt16(0xb2e4)...UInt16(0xb77b):       return "ㄷ"
        case UInt16(0xb77c)...UInt16(0xb9c7):       return "ㄹ"
        case UInt16(0xb9c8)...UInt16(0xbc13):       return "ㅁ"
        case UInt16(0xbc14)...UInt16(0xc0ab):       return "ㅂ"
        case UInt16(0xc0ac)...UInt16(0xc543):       return "ㅅ"
        case UInt16(0xc544)...UInt16(0xc78f):       return "ㅇ"
        case UInt16(0xc790)...UInt16(0xcc27):       return "ㅈ"
        case UInt16(0xcc28)...UInt16(0xce73):       return "ㅊ"
        case UInt16(0xce74)...UInt16(0xd0bf):       return "ㅋ"
        case UInt16(0xd0c0)...UInt16(0xd30b):       return "ㅌ"
        case UInt16(0xd30c)...UInt16(0xd557):       return "ㅍ"
        case UInt16(0xd558)...UInt16(0xd7a3):       return "ㅎ"
        default:    return nil
        }
    }
    
    var isEnglish: Bool {
        guard let character = first, let utf16 = String(character).utf16.first else { return false }
        
        switch utf16 {
        case UInt16(0x0041)...UInt16(0x005a):       return true
        case UInt16(0x0061)...UInt16(0x007a):       return true
        default:                                    return false
        }
    }
    
    var isKorean: Bool {
        guard let character = first, let utf16 = String(character).utf16.first else { return false }
        
        switch utf16 {
        case UInt16(0xac00)...UInt16(0xd7a3):       return true
        default:                                    return false
        }
    }
    
    
    var isEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x2600...0x26FF,   // Misc symbols
                 0x2700...0x27BF,   // Dingbats
                 0xFE00...0xFE0F,   // Variation Selectors
                 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                 0x1F1E6...0x1F1FF: // Flags
                return true
            
            default:
                continue
            }
        }
        
        return false
    }
}
