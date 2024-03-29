//
//  NewRecipeTableViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/21/20.
//

import UIKit
import Photos

class NewRecipeTableViewController: UITableViewController {
    
    var newRecipeViewModel: NewRecipeTableViewViewModelProtocol?
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?
    private var auth: AuthanticateManagerProtocol?
    private let picker = UIPickerView()
    private var toolBar = UIToolbar()
    private let pickerController = UIImagePickerController()
    private let activityView = UIActivityIndicatorView(style: .large)
    
    private let alertTitle =  Bundle.main.localizedString(forKey: "ops", value: LocalizationDefaultValues.OPS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let newRecipeTitle = Bundle.main.localizedString(forKey: "newRecipe", value: LocalizationDefaultValues.NEW_RECIPE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let editRecipeTitle = Bundle.main.localizedString(forKey: "editRecipe", value: LocalizationDefaultValues.EDIT_RECIPE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let verificationTitle = Bundle.main.localizedString(forKey: "verificationError", value: LocalizationDefaultValues.VERIFICATION_ERROR.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let verificationMessage = Bundle.main.localizedString(forKey: "verificationMessageError", value: LocalizationDefaultValues.VERIFICATION_ERROR_MESSAGE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let reSendTitle = Bundle.main.localizedString(forKey: "reSend", value: LocalizationDefaultValues.RESEND.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let cancelTitle = Bundle.main.localizedString(forKey: "cancel", value: LocalizationDefaultValues.CANCEL.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let toManyRequestsTitle = Bundle.main.localizedString(forKey: "toManyRequests", value: LocalizationDefaultValues.TOO_MANY_REQUESTS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    private let successTitle = Bundle.main.localizedString(forKey: "success", value: LocalizationDefaultValues.SUCCESS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let recipeUpdateMessage = Bundle.main.localizedString(forKey: "recipeUpdate", value: LocalizationDefaultValues.RECIPE_UPDATE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let sweet = Bundle.main.localizedString(forKey: "sweet", value: "Sweet", table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let alertNewRecipeMessage = Bundle.main.localizedString(forKey: "alertNewRecipeMessage", value: LocalizationDefaultValues.ALERT_NEW_RECIPE_MESSAGE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let toLowIngrStepsTitle = Bundle.main.localizedString(forKey: "toLowIngrStepsTitle", value: LocalizationDefaultValues.TOO_LOW_INGR_STEPS_TITLE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let toLowIngrStepsMessage = Bundle.main.localizedString(forKey: "toLowIngrStepsMessage", value: LocalizationDefaultValues.TOO_LOW_INGR_STEPS_MESSAGE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let saveAnyway = Bundle.main.localizedString(forKey: "saveAnyway", value: LocalizationDefaultValues.SAVE_ANYWAY.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    private let recipeSaved = Bundle.main.localizedString(forKey: "recipeSaved", value: LocalizationDefaultValues.RECIPE_SAVED.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    var editRecipe: Recipe?
    
    @IBOutlet weak var addPicImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self
        registerTableViewElements()
        setTapGuestureRecognize()
        configureNavigationBar(title: newRecipeTitle)
        newRecipeViewModel = NewRecipeTableViewViewModel()
        auth = AuthanticateManager()
        firebaseStorage = FirebaseStorageServiceManager()
        if let editRecipe = editRecipe {
            configureNavigationBar(title: editRecipeTitle)
            newRecipeViewModel?.loadEditRecipe(editRecipe)
            newRecipeViewModel?.recipe.type = editRecipe.type
            if !editRecipe.image.isEmpty {
                firebaseStorage?.retreiveImage(editRecipe.image[0].pic, completion: { img in
                    self.addPicImageView.image = UIImage(data: img)
                })
            }
            
        }
        setTableFooter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if globalUserId.isEmpty {
            showNewRecipeUnknownUserAlert()
        }
        let isEmailVerified = UserDefaults.standard.object(forKey: "isEmailVerified") as? Bool ?? false
        if !isEmailVerified {
            if let auth = auth {
                if !auth.checkEmailVerification() {
                    self.customAlertWithHandler(title: verificationTitle, message: verificationMessage, submitTitle: reSendTitle, declineTitle: cancelTitle) {
                        auth.sendEmailVerification(completion: { error in
                            if let error = error {
                                self.customAlertHandlerOkButton(title: self.toManyRequestsTitle, message: error.localizedDescription, submitTitle: "Ok") {
                                    self.dismiss(animated: true)
                                }
                            } else {
                                self.dismiss(animated: true)
                            }
                        })
                    } declineHandler: {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
        
    }
    
    func setTableFooter() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        view.backgroundColor = UIColor(named: "backgroundColorSet")
        self.tableView.tableFooterView = view
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if globalUserId.isEmpty {
            return 3
        } else {
            return 4
        }
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
                let cellViewModel = newRecipeViewModel?.cellViewModel()
                recipeNameCell.viewModel = cellViewModel
                return recipeNameCell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.RECIPE_CATEGORY_CELL.rawValue, for: indexPath) as? RecipeCategoryTableViewCell
                guard let recipeCategoryCell = cell else { return UITableViewCell() }
                recipeCategoryCell.cathegoryLabel.text = newRecipeViewModel?.recipe.type
                return recipeCategoryCell
            }
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.COOK_TIME_CELL.rawValue, for: indexPath) as? CookTimeTableViewCell
                guard let cookTimeCell = cell else { return UITableViewCell() }
                let cellViewModel = newRecipeViewModel?.cellViewModel()
                cookTimeCell.viewModel = cellViewModel
                return cookTimeCell
            }
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.PORTIONS_CELL.rawValue, for: indexPath) as? PortionsTableViewCell
                guard let portionsCell = cell else { return UITableViewCell() }
                portionsCell.portionsStepper.addTarget(self, action: #selector(changePortionAmount), for: .valueChanged)
                portionsCell.viewModel = newRecipeViewModel?.cellViewModel()
                return portionsCell
            }
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ABOUT_NEW_RECIPE_CELL.rawValue, for: indexPath) as? AboutNewRecipeTableViewCell
                guard let aboutCell = cell else { return UITableViewCell() }
                let cellViewModel = newRecipeViewModel?.cellViewModel()
                aboutCell.viewModel = cellViewModel
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
            let cellViewModel = newRecipeViewModel?.cellIngredientViewModel(forIndexPath: indexPath)
            newIngredientCell.viewModel = cellViewModel
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
            let cellViewModel = newRecipeViewModel?.cellStepViewModel(forIndexPath: indexPath)
            cookStepCell.viewModel = cellViewModel
            return cookStepCell
        }
        if !globalUserId.isEmpty {
            if indexPath.section == 3 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Cells.SAVE_RECIPE_CELL.rawValue, for: indexPath) as? SaveRecipeTableViewCell
                    guard let saveRecipeCell = cell else { return UITableViewCell() }
                    saveRecipeCell.separatorInset = UIEdgeInsets(top: 0, left: view.frame.maxY, bottom: 0, right: 0)
                    return saveRecipeCell
                }
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            return newRecipeViewModel?.viewForHeader(inSection: section, width: tableView.bounds.size.width, height: 30)
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 {
            return 30
        }
        if section == 3 {
            return 5
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 4 {
                return UITableView.automaticDimension
            } else {
                return 45
            }
        case 3:
            return 80
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDoneButtonTapped()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: Segue.MODIFICATION_SEGUE.rawValue, sender: nil)
            }
            if indexPath.row == 1 {
                setPicker()
            }
            if indexPath.row == 2 {
                performSegue(withIdentifier: Segue.MODIFICATION_SEGUE.rawValue, sender: nil)
            }
            if indexPath.row == 4 {
                performSegue(withIdentifier: Segue.ABOUT_NEW_SEGUE.rawValue, sender: nil)
            }
        }
        if indexPath.section == 1 {
            performSegue(withIdentifier: Segue.ADD_INGREDIENT_SEGUE.rawValue, sender: nil)
        }
        if indexPath.section == 2 {
            performSegue(withIdentifier: Segue.ADD_STEP_SEGUE.rawValue, sender: nil)
        }
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                
                guard let newRecipeViewModel = newRecipeViewModel else { return }
                if editRecipe != nil {
                    newRecipeViewModel.updateRecipe() { [self] error in
                        if let error = error {
                            self.showAlert(title: alertTitle, message: error.localizedDescription)
                            return
                        } else {
                            self.customAlertHandlerOkButton(title: successTitle, message: recipeUpdateMessage, submitTitle: sweet) {
                                self.performSegue(withIdentifier: "saveUpdatedRecipeUnwindSegue", sender: self)
                            }
                        }
                    }
                } else {
                    if newRecipeViewModel.recipe.type.isEmpty || newRecipeViewModel.recipe.name.isEmpty {
                        showAlert(title: alertTitle, message: alertNewRecipeMessage)
                    } else {
                        if newRecipeViewModel.recipe.food.isEmpty || newRecipeViewModel.recipe.step.isEmpty || newRecipeViewModel.recipe.name.isEmpty {
                            self.customAlertWithHandler(title: toLowIngrStepsTitle,
                                                        message: toLowIngrStepsMessage,
                                                        submitTitle: saveAnyway,
                                                        declineTitle: cancelTitle) {
                                finalyzing()
                            } declineHandler: { }
                        } else {
                            finalyzing()
                        }
                    }
                }
                func finalyzing() {
                    newRecipeViewModel.save() { [self] error in
                        if let error = error {
                            self.showAlert(title: self.alertTitle, message: error.localizedDescription)
                        } else {
                            self.customAlertHandlerOkButton(title: successTitle, message: recipeSaved, submitTitle: sweet) {
                                self.dismiss(animated: true)
                            }
                        }
                    }
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            cell.backgroundColor = UIColor(named: "backgroundColorSet")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if var newRecipeViewModel = newRecipeViewModel {
            if indexPath.section == 1 && newRecipeViewModel.recipe.food.count != 0 {
                if editingStyle == .delete {
                    newRecipeViewModel.recipe.food.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            if indexPath.section == 2 && newRecipeViewModel.recipe.step.count != 0 {
                if editingStyle == .delete {
                    newRecipeViewModel.recipe.step.remove(at: indexPath.row)
                    newRecipeViewModel.updateStepNumber()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let newRecipeViewModel = newRecipeViewModel {
            
            if indexPath.section == 1 {
                if newRecipeViewModel.recipe.food.count != 0 && indexPath.row <= newRecipeViewModel.recipe.food.count {
                    return true
                }
            }
            
            if indexPath.section == 2 {
                if newRecipeViewModel.recipe.step.count != 0 && indexPath.row <= newRecipeViewModel.recipe.step.count {
                    return true
                }
            }
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let newRecipeViewModel = newRecipeViewModel,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if identifier == Segue.MODIFICATION_SEGUE.rawValue {
                    if let destinationVC = segue.destination as? NameTimeViewController {
                        destinationVC.modType = "Recipe name"
                        if newRecipeViewModel.recipe.name.count > 3 {
                            destinationVC.text = newRecipeViewModel.recipe.name
                        }
                    }
                }
            }
            if indexPath.row == 2 {
                if identifier == Segue.MODIFICATION_SEGUE.rawValue {
                    if let destinationVC = segue.destination as? NameTimeViewController {
                        destinationVC.modType = "Cook time"
                        if newRecipeViewModel.recipe.time > 0 {
                            destinationVC.text = String(newRecipeViewModel.recipe.time)
                        }
                    }
                }
            }
            if indexPath.row == 4 {
                if identifier == Segue.ABOUT_NEW_SEGUE.rawValue {
                    if let destinationVC = segue.destination as? AboutNewRecipeViewController {
                        if newRecipeViewModel.recipe.about.count > 5 {
                            destinationVC.text = newRecipeViewModel.recipe.about
                        }
                    }
                }
            }
        }
        if indexPath.section == 1 {
            if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
                if identifier == Segue.ADD_INGREDIENT_SEGUE.rawValue {
                    if let destinationVC = segue.destination as? NewIngredientViewController {
                        destinationVC.ingredient = newRecipeViewModel.getIngredient(atIndexPath: indexPath)
                        destinationVC.index = indexPath.row
                    }
                }
            }
        }
        if indexPath.section == 2 {
            if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
                if identifier == Segue.ADD_STEP_SEGUE.rawValue {
                    if let destinationVC = segue.destination as? NewStepViewController {
                        destinationVC.step = newRecipeViewModel.getStep(atIndexPath: indexPath)
                        destinationVC.newRecipeViewModelProtocol = newRecipeViewModel
                    }
                }
            }
        }
    }
    
    @IBAction func dismissControllerBarButtonPressed(_ sender: Any) {
        dismiss(animated: true)
        newRecipeViewModel?.deleteImage = [String]()
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
        tableView.register(UINib(nibName: "AboutNewTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ABOUT_NEW_RECIPE_CELL.rawValue)
        tableView.register(UINib(nibName: "PortionsTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.PORTIONS_CELL.rawValue)
        tableView.register(UINib(nibName: "SaveRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.SAVE_RECIPE_CELL.rawValue)
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
    
    @IBAction func saveAboutUnwindSegue(_ sender: UIStoryboardSegue) {
        guard let aboutController = sender.source as? AboutNewRecipeViewController else { return }
        newRecipeViewModel?.recipe.about = aboutController.itemTextFiled.text ?? "EMPTY"
        tableView.reloadData()
    }
    
    @IBAction func saveModUnwindSegue(_ sender: UIStoryboardSegue) {
        guard let modController = sender.source as? NameTimeViewController else { return }
        if modController.modType == "Recipe name" {
            newRecipeViewModel?.recipe.name = modController.nameTimeTextField.text ?? "NO NAME"
        }
        if modController.modType == "Cook time" {
            newRecipeViewModel?.recipe.time = Int(modController.nameTimeTextField.text ?? "0") ?? 0
        }
        tableView.reloadData()
    }
    
    @IBAction func saveIngredientUnwindSegue(_ sender: UIStoryboardSegue) {
        guard let foodController = sender.source as? NewIngredientViewController else { return }
        let name = foodController.ingredientTextField.text ?? "none"
        let count = Double(foodController.weightTextField.text!) ?? 0.0
        let messuer = foodController.measureTextField.text ?? "gr."
        if (foodController.index == nil) {
            newRecipeViewModel?.addIngredient(name: name, count: count, messure: messuer)
        } else {
            let index = foodController.index
            newRecipeViewModel?.updateIngredient(index: index!, name: name, count: count, messure: messuer)
        }
        tableView.reloadData()
    }
    
    @IBAction func saveStageUnwindSegue(_ sender: UIStoryboardSegue) {
        guard let stepController = sender.source as? NewStepViewController else { return }
        let desc = stepController.stepDescriptionTextView.text ?? ""
        let img = stepController.step.img
        let ref = stepController.step.pic
        if stepController.step.stepNumber == 0 { 
            newRecipeViewModel?.addStep(desc: desc, pic: img)
        } else {
            let step = stepController.step.stepNumber
            self.newRecipeViewModel?.updateStep(step: step, desc: desc, img: ref, pic: img)
        }
        tableView.reloadData()
    }
    
    @objc func changePortionAmount(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        newRecipeViewModel?.changeAmountOfPortions(tableView: tableView, serves: stepperValue)
    }
    
}

extension NewRecipeTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setPicker() {
        picker.delegate = self
        picker.dataSource = self

        picker.backgroundColor = UIColor(named: "lightBackgroundColorSet")?.withAlphaComponent(0.95)
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 20, y: self.view.bounds.size.height - 360, width: self.view.bounds.size.width - 40, height: 250)
        picker.layer.cornerRadius = 10
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 29, y: self.view.bounds.size.height - 360, width: self.view.bounds.size.width - 58, height: 40))
        toolBar.barTintColor = UIColor(named: "lightBackgroundColorSet")
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
        done.tintColor = UIColor(named: "pressedButtonColorSet")
        toolBar.items = [spacer, done]
        
        dismissPickerGestureRecognizer()
        newRecipeViewModel?.recipe.type = MainMenu.appetizer.rawValue
//        navigationController?.navigationBar.addSubview(picker)
//        navigationController?.navigationBar.addSubview(toolBar)

        view.addSubview(picker)
        view.addSubview(toolBar)

        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func dismissPickerGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(onDoneButtonTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MainMenu.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MainMenu.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = MainMenu.allCases[row].rawValue
        newRecipeViewModel?.recipe.type = value
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension NewRecipeTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setTapGuestureRecognize() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        addPicImageView.isUserInteractionEnabled = true
        addPicImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        presentAlertController()
    }
    
    func presentAlertController() {
        
        let camTtitle = Bundle.main.localizedString(forKey: "takePhoto", value: LocalizationDefaultValues.TAKE_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let alertTitle = Bundle.main.localizedString(forKey: "missCamera", value: LocalizationDefaultValues.MISS_CAMERA.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let alertMessage = Bundle.main.localizedString(forKey: "cameraPhoto", value: LocalizationDefaultValues.CAMERA_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let photoLibTitle = Bundle.main.localizedString(forKey: "chooseFromLib", value: LocalizationDefaultValues.CHOOSE_FROM_LIB.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let removePhotoTitle = Bundle.main.localizedString(forKey: "removePhoto", value: LocalizationDefaultValues.REMOVE_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        
        let noPermission = Bundle.main.localizedString(forKey: "noPermission", value: LocalizationDefaultValues.NO_PERMISSION.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let moveToSettings = Bundle.main.localizedString(forKey: "moveToSettings", value: LocalizationDefaultValues.MOVE_TO_SETTINGS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let go = Bundle.main.localizedString(forKey: "go", value: LocalizationDefaultValues.GO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: camTtitle, style: .default, handler: { [self] (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            } else {
                self.showAlert(withTitle: alertTitle, andMessage: alertMessage)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: photoLibTitle, style: .default, handler: { [self] (action:UIAlertAction) in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { s in
                    if s == .authorized {
                        DispatchQueue.main.async {
                            self.pickerController.sourceType = .photoLibrary
                            self.present(self.pickerController, animated: true, completion: nil)
                        }
                    }
                }
            case .authorized:
                self.pickerController.sourceType = .photoLibrary
                self.present(self.pickerController, animated: true, completion: nil)
            default:
                let alertController = UIAlertController (title: noPermission, message: moveToSettings, preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: go, style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        if addPicImageView.image != nil {
            actionSheet.addAction(UIAlertAction(title: removePhotoTitle, style: .destructive, handler: { [self](_ action: UIAlertAction) -> Void in
                self.addPicImageView.image = nil
                if let newRecipeViewModel = self.newRecipeViewModel {
                    self.newRecipeViewModel?.deleteImage.append(newRecipeViewModel.recipe.image[0].pic)
                    self.newRecipeViewModel?.recipe.image.remove(at: 0)
                }
            }))
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            addPicImageView.image = image
            guard let data = image.jpegData(compressionQuality: 0.1) else { return }
            newRecipeViewModel?.addMainImage(pic: data)
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}
