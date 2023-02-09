//
//  RecipeDetailTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import UIKit

class RecipeDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    var recipeIndex: Int?
    var recipesTableViewViewModel: CategoryTableViewViewModelProtocol?
    
    private var recipeDetailsTableViewModel: RecipeDetailsTableViewViewModelProtocol?
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?
    
    private let activityView = UIActivityIndicatorView(style: .large)
    private let navBarAppearance = UINavigationBarAppearance()
    private let constant = Constant()
    
    var recipeId = Int64()
    private var isPresent: Bool = false
    private var offset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibsCells()
        spinnerView.startAnimating()
        tableView.separatorStyle = .none
        
        firebaseStorage = FirebaseStorageServiceManager()
                                                                         
        navBarAppearance.configureWithOpaqueBackground()
        
        if recipeId == 0 {
            guard let recipesTableViewViewModel = recipesTableViewViewModel, let recipeIndex = recipeIndex else { return }
            let details = recipesTableViewViewModel.getRecipeByIndex(index: recipeIndex)
            recipeDetailsTableViewModel = RecipeDetailsTableViewViewModel(recipe: details)
            loadMainImage()
            if details.userId == globalUserId {
                self.addBarButtons("edit")
            }
        } else {
            showActivityIndicatory(activityView: activityView)
            recipeDetailsTableViewModel = RecipeDetailsTableViewViewModel()
            guard let recipeDetailsTableViewModel = recipeDetailsTableViewModel else { return }
            recipeDetailsTableViewModel.getRecipe(recipeId) { error in
                if let error = error {
                    self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
                }
                self.loadMainImage()
                if recipeDetailsTableViewModel.getRecipeValue()?.userId == globalUserId {
                    self.addBarButtons("edit")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.stopActivityIndicatory(activityView: self.activityView)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeVisabiltyNavigationBar(alpha: 1, back: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeVisabiltyNavigationBar(alpha: offset)
//        tableView.reloadSections([1], with: .automatic)
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
                serveTableViewCell.changeServeStepper.addTarget(self, action: #selector(updateValue), for: .valueChanged)
                let cellViewModel = recipeDetailsTableViewModel.cellViewModel(forIndexPath: indexPath)
                serveTableViewCell.viewModel = cellViewModel
                if recipeId != 0 {
                    serveTableViewCell.changeServeStepper.isHidden = true
                }
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
        offset = scrollView.contentOffset.y / 150
        if offset > 1 {
            offset = 1
            changeVisabiltyNavigationBar(alpha: offset)
        } else {
            changeVisabiltyNavigationBar(alpha: offset)
        }
        let recipeName = recipeDetailsTableViewModel?.getRecipeValue()
        self.navigationItem.title = recipeName?.name ?? ""
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let newIndexPath = IndexPath(row: 0, section: indexPath.section)
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            if indexPath.row == 0 {
                return 60
            }
            return 40
        default:
            return UITableView.automaticDimension
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRecipeSegue" {
            if let recipeIndex = recipeIndex, let recipesTableViewViewModel = recipesTableViewViewModel {
                let vc: NewRecipeTableViewController = segue.destination as! NewRecipeTableViewController
                let recipe = recipesTableViewViewModel.getRecipeByIndex(index: recipeIndex)
                vc.editRecipe = recipe
            }
        }
    }
    
    @IBAction func saveUpdatedRecipeUnwindSegue(_ sender: UIStoryboardSegue) {
        guard let editedRecipeController = sender.source as? NewRecipeTableViewController, let recipeIndex = recipeIndex, let recipesTableViewViewModel = recipesTableViewViewModel else { return }
        let newRecipe = editedRecipeController.newRecipeViewModel?.getRecipe()
        recipeDetailsTableViewModel = RecipeDetailsTableViewViewModel(recipe: newRecipe!)
        recipesTableViewViewModel.updateRecipeByIndex(index: recipeIndex, recipe: newRecipe)
        loadMainImage()
        tableView.reloadData()
    }
    
    deinit {
        dismiss(animated: true)
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
    
    func loadMainImage() {
        var image: [Image] = []
        guard let recipe = recipeDetailsTableViewModel?.getRecipeValue() else { return }
        if recipeId == 0 {
            image = recipe.image
        } else {
            image = recipe.image
        }
        
        if !image.isEmpty {
            firebaseStorage?.retreiveImage(image[0].pic, completion: { imageData in
                let image = UIImage(data: imageData)
                self.mainImageView.image = image
                self.spinnerView.stopAnimating()
                self.spinnerView.isHidden = true
            })
        } else {
            self.spinnerView.stopAnimating()
            self.spinnerView.isHidden = true
        }
    }
    
    @objc func updateValue(sender: UIStepper) {
        let value = Int(sender.value)
        recipeDetailsTableViewModel?.calcNewingredientWeight(portions: value, tableView: tableView)
    }
    
    func addBarButtons(_ action: String) {
        if action == "edit" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "redact"), style: .plain, target: self, action: #selector(editRecipe(sender:)))
        }
        
    }
    
    @objc func editRecipe(sender: UIBarButtonItem) {
       performSegue(withIdentifier: "editRecipeSegue", sender: nil)
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
