//
//  PurchaseTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/18/20.
//

import UIKit

class PurchaseTableViewController: UITableViewController {
    
    private let constant = Constant()
    private var purchaseViewModel: PurchaseTableViewViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseViewModel = PurchaseTableViewViewModel()
        configureNavigationBar(title: "Purchase")
        tableView.register(UINib(nibName: "PurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.PURCHASE_CELL.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Cells.CUSTOM_PURCHASE_CELL.rawValue)
        tableView.register(UINib(nibName: "HeaderPurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.HEADER_DISH_PURCHASE_CELL.rawValue)
        tableView.register(UINib(nibName: "AddCustomPurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ADD_CUSTOM_PURCHASE_CELL.rawValue)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return purchaseViewModel?.numberOfSection() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return purchaseViewModel?.numberOfRows(inSection: section) ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let purchaseViewModel = purchaseViewModel else { return UITableViewCell() }
        if indexPath.section == 0 {
            if tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ADD_CUSTOM_PURCHASE_CELL.rawValue, for: indexPath)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CUSTOM_PURCHASE_CELL.rawValue, for: indexPath)
            cell.textLabel?.text = purchaseViewModel.cellCustomPurchaseViewModel(forIndexPath: indexPath)
            cell.isUserInteractionEnabled = false
            return cell
            
        } else {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.HEADER_DISH_PURCHASE_CELL.rawValue, for: indexPath) as? HeaderPurchaseTableViewCell
                guard let headerPurchaseViewCell = cell else { return UITableViewCell() }
                let viewModel = purchaseViewModel.getHeaderForDishPurchaseList(forIndexPath: indexPath)
                headerPurchaseViewCell.viewModel = viewModel
                return headerPurchaseViewCell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.PURCHASE_CELL.rawValue, for: indexPath) as? FoodPurchaseTableViewCell
            guard let purchaseCell = cell else { return UITableViewCell() }
            purchaseCell.isUserInteractionEnabled = false
            let viewModel = purchaseViewModel.cellPurchaseViewModel(forIndexPath: indexPath)
            purchaseCell.viewModel = viewModel
            return purchaseCell
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return purchaseViewModel?.viewForHeader(inSection: section, width: tableView.bounds.size.width, height: 40)
        } else {
            return purchaseViewModel?.viewForHeader(inSection: section, width: tableView.bounds.size.width, height: 20)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PurchaseTableViewController {
    func configureNavigationBar(title: String) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: constant.darkTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: constant.darkTitleColor]
        navBarAppearance.backgroundColor = constant.backgoundColor
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = constant.darkTitleColor
        navigationItem.title = title
        tableView.tableFooterView = UIView()
    }
}
