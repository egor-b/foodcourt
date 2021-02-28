//
//  RecipeDetailTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import UIKit

class RecipeDetailTableViewController: UITableViewController {

    var recipeViewViewModel: RecipeTableViewCellViewModelProtocol?
    var recipeDetailsTableViewModel: RecipeDetailsTableViewViewModelProtocol?
    
    private let navBarAppearance = UINavigationBarAppearance()
    private let constant = Constant()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarAppearance.configureWithOpaqueBackground()
        registerNibsCells()
        tableView.separatorStyle = .none
        recipeDetailsTableViewModel = RecipeDetailsTableViewViewModel(recipe: recipeViewViewModel!.recipe)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeVisabiltyNavigationBar(alpha: 1, back: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return recipeDetailsTableViewModel?.numberOfSection() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeDetailsTableViewModel?.numberOfRowsInSection(numberOfRowsInSection: section) ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let recipeDetailsTableViewModel = recipeDetailsTableViewModel else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.INFO_RECIPE_CELL.rawValue) as? InfoRecipeTableViewCell
            guard let tableViewCell = cell else { return UITableViewCell() }
            let cellViewModel = recipeDetailsTableViewModel.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.SERVE_CELL.rawValue) as? ServeTableViewCell
                guard let serveTableViewCell = cell else { return UITableViewCell() }
                return serveTableViewCell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.INGREDIENT_CELL.rawValue) as? IngredientOfRecipeTableViewCell
            guard let tableViewCell = cell else { return UITableViewCell() }
            let cellViewModel = recipeDetailsTableViewModel.ingredientCellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ABOUT_RECIPE_CELL.rawValue, for: indexPath) as? AboutRecipeTableViewCell
            guard let tableViewCell = cell else { return UITableViewCell() }
            let cellViewModel = recipeDetailsTableViewModel.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.STEP_CELL.rawValue, for: indexPath) as? StepOfRecipeTableViewCell
            guard let tableViewCell = cell else { return UITableViewCell() }
            let cellViewModel = recipeDetailsTableViewModel.stepCellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        navBarAppearance.configureWithOpaqueBackground()
        var offset = scrollView.contentOffset.y / 150
        if offset > 1 {
            offset = 1
            changeVisabiltyNavigationBar(alpha: offset)
        } else {
            changeVisabiltyNavigationBar(alpha: offset)
        }
        self.navigationItem.title = recipeViewViewModel?.recipe.name ?? ""
        
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let newIndexPath = IndexPath(row: 0, section: indexPath.section)
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 60
            }
            return 40
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension RecipeDetailTableViewController {

    func registerNibsCells() {
        tableView.register(UINib(nibName: "InfoRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.INFO_RECIPE_CELL.rawValue)
        tableView.register(UINib(nibName: "IngredientOfRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.INGREDIENT_CELL.rawValue)
        tableView.register(UINib(nibName: "AboutRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ABOUT_RECIPE_CELL.rawValue)
        tableView.register(UINib(nibName: "StepOfRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.STEP_CELL.rawValue)
        tableView.register(UINib(nibName: "ServeTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.SERVE_CELL.rawValue)
    }
    
    func changeVisabiltyNavigationBar(alpha: CGFloat, back: Bool = false) {
        navBarAppearance.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 241/255, alpha: alpha)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(red: 112/255, green: 57/255, blue: 60/255, alpha: alpha)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: constant.darkTitleColor]
        
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        
        if back == true || alpha >= 0.3 {
            navigationController?.navigationBar.tintColor = constant.darkTitleColor
        } else {
            navigationController?.navigationBar.tintColor = .white
        }

        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 112/255, green: 57/255, blue: 60/255, alpha: alpha)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
}
