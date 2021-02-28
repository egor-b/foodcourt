//
//  NewRecipeTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/21/20.
//

import UIKit

class NewRecipeTableViewController: UITableViewController {
    
    private var newRecipeViewModel: NewRecipeTableViewViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewElements()
        configureNavigationBar(title: "New ricepe")
        newRecipeViewModel = NewRecipeTableViewViewModel()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newRecipeViewModel?.numberOfRows(inSection: section) ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.RECIPE_NAME_CELL.rawValue, for: indexPath) as? RecipeNameTableViewCell
                guard let recipeNameCell = cell else { return UITableViewCell() }
                return recipeNameCell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.RECIPE_CATEGORY_CELL.rawValue, for: indexPath) as? RecipeCategoryTableViewCell
                guard let recipeCategoryCell = cell else { return UITableViewCell() }
                return recipeCategoryCell
            }
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.COOK_TIME_CELL.rawValue, for: indexPath) as? CookTimeTableViewCell
                guard let cookTimeCell = cell else { return UITableViewCell() }

                return cookTimeCell
            }
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.COOK_TIME_CELL.rawValue, for: indexPath) as? CookTimeTableViewCell
                guard let aboutCell = cell else { return UITableViewCell() }

                return aboutCell
            }
        }
        if indexPath.section == 1 {
            if tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ADD_ITEM_CELL.rawValue, for: indexPath) as? AddItemTableViewCell
                guard let addItemCell = cell else { return UITableViewCell() }
                return addItemCell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.NEW_INGREFIENT_CELL.rawValue, for: indexPath) as? NewIngredientTableViewCell
            guard let newIngredientCell = cell else { return UITableViewCell() }

            return newIngredientCell
        }
        if indexPath.section == 2 {
            if tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ADD_ITEM_CELL.rawValue, for: indexPath) as? AddItemTableViewCell
                guard let addItemCell = cell else { return UITableViewCell() }
                return addItemCell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.COOK_STEP_CELL.rawValue, for: indexPath) as? CookStepTableViewCell
            guard let cookStepCell = cell else { return UITableViewCell() }
            return cookStepCell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            return newRecipeViewModel?.viewForHeader(inSection: section, width: tableView.bounds.size.width, height: 60)
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 60
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: Segue.ADD_INGREDIENT_SEGUE.rawValue, sender: nil)
        }
        if indexPath.section == 2 {
            performSegue(withIdentifier: Segue.ADD_STEP_SEGUE.rawValue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let newRecipeViewModel = newRecipeViewModel,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        
        if indexPath.section == 1 {
            if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
                if identifier == Segue.ADD_INGREDIENT_SEGUE.rawValue {
                    if let destinationVC = segue.destination as? NewIngredientViewController {
                        destinationVC.ingredient = newRecipeViewModel.getIngredient(atIndexPath: indexPath)
                    }
                }
            }
        }
        if indexPath.section == 2 {
            if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
                if identifier == Segue.ADD_STEP_SEGUE.rawValue {
                    if let destinationVC = segue.destination as? NewStepViewController {
                        destinationVC.step = newRecipeViewModel.getStep(atIndexPath: indexPath)
                    }
                }
            }
        }
    }
}

extension NewRecipeTableViewController {
    
    func registerTableViewElements() {
        tableView.register(UINib(nibName: "RecipeNameTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.RECIPE_NAME_CELL.rawValue)
        tableView.register(UINib(nibName: "RecipeCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.RECIPE_CATEGORY_CELL.rawValue)
        tableView.register(UINib(nibName: "CookTimeTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.COOK_TIME_CELL.rawValue)
        tableView.register(UINib(nibName: "NewIngredientTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.NEW_INGREFIENT_CELL.rawValue)
        tableView.register(UINib(nibName: "AddItemTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ADD_ITEM_CELL.rawValue)
        tableView.register(UINib(nibName: "CookStepTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.COOK_STEP_CELL.rawValue)
    }
    
    func configureNavigationBar(title: String) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "darkTextColorSet")!]
        navBarAppearance.backgroundColor = UIColor(named: "backgroundColorSet")
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor(named: "darkTextColorSet")
        navigationItem.title = title
        tableView.tableFooterView = UIView()
    }
    
    
    
    @IBAction func saveIngredientUnwindSegue(_ sender: UIStoryboardSegue) {
        guard let food = sender.source as? NewIngredientViewController else { return }
        print(food.ingredientTextField.text ?? "")
        print(food.weightTextField.text ?? "")
        print(food.measureTextField.text ?? "")
    }
    
    @IBAction func saveStageUnwindSegue(_ sender: UIStoryboardSegue) {
        guard let step = sender.source as? NewStepViewController else { return }
        print(step.stepDescriptionTextView.text ?? "")
//        print(food.weightTextField.text ?? "")
//        print(food.measureTextField.text ?? "")
    }
    
}
