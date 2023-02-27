//
//  MyRecipesTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/17/20.
//

import UIKit

class MyRecipesTableViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityView = UIActivityIndicatorView(style: .large)
    private var tableViewViewModel: CategoryTableViewViewModelProtocol?
    private let constant = Constant()
    
    private var currentPage = 0
    private var currentPageSize = "25"
    private var defaultSort = "date"
    private var defaultOrder = "DESC"
    
    var filterCriteria = FilterCriteria()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(title: "My Recipes")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget( self, action: #selector(callPullToRefresh), for: .valueChanged)
        tableViewViewModel = CategoryTableViewViewModel()
        if !globalUserId.isEmpty {
            filterCriteria.userId = globalUserId
            fillOutController()
        } else {
            showUnknownUserAlert()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if globalUserId.isEmpty {
            showUnknownUserAlert()
        }
        tableView.reloadData()
    }
    
    func fillOutController() {
        showActivityIndicatory(activityView: activityView)
        tableViewViewModel?.getListByUserId(page: String(currentPage), size: currentPageSize, sort: defaultSort, order: defaultOrder, filter: filterCriteria) { [weak self] err in
            if let err = err {
                self?.showAlert(title: "Oooops ... ", message: err.details)
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.currentPage += 1
            }
            self?.stopActivityIndicatory(activityView: self!.activityView)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewViewModel?.numberOfRows() ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.MY_RECIPE_CELL.rawValue, for: indexPath) as? MyRecipesTableViewCell
        guard let tableViewCell = cell, let tableViewViewModel = tableViewViewModel else { return UITableViewCell() }
        let cellViewModel = tableViewViewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewViewModel = tableViewViewModel else { return }
        if tableViewViewModel.listOfResipes.totalPages >= currentPage && tableViewViewModel.getRecipeList().count - 1 == indexPath.row {

            tableViewViewModel.getListByType(page: String(currentPage), size: currentPageSize, sort: defaultSort, order: defaultOrder, filter: filterCriteria) { [weak self] err in
                if let err = err {
                    self?.showAlert(title: "Ooops ... ", message: err.localizedDescription)
                }
                DispatchQueue.main.async {
                    self?.currentPage += 1
                    self?.tableView.reloadData()
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.RECIPE_DETAIL_SEGUE.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == Segue.RECIPE_DETAIL_SEGUE.rawValue {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                if let destinationVC = segue.destination as? RecipeDetailTableViewController {
                    destinationVC.recipesTableViewViewModel = tableViewViewModel
                    destinationVC.recipeIndex = selectedRow
                }
            }
        }
    }
    
}

extension MyRecipesTableViewController {
    
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
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = constant.darkTitleColor
        navigationItem.title = title
        navigationItem.searchController = searchController
        createSearchBar()
    }
    
    func createSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search my recipes"
        definesPresentationContext = true
    }
    
    @objc func handleShowSearch () {
        searchController.searchBar.becomeFirstResponder()
    }
    
    @objc func callPullToRefresh(){
        currentPage = 0
        currentPageSize = "25"
        defaultSort = "date"
        defaultOrder = "DESC"
        tableViewViewModel?.getListByUserId(page: String(currentPage), size: currentPageSize, sort: defaultSort, order: defaultOrder, filter: filterCriteria) { [weak self] err in
            if let err = err {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
                self?.showAlert(title: "Oooops ... ", message: err.details)
            } else {
                DispatchQueue.main.async {
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.tableView.reloadData()
                    self?.currentPage += 1
                }
            }
            self?.stopActivityIndicatory(activityView: self!.activityView)
        }
    }
    
}

extension MyRecipesTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterCriteria.name = ""
        currentPage = 0
        fillOutController()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, let tableViewViewModel = tableViewViewModel else { return }
        if !tableViewViewModel.getRecipeList().isEmpty {
            tableViewViewModel.setRecipeList([])
            tableView.reloadData()
        }
        if searchText.count > 2 {
            if currentPage != 0 {
                currentPage = 0
            }
            filterCriteria.name = searchText
            fillOutController()
        }
    }
    
}
