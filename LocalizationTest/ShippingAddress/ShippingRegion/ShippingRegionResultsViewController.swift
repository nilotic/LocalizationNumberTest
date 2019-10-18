//
//  ShippingRegionResultsViewController.swift
//  weply
//
//  Created by Den Jo on 27/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

// MARK: - Define
protocol ShippingRegionResultsViewControllerDelegate: class {
    func didSelect(region: ShippingRegionDetail?)
}

final class ShippingRegionResultsViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var tableView: UITableView!
    @IBOutlet private var doneButton: UIButton!
    
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var okButtonBottomConstraint: NSLayoutConstraint!
    
    
    
    // MARK: - Value
    // MARK: Public
    let dataManager = ShippingRegionResultsDataManager()
    
    weak var delegate: ShippingRegionResultsViewControllerDelegate? = nil
    
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveResults(notification:)),          name: ShippingRegionResultsNotificationName.results, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification,      object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification,      object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func setButton() {
        // Save Button
        let string = NSLocalizedString("Done", comment: "")
        
        let attributes = { (isEnabled: Bool) -> [NSAttributedString.Key : Any] in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment         = .left
            paragraphStyle.lineBreakMode     = .byWordWrapping
            paragraphStyle.minimumLineHeight = 22.0
            paragraphStyle.maximumLineHeight = 22.0
            
            return [.font            : UIFont.systemFont(ofSize: 16.0, weight: .medium),
                    .foregroundColor : isEnabled == true ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : (UIColor(named: "lightGreyBlue") ?? #colorLiteral(red: 0.6784313725, green: 0.6941176471, blue: 0.7215686275, alpha: 1)),
                    .paragraphStyle  : paragraphStyle]
        }
        
        doneButton.setAttributedTitle(NSAttributedString(string: string, attributes: attributes(true)),  for: .normal)
        doneButton.setAttributedTitle(NSAttributedString(string: string, attributes: attributes(false)), for: .disabled)
    }
    
    
    // MARK: - Notification
    @objc private func didReceiveResults(notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.doneButton.isEnabled = self.dataManager.selectedDeliveryRegionDetail != nil
        }
    }
    
    @objc private func didReceiveKeyboardWillShow(notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.tableViewBottomConstraint.constant = keyboardFrame.height
            self.okButtonBottomConstraint.constant  = 20.0 + keyboardFrame.height - self.view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func didReceiveKeyboardWillHide(notification: Notification) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.tableViewBottomConstraint.constant = 0
            self.okButtonBottomConstraint.constant  = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Event
    @IBAction private func doneButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }, completion: nil)
    }
    
    @IBAction private func doneButtonTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            sender.transform = .identity
            
        }) { finished in
            self.delegate?.didSelect(region: self.dataManager.selectedDeliveryRegionDetail)
        }
    }
    
    @IBAction private func doneButtonTouchDragOutside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            sender.transform = .identity
        }, completion: nil)
    }
}


// MARK: - UITableView
// MARK: DataSource
extension ShippingRegionResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < dataManager.results.count, let cell = tableView.dequeueReusableCell(withIdentifier: ShippingRegionCellInfo.identifier) as? ShippingRegionCell else { return UITableViewCell() }
        let data = dataManager.results[indexPath.row]
        cell.update(data: data)
        
        if dataManager.selectedDeliveryRegionDetail?.country == data.country {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
}

// MARK: Delegate
extension ShippingRegionResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: selectedIndexPath)?.isSelected = false
        }
        
        guard dataManager.update(selected: indexPath) == true else { return nil }
        tableView.cellForRow(at: indexPath)?.isSelected = true
        doneButton.isEnabled = true
        return indexPath
    }
}
