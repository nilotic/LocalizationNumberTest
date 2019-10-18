//
//  RSA.swift
//  weverse
//
//  Created by Den Jo on 29/03/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import Foundation
import Security

struct RSA {
    
    static func encrypt(string: String, publicKey: String?) -> String? {
        guard let publicKey = publicKey else { return nil }
        
        let keyString = publicKey.replacingOccurrences(of: "-----BEGIN RSA PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END RSA PUBLIC KEY-----", with: "")
        guard let data = Data(base64Encoded: keyString) else { return nil }
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : true] as CFDictionary
        }
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            log(.error, error.debugDescription)
            return nil
        }
        
        let buffer = [UInt8](string.utf8)
        
        var keySize   = SecKeyGetBlockSize(secKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        guard SecKeyEncrypt(secKey, .OAEP, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}
