//
//  DeliveryRegionControl.swift
//  weply
//
//  Created by Den Jo on 28/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

// MARK: - Define
protocol DeliveryRegionControlDelegate: class {
    func didSelect(index: UInt)
}



final class DeliveryRegionControl: UIControl {
    
    // MARK: - Value
    // MARK: Public
    var titles = [String]() {
        didSet { DispatchQueue.main.async { self.setTitles() } }
    }
    
    weak var delegate: DeliveryRegionControlDelegate? = nil
    
    
    // MARK: Private
    private let label = UILabel()
    
    // Cache
    private var currentIndex: Int?     = nil
    private var sectionHeight: CGFloat = 0
    
    
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setSearchIcon()
        setLabel()
    }
    
    
    
    // MARK: - Function
    // MARK: Private
    private func setSearchIcon() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "searchSectionIndex"))
        imageView.contentMode   = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive      = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 8.0).isActive         = true
        imageView.widthAnchor.constraint(equalToConstant: 8.0).isActive          = true
    }
    
    private func setLabel() {
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.setContentHuggingPriority(.required, for: .vertical)
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive   = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 12.0).isActive        = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive     = true
    }
    
    private func setTitles() {
        var attributes: [NSAttributedString.Key : Any] {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment         = .center
            paragraphStyle.lineBreakMode     = .byCharWrapping
            
            switch Device.model.display {
            case 3.5, 4.0:  paragraphStyle.lineSpacing = 3.0
            default:        paragraphStyle.lineSpacing = 3.8
                
            }
            
            return [.font            : UIFont.systemFont(ofSize: 9.0, weight: .bold),
                    .foregroundColor : #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1),
                    .paragraphStyle  : paragraphStyle]
        }
        
        
        let string = titles.reduce("") { $0 + "\($0 == "" ? "" : "\n")\($1)" }
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        label.attributedText = attributedString
        label.sizeToFit()
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.sectionHeight = self.label.frame.height / CGFloat(max(1, self.titles.count))
        }
    }
    
    private func handleEvent(point: CGPoint?) {
        guard let point = point, bounds.contains(point) == true, 0 < sectionHeight, sectionHeight != .nan else { return }
        
        let index = Int(point.y / sectionHeight)
        if let currentIndex = currentIndex, currentIndex == index {
            return
        }
        currentIndex = index
        
        delegate?.didSelect(index: UInt(max(0, index-1)))
    }
    
    
    // MARK: - Event
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        handleEvent(point: touch.location(in: self))
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        handleEvent(point: touch?.location(in: self))
    }
}
