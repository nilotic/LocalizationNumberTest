//
//  ToastView.swift
//  weply
//
//  Created by Den Jo on 11/10/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit


final class ToastView: UIView {
    
    // MARK: - Value
    // MARK: Public
    var bottomConstraint: NSLayoutConstraint? = nil
    
    
    
    // MARK: - View Life Cycle
    override func layoutSubviews() {
        layer.masksToBounds = false
        layer.cornerRadius  = bounds.height / 2.0
    }
}

