//
//  UICollectionViewAnimation.swift
//  weply
//
//  Created by Den Jo on 08/01/2019.
//  Copyright © 2019 beNX. All rights reserved.
//

import UIKit

struct UICollectionViewAnimationSet {
    let animation: UICollectionViewAnimation
    let rows: [IndexPath]
    let sections: IndexSet
    
    enum UICollectionViewAnimation {
        case insertRows
        case insertSections
        case deleteRows
        case deleteSections
        case reloadRows
        case reloadSections
    }
}

extension UICollectionViewAnimationSet {
    
    init(animation: UICollectionViewAnimation, rows: [IndexPath]) {
        self.animation = animation
        self.rows      = rows
        self.sections  = []
    }
    
    init(animation: UICollectionViewAnimation, sections: IndexSet) {
        self.animation = animation
        self.rows      = []
        self.sections  = sections
    }
}

