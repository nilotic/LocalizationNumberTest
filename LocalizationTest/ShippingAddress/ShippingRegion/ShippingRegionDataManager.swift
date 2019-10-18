//
//  ShippingRegionDataManager.swift
//  weply
//
//  Created by Den Jo on 27/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

// MARK: - Define
struct ShippingRegionNotificationName {
    static let regions = Notification.Name("ShippingRegionNotification")
    static let update  = Notification.Name("ShippingRegionUpdateNotification")
}



final class ShippingRegionDataManager: NSObject {

    // MARK: - Value
    // MARK: Public
    var selectedShippingRegionDetail: ShippingRegionDetail? = nil
    var selectedCountryCode: String?                        = nil   // If you have only the countryCode, Use this value
    
    
    // MARK: Public
    private(set) var regions = [[ShippingRegion]]()
    private(set) var titles  = [String]()
    
    
    
    
    // MARK: - Function
    // MARK: Public
    func requestRegions() -> Bool {
        guard let language = LocaleManager.language else { return false }
        
        var deliveryRegions = [ShippingRegionDetail]()
        var sortedRegions   = [ShippingRegionDetail]()
        
        let selectedCountryCode = self.selectedCountryCode ?? ""
        
        // Extract countries
        for code in NSLocale.isoLanguageCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.languageCode.rawValue: code])
            guard let country = NSLocale(localeIdentifier: "en").displayName(forKey: NSLocale.Key.identifier, value: id) else { continue }
            
            var localizedString: String? {
                switch language.code {
                case .english(_):
                    return country
                    
                default:
                    guard let loacalizedString = NSLocale(localeIdentifier: language.code.rawValue).displayName(forKey: NSLocale.Key.identifier, value: id) else { return country }
                    return "\(loacalizedString) (\(country))"
                }
            }
            
            let shippingRegionDetail = ShippingRegionDetail(countryCode: code, countryCallingCode: "", country: country, localizedString: localizedString ?? "")
            
            // Set the selected region
            if selectedShippingRegionDetail == nil, selectedCountryCode == shippingRegionDetail.countryCode {
                selectedShippingRegionDetail = shippingRegionDetail
            }
            
            deliveryRegions.append(shippingRegionDetail)
        }
        
        
        // Handle
        deliveryRegions.sort { $0.localizedString < $1.localizedString }
        
        // Split
        var consonant: String? = nil
        switch language.code {
        case .korean:
            for (i, region) in deliveryRegions.enumerated() {
                guard let first = region.localizedString.koreanConsonant else { continue }
                
                // It's first time.
                guard let currentConsonant = consonant else {
                    consonant = first
                    sortedRegions.append(region)
                    continue
                }
                
                // Just Append [A, AB] + "ABB" , if the consonant is same.
                guard currentConsonant != first else {
                    sortedRegions.append(region)
                    
                    // Handle the last section (A, AA, AAA, B, BB)
                    if deliveryRegions.count - 1 <= i {
                        self.regions.append(sortedRegions)
                        self.titles.append(String(first))
                    }
                    continue
                }
                
                // Append a section [A, AB, ABB, ..., AZZ]
                regions.append(sortedRegions)
                titles.append(currentConsonant)
                
                // Start a new section [B]
                consonant = String(first)
                sortedRegions = [region]
                
                
                // Handle the last one (A, AA, AA, B)
                if deliveryRegions.count - 1 <= i {
                    self.regions.append(sortedRegions)
                    self.titles.append(String(first))
                }
            }
            
        default:
            for (i, region) in deliveryRegions.enumerated() {
                guard let first = region.localizedString.first else { continue }
                
                // It's first time.
                guard let currentConsonant = consonant else {
                    consonant = String(first)
                    sortedRegions.append(region)
                    continue
                }
                
                // Just Append [A, AB] + "ABB" , if the consonant is same.
                guard currentConsonant != String(first) else {
                    sortedRegions.append(region)
                    
                    // Handle the last section (A, AA, AAA, B, BB)
                    if deliveryRegions.count - 1 <= i {
                        self.regions.append(sortedRegions)
                        self.titles.append(String(first))
                    }
                    continue
                }
                
                // Append a section [A, AB, ABB, ..., AZZ]
                regions.append(sortedRegions)
                titles.append(currentConsonant)
                
                // Start a new section [B]
                consonant = String(first)
                sortedRegions = [region]
                
                
                // Handle the last one (A, AA, AA, B)
                if deliveryRegions.count - 1 <= i {
                    self.regions.append(sortedRegions)
                    self.titles.append(String(first))
                }
            }
        }
            
        // Selected region
        if let region = selectedShippingRegionDetail {
            regions.insert([SelectedShippingRegionDetail(countryCode: region.countryCode, countryCallingCode: region.countryCallingCode, country: region.country, localizedString: region.localizedString)], at: 0)
        }
        
        NotificationCenter.default.post(name: ShippingRegionNotificationName.regions, object: nil)
        return true
    }
    
    func update(selected indexPath: IndexPath) -> Bool {
        guard indexPath.section < regions.count, indexPath.row < regions[indexPath.section].count, let region = regions[indexPath.section][indexPath.row] as? ShippingRegionDetail, region != selectedShippingRegionDetail else { return false }
        selectedShippingRegionDetail = region
        
        if regions.first?.first is SelectedShippingRegionDetail  {
            regions[0] = [SelectedShippingRegionDetail(countryCode: region.countryCode, countryCallingCode: region.countryCallingCode, country: region.country, localizedString: region.localizedString)]
            
        } else {
            regions.insert([SelectedShippingRegionDetail(countryCode: region.countryCode, countryCallingCode: region.countryCallingCode, country: region.country, localizedString: region.localizedString)], at: 0)
        }
        
        NotificationCenter.default.post(name: ShippingRegionNotificationName.update, object: nil)
        return true
    }
    
    func update(selected: ShippingRegionDetail?) -> Bool {
        guard let selectedRegion = selected else { return false }
        
        for (section, regions) in regions.enumerated() {
            for (row, region) in regions.enumerated() {
                guard let regionDetail = region as? ShippingRegionDetail, selectedRegion == regionDetail else { continue }
                return update(selected: IndexPath(row: row, section: section))
            }
        }
        return false
    }
    
    
    // MARK: Private
    func handle(data: ShippingRegionResponse) -> Bool {
        guard let language = LocaleManager.language else { return false }
        
        let deliveryRegions = data.countries.sorted { $0.localizedString < $1.localizedString }
        var sortedRegions = [ShippingRegionDetail]()
        
        // Handle
        DispatchQueue.main.async {
            self.regions.removeAll()
            self.titles.removeAll()
            
            // Split
            var consonant: String? = nil
            switch language.code {
            case .korean:
                for region in deliveryRegions {
                    guard let first = region.localizedString.koreanConsonant else { continue }
                    
                    // It's first time.
                    guard let currentConsonant = consonant else {
                        consonant = first
                        sortedRegions.append(region)
                        continue
                    }
                    
                    // Just Append [A, AB] + "ABB" , if the consonant is same.
                    guard currentConsonant != first else {
                        sortedRegions.append(region)
                        continue
                    }
                    
                    // Append a section [A, AB, ABB, ..., AZZ]
                    self.regions.append(sortedRegions)
                    self.titles.append(currentConsonant)
                    
                    // Reset
                    sortedRegions.removeAll()
                    
                    // Start a new section [B]
                    consonant = String(first)
                    sortedRegions.append(region)
                }
                
            default:
                for region in deliveryRegions {
                    guard let first = region.country.first else { continue }
                    
                    // It's first time.
                    guard let currentConsonant = consonant else {
                        consonant = String(first)
                        sortedRegions.append(region)
                        continue
                    }
                    
                    // Just Append [A, AB] + "ABB" , if the consonant is same.
                    guard currentConsonant != String(first) else {
                        sortedRegions.append(region)
                        continue
                    }
                    
                    // Append a section [A, AB, ABB, ..., AZZ]
                    self.regions.append(sortedRegions)
                    self.titles.append(currentConsonant)
                    
                    // Reset
                    sortedRegions.removeAll()
                    
                    // Start a new section [B]
                    consonant = String(first)
                    sortedRegions.append(region)
                }
            }
            
            if let selectedRegion = self.selectedShippingRegionDetail {
                self.regions.insert([selectedRegion], at: 0)
            }
        }
        
        return true
    }
}
