//
//  ShippingRegionCell.swift
//  weply
//
//  Created by Den Jo on 27/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

// MARK: - Define
struct ShippingRegionCellInfo {
    static let identifier = "ShippingRegionCell"
}

final class ShippingRegionCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private var radioButtonImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var countryCallingCodeLabel: UILabel!
    
    
    
    // MARK: - Value
    // MARK: Public
    override var isSelected: Bool {
        didSet {
            radioButtonImageView.isHighlighted = isSelected
            
            if let attributedText = titleLabel.attributedText {
                titleLabel.attributedText = NSAttributedString(string: attributedText.string, attributes: isSelected == false ? defaultAttributes : selectedAttributes)
            }
            
            if let attributedText = countryCallingCodeLabel.attributedText {
                countryCallingCodeLabel.attributedText = NSAttributedString(string: attributedText.string, attributes: isSelected == false ? countryCallingCodeDefaultAttributes : countryCallingCodeSelectedAttributes)
            }
        }
    }
    
    
    // MARK: Private
    private var paragraphStyle: NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment         = .left
        paragraphStyle.lineBreakMode     = .byWordWrapping
        paragraphStyle.minimumLineHeight = 20.0
        paragraphStyle.maximumLineHeight = 20.0
        return paragraphStyle
    }
    
    private var defaultAttributes: [NSAttributedString.Key : Any] {
        return [.font            : UIFont.systemFont(ofSize: 16.0),
                .foregroundColor : UIColor(named: "uiBlackSolid") ?? #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1137254902, alpha: 1),
                .paragraphStyle  : paragraphStyle]
    }
    
    private var selectedAttributes: [NSAttributedString.Key : Any] {
        return [.font            : UIFont.systemFont(ofSize: 16.0),
                .foregroundColor : UIColor(named: "brandBlueSolid") ?? #colorLiteral(red: 0.07058823529, green: 0.3960784314, blue: 1, alpha: 1),
                .paragraphStyle  : paragraphStyle]
    }
    
    private var countryCallingCodeParagraphStyle: NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment         = .right
        paragraphStyle.lineBreakMode     = .byWordWrapping
        paragraphStyle.minimumLineHeight = 20.0
        paragraphStyle.maximumLineHeight = 20.0
        return paragraphStyle
    }
    
    private var countryCallingCodeDefaultAttributes: [NSAttributedString.Key : Any] {
        return [.font            : UIFont.systemFont(ofSize: 16.0),
                .foregroundColor : UIColor(named: "uiBlackSolid") ?? #colorLiteral(red: 0.1098039216, green: 0.1137254902, blue: 0.1137254902, alpha: 1),
                .paragraphStyle  : countryCallingCodeParagraphStyle]
    }
    
    private var countryCallingCodeSelectedAttributes: [NSAttributedString.Key : Any] {
        return [.font            : UIFont.systemFont(ofSize: 16.0),
                .foregroundColor : UIColor(named: "brandBlueSolid") ?? #colorLiteral(red: 0.07058823529, green: 0.3960784314, blue: 1, alpha: 1),
                .paragraphStyle  : countryCallingCodeParagraphStyle]
    }
    
    
    
    // MARK: - Function
    // MARK: Public
    func update(data: ShippingRegion) {
        titleLabel.attributedText              = NSAttributedString(string: data.localizedString, attributes: defaultAttributes)
        countryCallingCodeLabel.attributedText = NSAttributedString(string: "+\(data.countryCallingCode)", attributes: countryCallingCodeDefaultAttributes)
    }
}
