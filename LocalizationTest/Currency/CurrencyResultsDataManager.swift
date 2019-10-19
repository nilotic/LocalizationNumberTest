//
//  CurrencyResultsDataManager.swift
//  LocalizationTest
//
//  Created by Den Jo on 2019/10/19.
//  Copyright © 2019 Den Jo. All rights reserved.
//

import Foundation

final class CurrencyResultsDataManager: NSObject {

    // MARK: - Value
    // MARK: Public
    var regions = [ShippingRegion]()
    var results = [ShippingRegion]()
    var selectedDeliveryRegionDetail: ShippingRegionDetail? = nil
    
    var keyword: String? = nil {
        didSet { requestSearch() }
    }
    
    
    // MARK: - Fucntion
    // MARK: Public
    func update(selected indexPath: IndexPath) -> Bool {
        guard indexPath.row < results.count, let region = results[indexPath.row] as? ShippingRegionDetail else { return false }
        selectedDeliveryRegionDetail = region
         
        NotificationCenter.default.post(name: ShippingRegionNotificationName.update, object: nil)
        return true
    }
    
    
    // MARK: Private
    private func requestSearch() {
        defer { NotificationCenter.default.post(name: ShippingRegionResultsNotificationName.results, object: nil) }
        results.removeAll()
        
        guard let keyword = keyword?.lowercased() else { return }
        results = regions.filter { $0.localizedString.lowercased().range(of: keyword) != nil }
    }
}
