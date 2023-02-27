//
//  CathegoryTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/4/20.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var categoryTableViewViewModel: CategoryTableViewViewModelProtocol?
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    var filterCriteria = FilterCriteria()
        
    private var currentPage = 0
    private var currentPageSize = "25"
    private var defaultSort = "date"
    private var defaultOrder = "DESC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCriteria.isVisible = "true"
        if !globalUserId.isEmpty {
            filterCriteria.userId = globalUserId
        }
        filterCriteria.userId = globalUserId
        showActivityIndicatory(activityView: activityView)
        buildInterface()
        categoryTableViewViewModel = CategoryTableViewViewModel()
        fillOutCOntroller()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func fillOutCOntroller() {
        guard let tableViewViewModel = categoryTableViewViewModel else { return }
        tableViewViewModel.getListByType(page: String(currentPage), size: currentPageSize, sort: defaultSort, order: defaultOrder, filter: filterCriteria) { [weak self] (error) in
            if let error = error {
                self?.stopActivityIndicatory(activityView: self!.activityView)
                self?.showAlert(title: "Oooops ... ", message: error.details)
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.currentPage += 1
            }
            self?.stopActivityIndicatory(activityView: self!.activityView)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryTableViewViewModel?.numberOfRows() ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CATEGORY_CELL.rawValue, for: indexPath) as? CathegoryTableViewCell, let tableViewViewModel = categoryTableViewViewModel else { return UITableViewCell() }
        let cellViewModel = tableViewViewModel.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = categoryTableViewViewModel else { return }
        viewModel.selectedRow(atIndexPath: indexPath)
        performSegue(withIdentifier: Segue.RECIPE_DETAIL_SEGUE.rawValue, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let categoryTableViewViewModel = categoryTableViewViewModel else { return }
        if categoryTableViewViewModel.listOfResipes.totalPages >= currentPage && categoryTableViewViewModel.getRecipeList().count - 1 == indexPath.row {
            categoryTableViewViewModel.getListByType(page: String(currentPage), size: currentPageSize, sort: defaultSort, order: defaultOrder, filter: filterCriteria) { [weak self] err in
                if let err = err {
                    self?.showAlert(title: "Oooops ... ", message: err.localizedDescription)
                }
                DispatchQueue.main.async {
                    self?.currentPage += 1
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == Segue.RECIPE_DETAIL_SEGUE.rawValue {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                if let destinationVC = segue.destination as? RecipeDetailTableViewController {
                    destinationVC.recipesTableViewViewModel = categoryTableViewViewModel
                    destinationVC.recipeIndex = selectedRow
                }
            }
        }
    }

}

extension CategoryTableViewController {
    
    func buildInterface() {
        navigationItem.title = filterCriteria.type
        navigationItem.searchController = searchController
        createSearchBar()
    }
    
    func createSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type name and search recipe"
        definesPresentationContext = true
    }
    
    @objc func handleShowSearch () {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension CategoryTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterCriteria.name = ""
        currentPage = 0
        fillOutCOntroller()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, let categoryTableViewViewModel = categoryTableViewViewModel else { return }
        if !categoryTableViewViewModel.getRecipeList().isEmpty {
            categoryTableViewViewModel.setRecipeList([])
            tableView.reloadData()
        }
        if searchText.count > 2 {
            if currentPage != 0 {
                currentPage = 0
            }
            filterCriteria.name = searchText
            fillOutCOntroller()
        }
    }
    
}
