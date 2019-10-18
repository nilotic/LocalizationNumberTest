//
//  BundleExtension.swift
//  weply
//
//  Created by Den Jo on 22/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()
    
    static func set(language: Language?) -> Bool {
        guard let language = language else { return false }
        Bundle.once
        
        let isLanguageRTL = Locale.characterDirection(forLanguage: language.code.rawValue) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight
        
        UserDefaults.standard.set(isLanguageRTL,            forKey: "AppleTextDirection")
        UserDefaults.standard.set(isLanguageRTL,            forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language.code.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        guard let path = Bundle.main.path(forResource: language.code.rawValue, ofType: "lproj") else {
            log(.error, "Failed to get a bundle path.")
            return false
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return true
    }
}
