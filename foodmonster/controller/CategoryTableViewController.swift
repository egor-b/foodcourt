//
//  CathegoryTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/4/20.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var cathegory: String?
    private let searchController = UISearchController(searchResultsController: nil)
    private var tableViewViewModel: TableViewViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildInterface()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewViewModel = TableViewViewModel()
        guard let tableViewViewModel = tableViewViewModel, let cathegory = cathegory else { return }
        tableViewViewModel.getListByType(type: cathegory) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
         }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewViewModel?.numberOfRows() ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CATEGORY_CELL.rawValue, for: indexPath) as? CathegoryTableViewCell

        guard let tableViewCell = cell, let tableViewViewModel = tableViewViewModel else { return UITableViewCell() }
        let cellViewModel = tableViewViewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = tableViewViewModel else { return }
        viewModel.selectedRow(atIndexPath: indexPath)
        performSegue(withIdentifier: Segue.RECIPE_DETAIL_SEGUE.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let viewModel = tableViewViewModel else { return }
        if identifier == Segue.RECIPE_DETAIL_SEGUE.rawValue {
            if let destinationVC = segue.destination as? RecipeDetailTableViewController {
                destinationVC.recipeViewViewModel = viewModel.viewModelForSelectedRow()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = (scrollView.contentOffset.y + 192) / 52
        if offset <= 1 && offset > 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearch))
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 112/255, green: 57/255, blue: 60/255, alpha: offset)
        } else if offset <= 0 {
            navigationItem.rightBarButtonItem = nil
        }
    }

}

extension CategoryTableViewController {
    
    func buildInterface() {
        navigationItem.title = cathegory
        navigationItem.searchController = searchController
        createSearchBar()
    }
    
    func createSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find your favorite"
        definesPresentationContext = true
    }
    
    @objc func handleShowSearch () {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension CategoryTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Tapped cancel button ...")
    }

    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
}
