//
//  ShippingRegionViewController.swift
//  weply
//
//  Created by Den Jo on 27/11/2018.
//  Copyright © 2018 beNX. All rights reserved.
//

import UIKit

// MARK: - Define
protocol ShippingRegionViewControllerDelegate: class {
    func didSelect(region: ShippingRegionDetail?)
}

final class ShippingRegionViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var deliveryRegionControl: DeliveryRegionControl!
    @IBOutlet private var sectionIndexTitleView: UIView!
    @IBOutlet private var sectionIndexTitleLabel: UILabel!
    @IBOutlet private var doneButton: UIButton!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private var deliveryRegionControlTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Value
    // MARK: Public
    let dataManager = ShippingRegionDataManager()
    
    weak var delegate: ShippingRegionViewControllerDelegate? = nil
    
    
    // MARK: Private
    private let resultsViewController = UIStoryboard(name: "ShippingAddress", bundle: nil).instantiateViewController(withIdentifier: "ShippingRegionResultsViewController") as? ShippingRegionResultsViewController
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultsViewController)
        resultsViewController?.delegate = self
        
        searchController.searchResultsUpdater  = self
        searchController.delegate              = self
        searchController.searchBar.delegate    = self
        searchController.searchBar.placeholder = NSLocalizedString("Search country and region", comment: "")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("Cancel", comment: "")

        
        UITextField.appearance(whenContainedInInstancesOf: [type(of: searchController.searchBar)]).tintColor = #colorLiteral(red: 0.2588235294, green: 0.4235294118, blue: 0.937254902, alpha: 1)
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchController.searchBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Status Bar backgroun view
        let view = UIView(frame: CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchController.searchBar.addSubview(view)

        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation     = true
        searchController.searchBar.sizeToFit()
        return searchController
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(refreshControl)
        if let headerView = tableView.tableHeaderView {
            tableView.bringSubviewToFront(headerView)
        }
        
        refreshControl.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        refreshControl.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0).isActive = true
        return refreshControl
    }()
    
    // Cache
    private var keyboardHeight: CGFloat = 0

    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchView()
        setTableView()
        setDeliveryRegionControl()
        setButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRegions(notification:)),          name: ShippingRegionNotificationName.regions,   object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveUpdate(notification:)),           name: ShippingRegionNotificationName.update,    object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        guard dataManager.requestRegions() == true else { return }
        activityIndicatorView.startAnimating()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - Function
    // MARK: Private
    private func setSearchView() {
        definesPresentationContext       = true
        extendedLayoutIncludesOpaqueBars = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Search Bar animation
        searchController.searchBar.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.38) {
                self.searchController.searchBar.alpha = 1.0
            }
        }
    }
    
    private func setTableView() {
        tableView.contentInset.bottom = 90.0
        tableView.sectionIndexColor   = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
    }
    
    private func setDeliveryRegionControl() {
        switch Device.model.display {
        case 3.5, 4.0:  deliveryRegionControlTopConstraint.constant = 15.0
        default:        break
        }
        
        deliveryRegionControl.delegate = self
    }
    
    private func setButton() {
        // Save Button
        let string = NSLocalizedString("Done", comment: "")
        
        let attributes = { (isEnabled: Bool) -> [NSAttributedString.Key : Any] in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment         = .center
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
    
    private func updateDeliveryRegionControl() {
        deliveryRegionControl.titles = dataManager.titles
        DispatchQueue.main.async { self.view.layoutIfNeeded() }
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        guard dataManager.requestRegions() == true else { return }
        refreshControl.beginRefreshing()
    }
    
    
    
    
    // MARK: - Notification
    @objc private func didReceiveRegions(notification: Notification) {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.refreshControl.endRefreshing()
        }
        
        guard notification.object == nil else {
            Toast.show(message: (notification.object as? ResponseDetail)?.message ?? NSLocalizedString("Please check your network connection or try again.", comment: ""))
            return
        }
        
        DispatchQueue.main.async {
            var regions = self.dataManager.regions
            if regions.first?.first is SelectedShippingRegionDetail {
                regions.removeFirst()
            }
            
            self.resultsViewController?.dataManager.regions = regions.flatMap { $0 }
            self.updateDeliveryRegionControl()
            self.tableView.reloadData()
            
            self.doneButton.isEnabled = self.dataManager.selectedShippingRegionDetail != nil
        }
    }
    
    @objc private func didReceiveUpdate(notification: Notification) {
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setCompletionBlock { self.tableView.reloadData() }
            
            self.tableView.beginUpdates()
            if self.tableView.numberOfSections < self.dataManager.regions.count {
                self.tableView.insertSections([0], with: .automatic)
                
            } else {
                self.tableView.reloadSections([0], with: .none)
            }
            
            self.tableView.endUpdates()
            CATransaction.commit()
        }
    }
    
    @objc private func didReceiveKeyboardWillShow(notification: Notification) {
        keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero).height
    }
    
    @objc private func didReceiveKeyboardWillHide(notification: Notification) {
        keyboardHeight = 0
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
            DispatchQueue.main.async {
                self.dismiss(animated: true) { self.delegate?.didSelect(region: self.dataManager.selectedShippingRegionDetail) }
            }
        }
    }
    
    @IBAction private func doneButtonTouchDragOutside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            sender.transform = .identity
        }, completion: nil)
    }
    
    @IBAction private func closeBarButtonItemAction(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async { self.dismiss(animated: true) }
    }
}


// MARK: - UITableView
// MARK: DataSource
extension ShippingRegionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.regions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.regions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < dataManager.regions.count, indexPath.row < dataManager.regions[indexPath.section].count, let cell = tableView.dequeueReusableCell(withIdentifier: ShippingRegionCellInfo.identifier) as? ShippingRegionCell else { return UITableViewCell() }
        let data = dataManager.regions[indexPath.section][indexPath.row]
        cell.update(data: data)
        
        if dataManager.selectedShippingRegionDetail?.country == data.country {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
}

// MARK: Delegate
extension ShippingRegionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title: String {
            guard let data = dataManager.regions[section].first else { return "" }
            switch data {
            case is SelectedShippingRegionDetail:
                return NSLocalizedString("Currently selected", comment: "")
                
            case let data as ShippingRegionDetail:
                guard let first = data.localizedString.first else { return "" }
                switch (LocaleManager.language?.code ?? LanguageCode.english(.none)) {
                case .korean:       return String(first).koreanConsonant ?? ""
                default:            return String(first)
                }
                
            default:
                return ""
            }
        }
        
        var attributedString: NSAttributedString? {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment         = .left
            paragraphStyle.lineBreakMode     = .byWordWrapping
            paragraphStyle.minimumLineHeight = 18.0
            paragraphStyle.maximumLineHeight = 18.0
            
            return NSAttributedString(string: title, attributes: [.font            : UIFont.systemFont(ofSize: 14.0),
                                                                  .foregroundColor : UIColor(named: "grayscaleNormal") ?? #colorLiteral(red: 0.6784313725, green: 0.6941176471, blue: 0.7215686275, alpha: 1),
                                                                  .paragraphStyle  : paragraphStyle])
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 46.0))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 20, y: 8.0, width: view.frame.width, height: 38.0))
        label.attributedText = attributedString
        label.numberOfLines  = 0
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard dataManager.update(selected: indexPath) == true else { return nil }

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: selectedIndexPath)?.isSelected = false
        }
        
        doneButton.isEnabled = true
        tableView.cellForRow(at: indexPath)?.isSelected = true
        return indexPath
    }
}


// MARK: - UISearchResultsUpdating
extension ShippingRegionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        resultsViewController?.dataManager.keyword = searchController.searchBar.text
    }
}

// MARK: - UISearchControllerDelegate
extension ShippingRegionViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        resultsViewController?.tableViewBottomConstraint.constant = keyboardHeight
        resultsViewController?.okButtonBottomConstraint.constant  = 20.0 + keyboardHeight - self.view.safeAreaInsets.bottom
        
        resultsViewController?.tableView.contentInset.bottom = 90.0
        resultsViewController?.view.layoutIfNeeded()
        
        resultsViewController?.dataManager.selectedDeliveryRegionDetail = dataManager.selectedShippingRegionDetail
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        resultsViewController?.tableViewBottomConstraint.constant = 0
        resultsViewController?.okButtonBottomConstraint.constant  = 20.0
        resultsViewController?.view.layoutIfNeeded()
        
        searchController.searchBar.text = nil
    }
}


// MARK: - UISearchBarDelegate
extension ShippingRegionViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.resultsViewController?.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.resultsViewController?.tableViewBottomConstraint.constant = 0
            self.resultsViewController?.okButtonBottomConstraint.constant  = 20.0
            self.resultsViewController?.view.layoutIfNeeded()
        }
    }
}

extension ShippingRegionViewController: ShippingRegionResultsViewControllerDelegate {
    
    func didSelect(region: ShippingRegionDetail?) {
        guard dataManager.update(selected: region) == true else { return }
        
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true) { self.delegate?.didSelect(region: self.dataManager.selectedShippingRegionDetail) }
        }
    }
}


// MARK: - DeliveryRegionControl Delegate
extension ShippingRegionViewController: DeliveryRegionControlDelegate {
    
    func didSelect(index: UInt) {
        guard index < tableView.numberOfSections else { return }
        let section = dataManager.selectedShippingRegionDetail == nil ? Int(index) : min(dataManager.regions.count-1, (index == 0 ? 0 : Int(index)+1))
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: false)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        guard index < UInt(dataManager.titles.count) else { return }
        
        UIView.animate(withDuration: 0.2) {
            self.sectionIndexTitleView.alpha = 1.0
            self.sectionIndexTitleLabel.text = self.dataManager.titles[Int(index)]
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.7, options: .curveEaseOut, animations: {
            self.sectionIndexTitleView.alpha = 0
        }, completion: nil)
    }
}
