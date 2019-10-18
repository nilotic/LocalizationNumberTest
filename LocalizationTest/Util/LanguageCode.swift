//
//  LanguageCode.swift
//  weply
//
//  Created by Den Jo on 28/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//
//  https://www.ibabbleon.com/iOS-Language-Codes-ISO-639.html
//

import Foundation

enum LanguageCode: Equatable {
    case english(English)
    case chinese(Chinese)
    case korean
    case japanese
    
    enum English {
        case none
        case us
        case uk
        case australian
        case canadian
        case indian
    }
    
    enum Chinese {
        case simplified
        case traditional
        case hongKong
    }
}

extension LanguageCode {
    
    init?(rawValue: String?) {
        guard let rawValue = rawValue else { return nil }
        
        switch rawValue {
        case "en":          self = .english(.none)
        case "en-US":       self = .english(.us)
        case "en-GB":       self = .english(.uk)
        case "en-AU":       self = .english(.australian)
        case "en-CA":       self = .english(.canadian)
        case "en-IN":       self = .english(.indian)
            
        case "zh-Hans":     self = .chinese(.simplified)
        case "zh-Hant":     self = .chinese(.traditional)
        case "zh-HK":       self = .chinese(.hongKong)
            
        case "ko":          self = .korean
        case "ja":          self = .japanese
        default:            return nil
        }
    }
}

extension LanguageCode {
    
    var rawValue: String {
        switch self {
        case .english(let english):
            switch english {
            case .none:              return "en"
            case .us:                return "en-US"
            case .uk:                return "en-GB"
            case .australian:        return "en-AU"
            case .canadian:          return "en-CA"
            case .indian:            return "en-IN"
            }
            
        case .chinese(let chinese):
            switch chinese {
            case .simplified:       return "zh-Hans"
            case .traditional:      return "zh-Hant"
            case .hongKong:         return "zh-HK"
            }
            
        case .korean:               return "ko"
        case .japanese:             return "ja"
        }
    }
}
