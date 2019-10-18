//
//  UITableViewAnimationSet.swift
//  weply
//
//  Created by Den Jo on 19/12/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

struct UITableViewAnimationSet {
    let animation: UITableViewAnimation
    let rows: [IndexPath]
    let sections: IndexSet
    let rowAnimation: UITableView.RowAnimation
    
    enum UITableViewAnimation {
        case insertRows
        case insertSections
        case deleteRows
        case deleteSections
        case reloadRows
        case reloadSections
    }
}

extension UITableViewAnimationSet {
    
    init(animation: UITableViewAnimation, rows: [IndexPath], rowAnimation: UITableView.RowAnimation = .automatic) {
        self.animation    = animation
        self.rows         = rows
        self.sections     = []
        self.rowAnimation = rowAnimation
    }
    
    init(animation: UITableViewAnimation, sections: IndexSet, rowAnimation: UITableView.RowAnimation = .automatic) {
        self.animation    = animation
        self.rows         = []
        self.sections     = sections
        self.rowAnimation = rowAnimation
    }
}
