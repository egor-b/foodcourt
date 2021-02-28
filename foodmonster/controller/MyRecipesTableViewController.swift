//
//  MyRecipesTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/17/20.
//

import UIKit

class MyRecipesTableViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private var tableViewViewModel: TableViewViewModelProtocol?
    private let constant = Constant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(title: "My Recipes")
        tableViewViewModel = TableViewViewModel()
        tableViewViewModel?.getListByUserId(userId: "2") { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
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
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
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

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = constant.darkTitleColor
        navigationItem.title = title
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

extension MyRecipesTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Tapped cancel button ...")
    }

    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
}
