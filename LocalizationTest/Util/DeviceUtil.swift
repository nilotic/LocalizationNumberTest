//
//  DeviceUtil.swift
//  weply
//
//  Created by Den Jo on 04/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

enum WatchSize {
    case size38
    case size40
    case size42
    case size44
    
    var rawValue: UInt {
        switch self {
        case .size38:       return 38
        case .size40:       return 40
        case .size42:       return 42
        case .size44:       return 44
        }
    }
}

enum HardwareModel {
    // MARK: Hardware OptionSet
    struct HardwareOptions: OptionSet {
        let rawValue: Int
        
        static let none     = HardwareOptions(rawValue: 1 << 0)
        static let wifi     = HardwareOptions(rawValue: 1 << 1)
        static let cdma     = HardwareOptions(rawValue: 1 << 2)
        static let gsm      = HardwareOptions(rawValue: 1 << 3)
        static let cellular = HardwareOptions(rawValue: 1 << 4)
        static let china    = HardwareOptions(rawValue: 1 << 5)
        
        var description: String {
            guard self.contains(.none) == false else { return "" }
            
            var string = ""
            if self.contains(.wifi) {
                string.append("_WIFI")
            }
            if self.contains(.cdma) {
                string.append("_CDMA")
            }
            if self.contains(.gsm) {
                string.append("_GSM")
            }
            if self.contains(.cellular) {
                string.append("_CELLULAR")
            }
            if self.contains(.china) {
                string.append("_CN")
            }
            return string
        }
    }
    
    // ETC
    case unsupported
    case simulator
    
    // iPhone
    case iPhone2G
    case iPhone3G
    case iPhone3GS
    case iPhone4(HardwareOptions)
    case iPhone4S
    case iPhone5(HardwareOptions)
    case iPhone5C(HardwareOptions)
    case iPhone5S(HardwareOptions)
    case iPhone6
    case iPhone6Plus
    case iPhone6S
    case iPhone6SPlus
    case iPhoneSE
    case iPhone7(HardwareOptions)
    case iPhone7Plus(HardwareOptions)
    case iPhone8(HardwareOptions)
    case iPhone8Plus(HardwareOptions)
    case iPhoneX(HardwareOptions)
    case iPhoneXS(HardwareOptions)
    case iPhoneXSMax(HardwareOptions)
    case iPhoneXR(HardwareOptions)
    
    // iPod
    case iPodTouch1
    case iPodTouch2
    case iPodTouch3
    case iPodTouch4
    case iPodTouch5
    case iPodTouch6
    
    // iPad
    case iPad(HardwareOptions)
    case iPad2(HardwareOptions)
    case iPad3(HardwareOptions)
    case iPad4(HardwareOptions)
    case iPad5(HardwareOptions)
    case iPad6(HardwareOptions)
    
    // iPad (Mini)
    case iPadMini(HardwareOptions)
    case iPadMini2(HardwareOptions)
    case iPadMini3(HardwareOptions)
    case iPadMini4(HardwareOptions)
    
    // iPad (Air)
    case iPadAir(HardwareOptions)
    case iPadAir2(HardwareOptions)
    
    // iPad (Pro)
    case iPadPro1_97(HardwareOptions)
    case iPadPro1_129(HardwareOptions)
    
    case iPadPro2_97(HardwareOptions)
    case iPadPro2_105(HardwareOptions)
    
    // Apple TV
    case appleTV1
    case appleTV2
    case appleTV3
    case appleTV3_2
    case appleTV4
    case appleTV4K
    
    // Apple Watch
    case appleWatch(WatchSize)
    case appleWatchSeries1(WatchSize)
    case appleWatchSeries2(WatchSize)
    case appleWatchSeries3(WatchSize)
    case appleWatchSeries4(WatchSize)
}

extension HardwareModel {
    // MARK: - Value
    // MARK: Public
    typealias Inch = Double
    var display: Inch {
        switch self {
        case .iPhone2G, .iPhone3G, .iPhone3GS, .iPhone4(_), .iPhone4S:          return 3.5
        case .iPhone5(_), .iPhone5S(_), .iPhone5C(_), .iPhoneSE:                return 4.0
        case .iPhone6, .iPhone6S, .iPhone7(_), .iPhone8(_):                     return 4.7
        case .iPhone6Plus, .iPhone6SPlus, .iPhone7Plus(_), .iPhone8Plus(_):     return 5.5
        case .iPhoneX(_), .iPhoneXS(_):                                         return 5.8
        case .iPhoneXR(_):                                                      return 6.1
        case .iPhoneXSMax(_):                                                   return 6.5
            
        case .iPodTouch1, .iPodTouch2, .iPodTouch3, .iPodTouch4:                return 3.5
        case .iPodTouch5, .iPodTouch6:                                          return 4.0
            
        case .iPad(_), .iPad2(_), .iPad3(_), .iPad4(_), .iPad5(_), .iPad6(_):   return 9.7
        case .iPadMini(_), .iPadMini2(_), .iPadMini3(_), .iPadMini4(_):         return 7.9
        case .iPadAir(_), .iPadAir2(_):                                         return 9.7
        case .iPadPro1_97(_), .iPadPro2_97(_):                                  return 9.7
        case .iPadPro1_129(_):                                                  return 12.9
        case .iPadPro2_105(_):                                                  return 10.5
            
        case .appleWatch(.size38), .appleWatchSeries1(.size38), .appleWatchSeries2(.size38), .appleWatchSeries3(.size38):
            return 1.35
            
        case .appleWatch(.size42), .appleWatchSeries1(.size42), .appleWatchSeries2(.size42), .appleWatchSeries3(.size42):
            return 1.5
            
        case .appleWatchSeries4(.size40):
            return 1.57
        
        case .appleWatchSeries4(.size44):
            return 1.78
            
        case .simulator: // iPhone only.
            switch UIScreen.main.bounds.width {
            case 320.0:       return 480.0 < UIScreen.main.bounds.height ? 4.0 : 3.5
            case 375.0:       return 667.0 < UIScreen.main.bounds.height ? 5.8 : 4.7
            case 414.0:       return 736.0 < UIScreen.main.bounds.height ? (2.0 < UIScreen.main.scale ? 6.5 : 6.1) : 5.5
            default:          return 0
            }
            
        default:
            return 0
        }
    }
    
    var name: String {
        switch self {
        // MARK: Case
        case .unsupported:      return "Unsupported"
        case .simulator:        return "Simulator"
            
        // iPhone
        case .iPhone2G:         return "iPhone 2G"
        case .iPhone3G:         return "iPhone 3G"
        case .iPhone3GS:        return "iPhone 3GS"
        case .iPhone4:          return "iPhone 4"
        case .iPhone4S:         return "iPhone 4S"
        case .iPhone5(_):       return "iPhone 5"
        case .iPhone5C(_):      return "iPhone 5C"
        case .iPhone5S(_):      return "iPhone 5S"
        case .iPhone6:          return "iPhone 6"
        case .iPhone6Plus:      return "iPhone 6 Plus"
        case .iPhone6S:         return "iPhone 6S"
        case .iPhone6SPlus:     return "iPhone 6S Plus"
        case .iPhoneSE:         return "iPhone SE"
        case .iPhone7(_):       return "iPhone 7"
        case .iPhone7Plus(_):   return "iPhone 7 Plus"
        case .iPhone8(_):       return "iPhone 8"
        case .iPhone8Plus(_):   return "iPhone 8 Plus"
        case .iPhoneX(_):       return "iPhone X"
        case .iPhoneXS(_):      return "iPhone XS"
        case .iPhoneXSMax(_):   return "iPhone XS Max"
        case .iPhoneXR(_):      return "iPhone XR"
            
        // iPod
        case .iPodTouch1:       return "iPodTouch 1"
        case .iPodTouch2:       return "iPodTouch 2"
        case .iPodTouch3:       return "iPodTouch 3"
        case .iPodTouch4:       return "iPodTouch 4"
        case .iPodTouch5:       return "iPodTouch 5"
        case .iPodTouch6:       return "iPodTouch 6"
            
        // iPad
        case .iPad(_):          return "iPad"
        case .iPad2(_):         return "iPad 2"
        case .iPad3(_):         return "iPad 3"
        case .iPad4(_):         return "iPad 4"
        case .iPad5(_):         return "iPad 5"
        case .iPad6(_):         return "iPad 6"
            
        // iPad (Mini)
        case .iPadMini(_):      return "iPad Mini"
        case .iPadMini2(_):     return "iPad Mini 2"
        case .iPadMini3(_):     return "iPad Mini 3"
        case .iPadMini4(_):     return "iPad Mini 4"
            
        // iPad (Air)
        case .iPadAir(_):       return "iPad Air"
        case .iPadAir2(_):      return "iPad Air 2"
            
        // iPad (Pro)
        case .iPadPro1_97(_):   return "iPad Pro 1 9.7"
        case .iPadPro1_129(_):  return "iPad Pro 1 12.9"
            
        case .iPadPro2_97(_):   return "iPad Pro 2"
        case .iPadPro2_105(_):  return "iPad Pro 2 10.5"
            
        // Apple TV
        case .appleTV1:         return "Apple TV 1"
        case .appleTV2:         return "Apple TV 2"
        case .appleTV3:         return "Apple TV 3"
        case .appleTV3_2:       return "Apple TV 3 2G"
        case .appleTV4:         return "Apple TV 4"
        case .appleTV4K:        return "Apple TV 4K"
            
        // Apple Watch
        case .appleWatch(let size):           return "Watch \(size.rawValue)mm"
        case .appleWatchSeries1(let size):    return "Watch Series 1 \(size.rawValue)mm"
        case .appleWatchSeries2(let size):    return "Watch Series 2 \(size.rawValue)mm"
        case .appleWatchSeries3(let size):    return "Watch Series 3 \(size.rawValue)mm"
        case .appleWatchSeries4(let size):    return "Watch Series 4 \(size.rawValue)mm"
        }
    }
    
    var detailName: String {
        switch self {
        // MARK: Case
        case .unsupported:              return name
        case .simulator:                return name
            
        // iPhone
        case .iPhone2G:                 return name
        case .iPhone3G:                 return name
        case .iPhone3GS:                return name
        case .iPhone4:                  return name
        case .iPhone4S:                 return name
        case .iPhone5(let options):     return "\(name)\(options.description)"
        case .iPhone5C(let options):    return "\(name)\(options.description)"
        case .iPhone5S(let options):    return "\(name)\(options.description)"
        case .iPhone6:                  return name
        case .iPhone6Plus:              return name
        case .iPhone6S:                 return name
        case .iPhone6SPlus:             return name
        case .iPhoneSE:                 return name
        case .iPhone7(let options):     return "\(name)\(options.description)"
        case .iPhone7Plus(let options): return "\(name)\(options.description)"
        case .iPhone8(let options):     return "\(name)\(options.description)"
        case .iPhone8Plus(let options): return "\(name)\(options.description)"
        case .iPhoneX(let options):     return "\(name)\(options.description)"
        case .iPhoneXS(let options):    return "\(name)\(options.description)"
        case .iPhoneXSMax(let options): return "\(name)\(options.description)"
        case .iPhoneXR(let options):    return "\(name)\(options.description)"
            
        // iPod
        case .iPodTouch1:               return name
        case .iPodTouch2:               return name
        case .iPodTouch3:               return name
        case .iPodTouch4:               return name
        case .iPodTouch5:               return name
        case .iPodTouch6:               return name
            
        // iPad
        case .iPad(let options):        return "\(name)\(options.description)"
        case .iPad2(let options):       return "\(name)\(options.description)"
        case .iPad3(let options):       return "\(name)\(options.description)"
        case .iPad4(let options):       return "\(name)\(options.description)"
        case .iPad5(let options):       return "\(name)\(options.description)"
        case .iPad6(let options):       return "\(name)\(options.description)"
            
        // iPad (Mini)
        case .iPadMini(let options):    return "\(name)\(options.description)"
        case .iPadMini2(let options):   return "\(name)\(options.description)"
        case .iPadMini3(let options):   return "\(name)\(options.description)"
        case .iPadMini4(let options):   return "\(name)\(options.description)"
            
        // iPad (Air)
        case .iPadAir(let options):     return "\(name)\(options.description)"
        case .iPadAir2(let options):    return "\(name)\(options.description)"
            
        // iPad (Pro)
        case .iPadPro1_97(let options):     return "\(name)\(options.description)"
        case .iPadPro1_129(let options):    return "\(name)\(options.description)"
            
        case .iPadPro2_97(let options):     return "\(name)\(options.description)"
        case .iPadPro2_105(let options):    return "\(name)\(options.description)"
            
        // Apple TV
        case .appleTV1:                 return name
        case .appleTV2:                 return name
        case .appleTV3:                 return name
        case .appleTV3_2:               return name
        case .appleTV4:                 return name
        case .appleTV4K:                return name
            
        // Apple Watch
        case .appleWatch(_):            return name
        case .appleWatchSeries1(_):     return name
        case .appleWatchSeries2(_):     return name
        case .appleWatchSeries3(_):     return name
        case .appleWatchSeries4(_):     return name
        }
    }
}

extension HardwareModel: Equatable {
    
    static func ==(lhs: HardwareModel, rhs: HardwareModel) -> Bool {
        return lhs.name == rhs.name
    }
}


struct Device {
    // MARK: - Value
    // MARK: Public
    static var model: HardwareModel {
        guard let string = modelString else { return .unsupported }
        
        // Model code: http://www.everymac.com, https://www.theiphonewiki.com/wiki/Models
        
        switch string {
        case "iPhone1,1":   return .iPhone2G
        case "iPhone1,2":   return .iPhone3G
        case "iPhone2,1":   return .iPhone3GS
        case "iPhone3,1":   return .iPhone4(.none)
        case "iPhone3,2":   return .iPhone4(.none)
        case "iPhone3,3":   return .iPhone4(.cdma)
        case "iPhone4,1":   return .iPhone4S
        case "iPhone5,1":   return .iPhone5(.none)
        case "iPhone5,2":   return .iPhone5([.cdma, .gsm])
        case "iPhone5,3":   return .iPhone5C(.none)
        case "iPhone5,4":   return .iPhone5C([.cdma, .gsm])
        case "iPhone6,1":   return .iPhone5S(.none)
        case "iPhone6,2":   return .iPhone5S([.cdma, .gsm])
        case "iPhone7,1":   return .iPhone6Plus
        case "iPhone7,2":   return .iPhone6
        case "iPhone8,1":   return .iPhone6S
        case "iPhone8,2":   return .iPhone6SPlus
        case "iPhone8,4":   return .iPhoneSE
        case "iPhone9,1":   return .iPhone7(.none)
        case "iPhone9,2":   return .iPhone7(.gsm)
        case "iPhone9,3":   return .iPhone7Plus(.none)
        case "iPhone9,4":   return .iPhone7Plus(.gsm)
        case "iPhone10,1":  return .iPhone8(.china)
        case "iPhone10,2":  return .iPhone8Plus(.china)
        case "iPhone10,3":  return .iPhoneX(.china)
        case "iPhone10,4":  return .iPhone8(.none)
        case "iPhone10,5":  return .iPhone8Plus(.none)
        case "iPhone10,6":  return .iPhoneX(.none)
        case "iPhone11,2":  return .iPhoneXS(.none)
        case "iPhone11,4":  return .iPhoneXSMax(.china)
        case "iPhone11,6":  return .iPhoneXSMax(.china)
        case "iPhone11,8":  return .iPhoneXR(.none)
            
        case "iPod1,1":     return .iPodTouch1
        case "iPod2,1":     return .iPodTouch2
        case "iPod3,1":     return .iPodTouch3
        case "iPod4,1":     return .iPodTouch4
        case "iPod5,1":     return .iPodTouch5
        case "iPod7,1":     return .iPodTouch6
            
        case "iPad1,1":     return .iPad(.none)
        case "iPad1,2":     return .iPad(.cellular)
        case "iPad2,1":     return .iPad2(.wifi)
        case "iPad2,2":     return .iPad2(.none)
        case "iPad2,3":     return .iPad2(.cdma)
        case "iPad2,4":     return .iPad2(.none)
        case "iPad2,5":     return .iPadMini(.wifi)
        case "iPad2,6":     return .iPadMini(.none)
        case "iPad2,7":     return .iPadMini([.wifi, .cdma])
        case "iPad3,1":     return .iPad3(.wifi)
        case "iPad3,2":     return .iPad3([.wifi, .cdma])
        case "iPad3,3":     return .iPad3(.none)
        case "iPad3,4":     return .iPad4(.wifi)
        case "iPad3,5":     return .iPad4(.none)
        case "iPad3,6":     return .iPad4([.cdma, .gsm])
        case "iPad4,1":     return .iPadAir(.wifi)
        case "iPad4,2":     return .iPadAir([.wifi, .gsm])
        case "iPad4,3":     return .iPadAir([.wifi, .cdma])
        case "iPad4,4":     return .iPadMini2(.wifi)
        case "iPad4,5":     return .iPadMini2([.wifi, .cdma])
        case "iPad4,6":     return .iPadMini2([.wifi, .cdma, .china])
        case "iPad4,7":     return .iPadMini3(.wifi)
        case "iPad4,8":     return .iPadMini3([.wifi, .cellular])
        case "iPad4,9":     return .iPadMini3([.wifi, .cellular, .china])
        case "iPad5,1":     return .iPadMini4(.wifi)
        case "iPad5,2":     return .iPadMini4([.wifi, .cellular])
        case "iPad5,3":     return .iPadAir2(.wifi)
        case "iPad5,4":     return .iPadAir2([.wifi, .cellular])
        case "iPad6,3":     return .iPadPro1_97(.wifi)
        case "iPad6,4":     return .iPadPro1_97([.wifi, .cellular])
        case "iPad6,7":     return .iPadPro1_129(.wifi)
        case "iPad6,8":     return .iPadPro1_129([.wifi, .cellular])
        case "iPad6,11":    return .iPad5(.wifi)
        case "iPad6,12":    return .iPad5([.wifi, .cellular])
        case "iPad7,1":     return .iPadPro2_97(.wifi)
        case "iPad7,2":     return .iPadPro2_97([.wifi, .cellular])
        case "iPad7,3":     return .iPadPro2_105(.wifi)
        case "iPad7,4":     return .iPadPro2_105([.wifi, .cellular])
        case "iPad7,5":     return .iPad6([.wifi])
        case "iPad7,6":     return .iPad6([.wifi, .cellular])
            
        case "AppleTV1,1":  return .appleTV1
        case "AppleTV2,1":  return .appleTV2
        case "AppleTV3,1":  return .appleTV3
        case "AppleTV3,2":  return .appleTV3_2
        case "AppleTV5,3":  return .appleTV4
        case "AppleTV6,2":  return .appleTV4K
            
        case "Watch1,1":    return .appleWatch(.size38)
        case "Watch1,2":    return .appleWatch(.size42)
        case "Watch2,3":    return .appleWatchSeries1(.size38)
        case "Watch2,4":    return .appleWatchSeries1(.size42)
        case "Watch2,6":    return .appleWatchSeries2(.size38)
        case "Watch2,7":    return .appleWatchSeries2(.size42)
        case "Watch3,1":    return .appleWatchSeries3(.size38)
        case "Watch3,2":    return .appleWatchSeries3(.size42)
        case "Watch3,3":    return .appleWatchSeries3(.size38)
        case "Watch3,4":    return .appleWatchSeries3(.size42)
        case "Watch4,1":    return .appleWatchSeries3(.size40)
        case "Watch4,2":    return .appleWatchSeries3(.size44)
        case "Watch4,3":    return .appleWatchSeries3(.size40)
        case "Watch4,4":    return .appleWatchSeries3(.size44)
            
        case "i386", "x86_64":  return .simulator
        default:                return .unsupported
        }
    }
    
    static private var modelString: String? {
        let keys = [CTL_HW, HW_MACHINE]
        let data = keys.withUnsafeBufferPointer() { keysPointer -> [Int8]? in
            var size = 0
            guard sysctl(UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress), UInt32(keys.count), nil, &size, nil, 0) == 0 else { return nil }
            
            let data = [Int8](repeating: 0, count: size)
            let result = data.withUnsafeBufferPointer() { dataBuffer -> Int32 in
                return sysctl(UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress), UInt32(keys.count), UnsafeMutableRawPointer(mutating: dataBuffer.baseAddress), &size, nil, 0)
            }
            
            guard result == 0 else { return nil }
            return data
        }
        
        return data?.withUnsafeBufferPointer() { dataPointer -> String? in
            dataPointer.baseAddress.flatMap { String(validatingUTF8: $0) }
        }
    }
}
