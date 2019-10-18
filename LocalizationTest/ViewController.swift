//
//  ViewController.swift
//  LocalizationTest
//
//  Created by Den Jo on 2019/10/18.
//  Copyright © 2019 Den Jo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var countryButton: UIButton!
    @IBOutlet private var dateFormatTextField: UITextField!
    @IBOutlet private var dateLabel1: UILabel!
    
    @IBOutlet private var countLabel1: UILabel!
    @IBOutlet private var countLabel2: UILabel!
    @IBOutlet private var countLabel3: UILabel!
    @IBOutlet private var countLabel4: UILabel!
    
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var middleNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    
    @IBOutlet private var nameLabel: UILabel!
    
    @IBOutlet private var distanceLabel1: UILabel!
    @IBOutlet private var distanceLabel2: UILabel!

    @IBOutlet private var weightLabel1: UILabel!
    @IBOutlet private var weightLabel2: UILabel!
    
    
    
    
    // MARK: - Value
    // MARK: Private
    private var currentDate = Date()
    private var shippingRegion: ShippingRegionDetail? = nil
    

    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - Notification
    @objc private func didReceiveKeyboardWillShow(notification: Notification) {
        scrollView.contentInset.bottom = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero).height
    }
    
    @objc private func didReceiveKeyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    
    
    // MARK: - Event
    @IBAction private func dateFormatTextFieldEditingChanged(_ sender: UITextField) {
        guard let type = TextField(rawValue: sender.tag), let text = sender.text else { return }
        
        guard sender.text != " " else {
            sender.text = nil
            return
        }
        
        switch type {
        case .dateFormat:
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate(text)
            dateLabel1.text = dateFormatter.string(from: Date())
            
        case .count:
            guard let count = Int(text) else { return }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            countLabel1.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .percent
            countLabel2.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .currencyPlural
            countLabel3.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .ordinal
            countLabel4.text = numberFormatter.string(for: count)
            
            
        case .firtName, .middleName, .lastName:
               var components = PersonNameComponents()
               components.givenName  = firstNameTextField.text
               components.middleName = middleNameTextField.text
               components.familyName = lastNameTextField.text
               nameLabel.text = PersonNameComponentsFormatter.localizedString(from: components, style: .long, options: [])
        
        case .distance:
            guard let distance = Double(text) else { return }
            distanceLabel1.text = LengthFormatter().string(fromValue: Measurement<UnitLength>(value: distance, unit: .meters).converted(to: .kilometers).value, unit: .kilometer)
            distanceLabel2.text = LengthFormatter().string(fromValue: Measurement<UnitLength>(value: distance, unit: .meters).converted(to: .inches).value, unit: .inch)
            
        case .weight:
            guard let weight = Double(text) else { return }
            let weightFormatter = MassFormatter()
            weightFormatter.isForPersonMassUse = true
            weightLabel1.text = weightFormatter.string(fromKilograms: weight)

            weightFormatter.unitStyle = .long
            weightLabel2.text = weightFormatter.string(fromValue: weight, unit: .pound)
        }
    }
}









// MARK: - UITextField Delegate
extension ViewController: UITextFieldDelegate {
    
    private enum TextField: Int {
        case dateFormat       = 0
        case count       = 1
        case firtName     = 2
        case middleName        = 3
        case lastName       = 4
        case distance  = 5
        case weight = 6
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let type = TextField(rawValue: textField.tag), let text = textField.text else { return }
        
        guard textField.text != " " else {
            textField.text = nil
            return
        }
        
        switch type {
        case .dateFormat:
            let dateFormatter = DateFormatter()
            if let countryCode = shippingRegion?.countryCode {
                dateFormatter.locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue : countryCode]))
            }
                
            dateFormatter.setLocalizedDateFormatFromTemplate(text)
            dateLabel1.text = dateFormatter.string(from: Date())
            
        case .count:
            guard let count = Int(text) else { return }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            countLabel1.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .percent
            countLabel2.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .currencyPlural
            countLabel3.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .ordinal
            countLabel4.text = numberFormatter.string(for: count)
            
            
        case .firtName, .middleName, .lastName:
            var components = PersonNameComponents()
            components.givenName  = firstNameTextField.text
            components.middleName = middleNameTextField.text
            components.familyName = lastNameTextField.text
            nameLabel.text = PersonNameComponentsFormatter.localizedString(from: components, style: .long, options: [])
            
        case .distance:
            guard let distance = Double(text) else { return }
            distanceLabel1.text = LengthFormatter().string(fromValue: Measurement<UnitLength>(value: distance, unit: .meters).converted(to: .kilometers).value, unit: .kilometer)
            distanceLabel2.text = LengthFormatter().string(fromValue: Measurement<UnitLength>(value: distance, unit: .meters).converted(to: .inches).value, unit: .inch)
            
        case .weight:
            guard let weight = Double(text) else { return }
            let weightFormatter = MassFormatter()
            weightFormatter.isForPersonMassUse = true
            weightLabel1.text = weightFormatter.string(fromKilograms: weight)
            
            weightFormatter.unitStyle = .long
            weightLabel2.text = weightFormatter.string(fromValue: weight, unit: .pound)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}



// MARK: - ShippingRegionViewController Delegate
extension ViewController: ShippingRegionViewControllerDelegate {
    
    func didSelect(region: ShippingRegionDetail?) {
        guard let region = region else { return }
        countryButton.setTitle(region.country, for: .normal)
        
                   
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue : region.countryCode]))
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormatTextField.text ?? "")
        dateLabel1.text = dateFormatter.string(from: Date())
    }
}


// MARK: - Segue
extension ViewController: SegueHandlerType {
    
    
    // MARK: Enum
    enum SegueIdentifier: String {
        case shippingCountry = "ShippingCountrySegue"
    }
    
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segueIdentifier(with: segue) else {
            log(.error, "Failed to get a segueIdentifier.")
            return
        }
        
        view.endEditing(true)
        
        switch segueIdentifier {
        case .shippingCountry:
            guard let viewController = (segue.destination as? UINavigationController)?.children.first as? ShippingRegionViewController else {
                log(.error, "Failed to get a ShippingRegionViewController.")
                return
            }
            
            viewController.dataManager.selectedShippingRegionDetail = shippingRegion
            viewController.delegate = self
        }
    }
}

