//
//  AES.swift
//  weply
//
//  Created by Den Jo on 11/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import Foundation
import CommonCrypto

struct AES {
    
    // MARK: - Value
    // MARK: Private
    static private let key = "social_key12liad"
    static private let iv  = String(key[..<key.index(key.startIndex, offsetBy: 16)])
    
    
    // MARK: - Function
    // MARK: Public
    static func encrypt(string: String?) -> Data? {
        guard let string = string else { return nil }
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    static func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }
    
    static func crypt(data: Data?, option: CCOperation) -> Data? {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }
        
        guard let data = data else { return nil }
        
        let cryptLength = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128).count
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = [UInt8](repeating: 0, count: kCCBlockSizeAES128).count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        var cryptBytes = [UInt8](repeating: 0, count: cryptData.count)
        let dataBytes  = [UInt8](repeating: 0, count: data.count)
        let ivBytes    = [UInt8](repeating: 0, count: ivData.count)
        let keyBytes   = [UInt8](repeating: 0, count: keyData.count)
        let status     = CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes, keyLength, ivBytes, dataBytes, data.count, &cryptBytes, cryptLength, &bytesLength)
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}
