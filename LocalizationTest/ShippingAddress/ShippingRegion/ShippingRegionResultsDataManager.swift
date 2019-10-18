//
//  ShippingRegionResultsDataManager.swift
//  weply
//
//  Created by Den Jo on 27/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

// MARK: - Define
struct ShippingRegionResultsNotificationName {
    static let results = Notification.Name("ShippingRegionResultsNotification")
}

final class ShippingRegionResultsDataManager: NSObject {

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
