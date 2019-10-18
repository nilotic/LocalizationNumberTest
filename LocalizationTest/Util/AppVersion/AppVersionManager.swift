//
//  AppVersionManager.swift
//  weply
//
//  Created by Den Jo on 29/01/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import UIKit

struct AppVersionManager {
    
    static var current: String? {
        #if DEBUG
            return "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))"
        #else
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        #endif
    }
    
    static var version: AppVersion? {
        set {
            guard let value = newValue else { return }
            do { UserDefaults.standard.set(try JSONEncoder().encode(value), forKey: UserDefaultsKey.applicationVersions) } catch { }
        }
        
        get {
            guard let data = UserDefaults.standard.value(forKey: UserDefaultsKey.applicationVersions) as? Data, let version = try? JSONDecoder().decode(AppVersion.self, from: data) else { return nil }
            return version
        }
    }
    
    static var isForceUpdated: Bool {
        guard let minimumVersion = version?.minimumVersion, let current = current else { return false }
        return current.compare(minimumVersion, options: .numeric) == .orderedAscending
    }
    
    static var isUpdated: Bool {
        guard let updateVersion = version?.updateVersion, let current = current else { return false }
        
        if let string = UserDefaults.standard.string(forKey: UserDefaultsKey.applicationLatestVersion), string == updateVersion {
            return false
        
        } else {
            UserDefaults.standard.set(updateVersion, forKey: UserDefaultsKey.applicationLatestVersion)
            UserDefaults.standard.synchronize()
        }
        
        return current.compare(updateVersion, options: .numeric) == .orderedAscending
    }
}
