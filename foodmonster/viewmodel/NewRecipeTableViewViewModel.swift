//
//  NewRecipeTableViewViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/21/20.
//

import UIKit

protocol NewRecipeTableViewViewModelProtocol {
    
    var recipe: RecipeModel { get set }
    var deleteImage: [String] { get set }
    
    func numberOfRows(inSection section: Int) -> Int
    func viewForHeader(inSection section: Int, width: CGFloat, height: CGFloat) -> UIView
    
    func getIngredient(atIndexPath indexPath: IndexPath) -> FoodModel
    func getStep(atIndexPath indexPath: IndexPath) -> StepModel
    
    func addIngredient(name: String, count: Double, messure: String)
    func updateIngredient(index: Int, name: String, count: Double, messure: String)
    func addStep(desc: String, pic: Data)
    func updateStep(step: Int, desc: String, img: String, pic: Data)
    func addMainImage(pic: Data)
    func loadEditRecipe(_ editRecipe: Recipe)
    func getRecipe() -> Recipe
    
    func cellViewModel() -> NewRecipeTableViewCellViewModelProtocol?
    func cellIngredientViewModel(forIndexPath indexPath: IndexPath) -> NewIngredientTableViewCellViewModelProtocol?
    func cellStepViewModel(forIndexPath indexPath: IndexPath) -> NewStepTableViewCellViewModelProtocol?
    func save(completion: @escaping(Error?) -> ())
    func updateRecipe(completion: @escaping(Error?) -> ())
    
    func updateStepNumber()
    func changeAmountOfPortions(tableView: UITableView, serves: Int)
}

class NewRecipeTableViewViewModel: NewRecipeTableViewViewModelProtocol {
    
    private var dataNetworkManager: DataNetworkManagerProtocol?
    private var auth: AuthanticateManagerProtocol?
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?
    private let ingrSectionHeader = Bundle.main.localizedString(forKey: "ingrSectionHeader", value: LocalizationDefaultValues.INGR_SECTION_HEADER.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let directionSectionHeader = Bundle.main.localizedString(forKey: "directionSectionHeader", value: LocalizationDefaultValues.DIRECTION_SECTION_HEADER.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)

    var recipe = RecipeModel()
    var deleteImage = [String]()
    
    init() {
        dataNetworkManager = DataNetworkManager()
        auth = AuthanticateManager()
        firebaseStorage = FirebaseStorageServiceManager()
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        if section == 1 {
            return recipe.food.count + 1
        }
        if section == 2 {
            return recipe.step.count + 1
        }
        if section == 3 {
            return 1
        }
        return 0
    }
    
    func viewForHeader(inSection section: Int, width: CGFloat, height: CGFloat) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: headerView.frame.width - 50, height: headerView.frame.height * 0.8))
        if section == 1 {
            label.text = ingrSectionHeader
        }
        if section == 2 {
            label.text = directionSectionHeader
        }
        label.textColor = UIColor(named: "lightTextColorSet")
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor(named: "backgroundColorSet")
        return headerView
    }
    
    func cellViewModel() -> NewRecipeTableViewCellViewModelProtocol? {
        return NewRecipeTableViewCellViewModel(recipe: recipe)
    }
    
    
    func cellIngredientViewModel(forIndexPath indexPath: IndexPath) -> NewIngredientTableViewCellViewModelProtocol? {
        return NewIngredientTableViewCellViewModel(ingredient: recipe.food[indexPath.row])
    }
    
    func cellStepViewModel(forIndexPath indexPath: IndexPath) -> NewStepTableViewCellViewModelProtocol? {
        return NewStepTableViewCellViewModel(step: recipe.step[indexPath.row])
    }
    
    func getIngredient(atIndexPath indexPath: IndexPath) -> FoodModel {
        return recipe.food[indexPath.row]
    }
    
    func getStep(atIndexPath indexPath: IndexPath) -> StepModel {
        return recipe.step[indexPath.row]
    }
    
    func addIngredient(name: String, count: Double, messure: String) {
        var f = FoodModel()
        f.product.name = name
        f.amount = count
        f.unit = messure
        recipe.food.append(f)
    }
    
    func addStep(desc: String, pic: Data) {
        var step = StepModel()
        step.stepNumber = recipe.step.count + 1
        step.step = desc
        step.img = pic
        if !pic.isEmpty {
            let name = "stage/\(randomString()).jpeg"
            step.pic = name
        }
        recipe.step.append(step)
    }
    
    func addMainImage(pic: Data) {
        if recipe.image.count == 0 {
            var img = ImageModel()
            let name = "image/\(randomString()).jpeg"
            img.img = pic
            img.pic = name
            recipe.image.append(img)
        } else {
            let ref = recipe.image[0].pic
            imageCash.setObject(pic as AnyObject, forKey: ref as AnyObject)
            recipe.image[0].img = pic
        }
        
    }
    
    func changeAmountOfPortions(tableView: UITableView, serves: Int) {
        recipe.serve = serves
        if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? PortionsTableViewCell {
            cell.potryionsLabel.text = "\(serves)"
        }
    }
    
    func updateIngredient(index: Int, name: String, count: Double, messure: String) {
        recipe.food[index].product.name = name
        recipe.food[index].amount = count
        recipe.food[index].unit = messure
    }
    
    func updateStep(step: Int, desc: String, img: String, pic: Data) {
        recipe.step[step - 1].step = desc
        if !pic.isEmpty && !img.isEmpty {
            recipe.step[step - 1].pic = img
            recipe.step[step - 1].img = pic
        } else if pic.isEmpty && !img.isEmpty {
            recipe.step[step - 1].pic = ""
            imageCash.removeObject(forKey: img as AnyObject)
        } else if !pic.isEmpty && img.isEmpty {
            let name = "stage/\(randomString()).jpeg"
            recipe.step[step - 1].pic = name
            recipe.step[step - 1].img = pic
        } else {
            recipe.step[step - 1].pic = img
            recipe.step[step - 1].img = pic
        }
    }
    
    func save(completion: @escaping(Error?) -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        let dbr = prepareRecipeForDb()
        dataNetworkManager.saveRecipe(recipe: dbr, completion: { err in
            if let err = err {
                completion(err)
            } else {
                self.saveImages { error in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            }
        })
        
    }
    
    func updateRecipe(completion: @escaping(Error?) -> ()) {
        guard let dataNetworkManager = dataNetworkManager else { return }
        let dbr = prepareRecipeForDb()
        dataNetworkManager.updateRecipe(recipe: dbr, completion: { err in
            if let err = err {
                completion(err)
            }
            if !self.deleteImage.isEmpty {
                self.deleteImages()
            }
            self.saveImages { error in
                if let error = error {
                    completion(error)
                }
                completion(nil)
            }
        })
        
    }
    
    func saveImages(completion: @escaping (Error?) -> ()) {
        guard let firebaseStorage = firebaseStorage else { return }
        if recipe.image.count != 0 && !recipe.image[0].img.isEmpty {
            firebaseStorage.saveImage(recipe.image[0].pic, img: recipe.image[0].img, completion: { error in
                if let error = error {
                    completion(error)
                }
            })
        }
        for step in recipe.step {
            if !step.img.isEmpty {
                firebaseStorage.saveImage(step.pic, img: step.img, completion: { error in
                    if let error = error {
                        completion(error)
                    }
                })
            }
        }
        completion(nil)
    }
    
    func deleteImages() {
        guard let firebaseStorage = firebaseStorage else { return }
        for img in deleteImage {
            firebaseStorage.deleteImage(imgRef: img)
        }
        deleteImage = [String]()
    }
    
    func loadEditRecipe(_ editRecipe: Recipe) {
        var image = [ImageModel]()
        var food = [FoodModel]()
        var step = [StepModel]()
        recipe.id = editRecipe.id
        recipe.name = editRecipe.name
        recipe.type = editRecipe.type
        recipe.about = editRecipe.about
        recipe.serve = editRecipe.serve
        recipe.time = editRecipe.time
        recipe.id = editRecipe.id
        recipe.visible = editRecipe.visible
        for img in editRecipe.image {
            var el = ImageModel()
            el.id = img.id
            el.pic = img.pic
            if let imageFromCache = imageCash.object(forKey: img.pic as AnyObject) as? Data {
                el.img = imageFromCache
            }
            image.append(el)
        }
        for f in editRecipe.food {
            var el = FoodModel()
            el.id = f.id
            el.amount = f.amount
            el.product.id = f.product.id
            el.product.pic = f.product.pic
            el.product.img = f.product.img
            el.product.name = f.product.name
            el.unit = f.unit
            food.append(el)
        }
        for s in editRecipe.step {
            var el = StepModel()
            el.id = s.id
            el.step = s.step
            el.pic = s.pic
            el.stepNumber = s.stepNumber
            if let imageFromCache = imageCash.object(forKey: s.pic as AnyObject) as? Data {
                el.img = imageFromCache
            }
            step.append(el)
        }
        recipe.step = step.sorted(by: { $0.stepNumber < $1.stepNumber})
        recipe.food = food
        recipe.image = image
    }
    
    func getRecipe() -> Recipe {
        var model: Recipe = Recipe()
        
        model.name = recipe.name
        model.type = recipe.type
        model.about = recipe.about
        model.serve = recipe.serve
        model.time = recipe.time
        model.id = recipe.id
        
        for f in recipe.food {
            var fd = Food()
            fd.amount = f.amount
            fd.id = f.id
            fd.product.id = f.product.id
            if !f.product.pic.isEmpty {
                fd.product.pic = f.product.pic
            }
            if !f.product.img.isEmpty {
                fd.product.img = f.product.img
            }
            if !f.product.name.isEmpty {
                fd.product.name = f.product.name
            }
            fd.unit = f.unit
            model.food.append(fd)
        }
        for s in recipe.step {
            var st = Step()
            st.id = s.id
            st.step = s.step
            st.img = s.img
            st.pic = s.pic
            st.stepNumber = s.stepNumber
            model.step.append(st)
        }
        for img in recipe.image {
            var im = Image()
            im.id = img.id
            im.pic = img.pic
            im.img = img.img
            model.image.append(im)
        }
        
        return model
    }
    
    func updateStepNumber() {
        if recipe.step.count != 0 {
            for index in 0...recipe.step.count-1 {
                recipe.step[index].stepNumber = index + 1
            }
        }
    }
    
    func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< 20 {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    func prepareRecipeForDb() -> RecipeModel {
        var rm = recipe
        
        for (i, _) in rm.step.enumerated() {
            rm.step[i].img = Data()
        }
        for (i, _) in rm.image.enumerated() {
            rm.image[i].img = Data()
        }
        for (i, _) in rm.food.enumerated() {
            rm.food[i].product.img = Data()
        }
        
        return rm
    }
    
}
