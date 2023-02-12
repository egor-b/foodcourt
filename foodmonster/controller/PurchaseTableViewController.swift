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
    
    private let activityView = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseViewModel = PurchaseTableViewViewModel()
        configureNavigationBar(title: "Purchase")
        tableView.register(UINib(nibName: "PurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.PURCHASE_CELL.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Cells.CUSTOM_PURCHASE_CELL.rawValue)
        tableView.register(UINib(nibName: "HeaderPurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.HEADER_DISH_PURCHASE_CELL.rawValue)
        tableView.register(UINib(nibName: "AddCustomPurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ADD_CUSTOM_PURCHASE_CELL.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let purchaseViewModel = purchaseViewModel else { return }
        if !globalUserId.isEmpty {
            showActivityIndicatory(activityView: activityView)
            purchaseViewModel.getPurchaseList() { error in
                if let error = error {
                    self.stopActivityIndicatory(activityView: self.activityView)
                    self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.stopActivityIndicatory(activityView: self.activityView)
                }
                
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return purchaseViewModel?.numberOfSection() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseViewModel?.numberOfRows(inSection: section) ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let purchaseViewModel = purchaseViewModel else { return UITableViewCell() }
        if indexPath.section == 0 {
            tableView.allowsSelection = true
            if tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ADD_CUSTOM_PURCHASE_CELL.rawValue, for: indexPath)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CUSTOM_PURCHASE_CELL.rawValue, for: indexPath)
            cell.textLabel?.text = purchaseViewModel.cellCustomPurchaseViewModel(forIndexPath: indexPath)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let purchaseViewModel = purchaseViewModel else { return }
        if indexPath.section == 0 {
            if indexPath.row == purchaseViewModel.getPersonalPurchase().count {
                performSegue(withIdentifier: Segue.ADD_NEW_PERSONAL_PURCHASE.rawValue, sender: nil)
            } else {
                purchaseViewModel.removePersonalItem(forIndex: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
        
        if indexPath.section > 0 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: Segue.SHOW_RECIPE_SEGUE.rawValue, sender: nil)
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! FoodPurchaseTableViewCell
                let viewModel = purchaseViewModel.cellPurchaseViewModel(forIndexPath: indexPath)
                cell.addedToCart(model: viewModel) { error in
                    if let error = error {
                        self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
                    }
                    purchaseViewModel.updateCartPurchase(forIndexPath: indexPath)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    //MARK: Rightdwipe for delete recipe purchases
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            if indexPath.row == 0 {
                if editingStyle == .delete {
                    guard let purchaseViewModel = purchaseViewModel else { return }
                    purchaseViewModel.delteRecipePurchase(forSection: indexPath.section) { error in
                        if let error = error {
                            self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
                        } else {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        if indexPath.row == 0 {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let purchaseViewModel = purchaseViewModel,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        
        if identifier == Segue.SHOW_RECIPE_SEGUE.rawValue {
            if let destinationVC = segue.destination as? RecipeDetailTableViewController {
                destinationVC.navigationItem.title = purchaseViewModel.getPurchase()[indexPath.section - 1].recipeName
                destinationVC.recipeId = purchaseViewModel.getPurchase()[indexPath.section - 1].recipeId
            }
        }
    }
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
    
    @IBAction func unwindAddPersonalPurchase(_ sender: UIStoryboardSegue) {
        guard let purchaseViewModel = purchaseViewModel,
              let personalItemController = sender.source as? NewPersonalItemViewController else { return }
        let item = personalItemController.newItemTextField.text ?? ""
        if !item.isEmpty {
            purchaseViewModel.addPersonalItem(item: item)
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
}
