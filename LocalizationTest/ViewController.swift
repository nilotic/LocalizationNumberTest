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
    
    @IBOutlet private var countTextField: UITextField!
    @IBOutlet private var countLabel1: UILabel!
    @IBOutlet private var countLabel2: UILabel!
    @IBOutlet private var countLabel3: UILabel!
    @IBOutlet private var countLabel4: UILabel!
    @IBOutlet private var countLabel5: UILabel!
    
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var middleNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    
    @IBOutlet private var nameLabel: UILabel!
    
    @IBOutlet private var distanceTextField: UITextField!
    @IBOutlet private var distanceLabel1: UILabel!
    @IBOutlet private var distanceLabel2: UILabel!

    @IBOutlet private var weightTextField: UITextField!
    @IBOutlet private var weightLabel1: UILabel!
    @IBOutlet private var weightLabel2: UILabel!
    @IBOutlet private var weightLabel3: UILabel!
    @IBOutlet private var weightLabel4: UILabel!
    @IBOutlet private var weightLabel5: UILabel!
    @IBOutlet private var weightLabel6: UILabel!
    
    
    
    @IBOutlet private var currencyButton: UIButton!
    @IBOutlet private var currencyTextField: UITextField!
    @IBOutlet private var currencyLabel1: UILabel!
    @IBOutlet private var currencyLabel2: UILabel!
    
    
    
    // MARK: - Value
    // MARK: Private
    private var currentDate = Date()
    private var shippingRegion: ShippingRegionDetail? = nil
    private var currency: ShippingRegionDetail?       = nil
    
    private let dateFormatter     = DateFormatter()
    private let numberFormatter   = NumberFormatter()
    private var components        = PersonNameComponents()
    private let weightFormatter   = MassFormatter()
    private let currencyFormatter = NumberFormatter()
    
    private let currencyCodes = Locale.isoCurrencyCodes
    
    
    private var locale: Locale? = nil {
        didSet {
            dateFormatter.locale     = locale
            numberFormatter.locale   = locale
            currencyFormatter.locale = locale
        }
    }
    
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weightFormatter.isForPersonMassUse = true
        
        currencyFormatter.numberStyle  = .currency
        currencyFormatter.currencyCode = "USD"
        currencyFormatter.locale       = Locale(identifier: "en_US")
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func update() {
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormatTextField.text ?? "")
        dateLabel1.text = dateFormatter.string(from: Date())
        
        
        let count = Double(countTextField.text ?? "") ?? 0
        numberFormatter.numberStyle = .decimal
        countLabel1.text = numberFormatter.string(for: count)
        
        numberFormatter.numberStyle = .percent
        countLabel2.text = numberFormatter.string(for: count)
        
        numberFormatter.numberStyle = .spellOut
        countLabel3.text = numberFormatter.string(for: count)
        
        numberFormatter.numberStyle = .ordinal
        countLabel4.text = numberFormatter.string(for: count)
               
        numberFormatter.numberStyle = .scientific
        countLabel5.text = numberFormatter.string(for: count)

        
        components.givenName  = firstNameTextField.text
        components.middleName = middleNameTextField.text
        components.familyName = lastNameTextField.text
        
        
        nameLabel.text = PersonNameComponentsFormatter.localizedString(from: components, style: .long, options: [])
        
        
        let distance = Double(distanceTextField.text ?? "") ?? 0
        distanceLabel1.text = LengthFormatter().string(fromValue: Measurement<UnitLength>(value: distance, unit: .meters).converted(to: .kilometers).value, unit: .kilometer)
        distanceLabel2.text = LengthFormatter().string(fromValue: Measurement<UnitLength>(value: distance, unit: .meters).converted(to: .inches).value, unit: .inch)
        
        
        let weight = Double(weightTextField.text ?? "") ?? 0
        weightFormatter.unitStyle = .short
        weightLabel1.text = weightFormatter.string(fromValue: weight, unit: .kilogram)
        weightLabel2.text = weightFormatter.string(fromValue: weight, unit: .pound)
        
        weightFormatter.unitStyle = .medium
        weightLabel3.text = weightFormatter.string(fromValue: weight, unit: .kilogram)
        weightLabel4.text = weightFormatter.string(fromValue: weight, unit: .pound)
        
        weightFormatter.unitStyle = .long
        weightLabel5.text = weightFormatter.string(fromValue: weight, unit: .kilogram)
        weightLabel6.text = weightFormatter.string(fromValue: weight, unit: .pound)
        
        
        let price = Double(currencyTextField.text ?? "") ?? 0
        currencyLabel1.text = currencyFormatter.string(for: price)
        
        numberFormatter.numberStyle = .currencyPlural
        currencyLabel2.text = currencyFormatter.string(for: price)
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
            dateFormatter.setLocalizedDateFormatFromTemplate(text)
            dateLabel1.text = dateFormatter.string(from: Date())
            
        case .count:
            guard let count = Int(text) else { return }
            
            numberFormatter.numberStyle = .decimal
            countLabel1.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .percent
            countLabel2.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .spellOut
            countLabel3.text = numberFormatter.string(for: count)
            
            numberFormatter.numberStyle = .ordinal
            countLabel4.text = numberFormatter.string(for: count)
                   
            numberFormatter.numberStyle = .scientific
            countLabel5.text = numberFormatter.string(for: count)

            
        case .firtName, .middleName, .lastName:
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
            weightFormatter.unitStyle = .short
            weightLabel1.text = weightFormatter.string(fromValue: weight, unit: .kilogram)
            weightLabel2.text = weightFormatter.string(fromValue: weight, unit: .pound)
            
            weightFormatter.unitStyle = .medium
            weightLabel3.text = weightFormatter.string(fromValue: weight, unit: .kilogram)
            weightLabel4.text = weightFormatter.string(fromValue: weight, unit: .pound)
            
            weightFormatter.unitStyle = .long
            weightLabel5.text = weightFormatter.string(fromValue: weight, unit: .kilogram)
            weightLabel6.text = weightFormatter.string(fromValue: weight, unit: .pound)
            
        case .currency:
            guard let price = Double(text) else { return }
            currencyLabel1.text = currencyFormatter.string(for: price)

            numberFormatter.numberStyle = .currencyPlural
            currencyLabel2.text = currencyFormatter.string(for: price)
        }
    }
    
    @IBAction private func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}



// MARK: - UITextField Delegate
extension ViewController: UITextFieldDelegate {
    
    private enum TextField: Int {
        case dateFormat = 0
        case count      = 1
        case firtName   = 2
        case middleName = 3
        case lastName   = 4
        case distance   = 5
        case weight     = 6
        case currency   = 7
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
        locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue : region.countryCode]))
     
        update()
    }
      
    func didSelect(currency: String?) {
        guard let currency = currency else { return }
        currencyFormatter.currencyCode = currency
        
        let price = Double(currencyTextField.text ?? "") ?? 0
        currencyLabel1.text = currencyFormatter.string(for: price)
        
        numberFormatter.numberStyle = .currencyPlural
        currencyLabel2.text = currencyFormatter.string(for: price)
    }
}



// MARK: - Segue
extension ViewController: SegueHandlerType {
    
    
    // MARK: Enum
    enum SegueIdentifier: String {
        case shippingCountry = "ShippingCountrySegue"
        case currency        = "CurrencySegue"
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
            
        case .currency:
            guard let viewController = (segue.destination as? UINavigationController)?.children.first as? CurrencyViewController else {
                log(.error, "Failed to get a CurrencyViewController.")
                return
            }
            
            viewController.dataManager.selectedShippingRegionDetail = shippingRegion
            viewController.delegate = self
        }
    }
}

