//
//  UIButtonExtension.swift
//  weply
//
//  Created by Den Jo on 06/12/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

extension UIButton {
    
    var indexPath: IndexPath {
        set {
            tag = (newValue.section * 100000) + newValue.row
        }
        
        get {
            let section = tag / 100000
            return IndexPath(row: tag - (section * 100000), section: section)
        }
    }
}
