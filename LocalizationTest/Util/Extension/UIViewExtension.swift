//
//  UIViewExtension.swift
//  weply
//
//  Created by Den Jo on 01/12/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

extension UIView {
    
    var renderedImage: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    }
}
