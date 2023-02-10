//
//  DataNetworkManager.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/9/20.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DataNetworkManagerProtocol {
    
    func getRecipes(page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping ([Recipe]?, RecipeError?) -> ())
    func getRecipeByRecipeId(id: Int64, completion: @escaping (Recipe?, Error?) -> ())
    func getRecipesByUser(userId: String, page: String, size: String, sort: String, order: String, filter: FilterCriteria, completion: @escaping ([Recipe]?, RecipeError?) -> ())
    
    func saveRecipe(recipe: RecipeModel, completion: @escaping (Error?) -> ())
    func updateRecipe(recipe: RecipeModel, completion: @escaping (Error?) -> ())
    
    func addPurchase(_ purchase: PurchaseModel, completion: @escaping (Error?) -> ())
    func retreivePurchaseList(completion: @escaping  ([Purchase]?, Error?) -> ())
    func retreivePurchase(_ foodId: Int64, _ recipeId: Int64, completion: @escaping (PurchaseModel?, Error?) -> ())
    func deletePurchase(_ purchase: PurchaseModel, completion: @escaping (Error?) -> ())
    func deleteCartRecipePurchase(_ recipeId: Int64, completion: @escaping (Error?) -> ())
    func updatePurchaseInCart(_ purchaseId: Int64, isAdd: Bool, completion: @escaping (Error?) -> ())
    
    func getHeader(completion: (HTTPHeaders) -> ())
    
}

class DataNetworkManager: DataNetworkManagerProtocol {
    
    private var authanticateManager: AuthanticateManagerProtocol?
    
    init() {
        authanticateManager = AuthanticateManager()
    }
    
    
    func getRecipes(page: String = "0", size: String = "20", sort: String = "date", order: String = "ASC", filter: FilterCriteria, completion: @escaping ([Recipe]?, RecipeError?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/recipe/search?page=\(page)&page_size=\(size)&sort_field=\(sort)&order=\(order)",
                       method: .post, parameters: filter, encoder: JSONParameterEncoder.default, headers: header).validate().responseDecodable(of: [Recipe].self) { response in
                switch response.result {
                case .success(let succcess):
                    completion(succcess, nil)
                case .failure(let error):
                    var err = RecipeError()
                    do {
                        if let data = response.data {
                            let responseJSON = try JSON(data: data)
                            let message = responseJSON["details"].stringValue
                            err.details = message
                        }
                    } catch {}
                    print("Alamofire failed: ", error.localizedDescription)
                    completion(nil, err)
                }
            }
        }
    }
    
    func getRecipeByRecipeId(id: Int64, completion: @escaping (Recipe?, Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/recipe/\(id)", headers: header).validate().responseDecodable(of: [Recipe].self) { response in
                switch response.result {
                case .success(let succcess):
                    completion(succcess[0], nil)
                case .failure(let error):
                    print("Alamofire failed: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
            completion(nil,nil)
        }
    }
    
    func getRecipesByUser(userId: String, page: String = "0", size: String = "20", sort: String = "date", order: String = "ASC", filter: FilterCriteria, completion: @escaping  ([Recipe]?, RecipeError?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/recipe/user/\(userId)?page=\(page)&page_size=\(size)&sort_field=\(sort)&order=\(order)",
                       method: .post, parameters: filter, encoder: JSONParameterEncoder.default, headers: header).validate().responseDecodable(of: [Recipe].self) { response in
                switch response.result {
                case .success(let succcess):
                    completion(succcess, nil)
                case .failure(let error):
                    var err = RecipeError()
                    do {
                        if let data = response.data {
                            let responseJSON = try JSON(data: data)
                            let message = responseJSON["details"].stringValue
                            err.details = message
                        }
                    } catch {}
                    print("Alamofire failed: ", error.localizedDescription)
                    completion(nil, err)
                }
            }
        }
    }
    
    func saveRecipe(recipe: RecipeModel, completion: @escaping (Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/recipe/save", method: .post, parameters: recipe, encoder: JSONParameterEncoder.default, headers: header).validate().response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    if let status = response.response {
                        if status.statusCode > 226 {
                            print("Alamofire failed: ", error.localizedDescription)
                            completion(error)
                        }
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func updateRecipe(recipe: RecipeModel, completion: @escaping (Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/recipe/update", method: .post, parameters: recipe, encoder: JSONParameterEncoder.default, headers: header).validate().response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    if let status = response.response {
                        if status.statusCode > 226 {
                            print("Alamofire failed: ", error.localizedDescription)
                            completion(error)
                        }
                    }
                    completion(nil)
                }
            }
        }
    }

    func addPurchase(_ purchase: PurchaseModel, completion: @escaping (Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/purchase/save", method: .post, parameters: purchase, encoder: JSONParameterEncoder.default, headers: header).validate().response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                    print("Alamofire failed: ", error.localizedDescription)
                }
            }
        }
    }
    
    func retreivePurchaseList(completion: @escaping  ([Purchase]?, Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/purchase/\(globalUserId)", headers: header).validate().responseDecodable(of: [Purchase].self) { response in
                switch response.result {
                case .success(let succcess):
                    completion(succcess, nil)
                case .failure(let error):
                    print("Alamofire failed: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    //MARK: Find out what that for
    func retreivePurchase(_ foodId: Int64, _ recipeId: Int64, completion: @escaping (PurchaseModel?, Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/purchase?foodid=\(foodId)&userid=\(globalUserId)&recipeid=\(recipeId)", headers: header).validate().responseDecodable(of: PurchaseModel.self) { response in
                switch response.result {
                case .success(let succcess):
                    completion(succcess, nil)
                case .failure(let error):
                    print("Alamofire failed: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }

    func deletePurchase(_ purchase: PurchaseModel, completion: @escaping (Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/purchase/delete", method: .delete, parameters: purchase, encoder: JSONParameterEncoder.default, headers: header).validate(statusCode: 200 ..< 299).response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    print("Alamofire failed: ", error.localizedDescription)
                    completion(error)
                }
            }
        }
    }
    
    //MARK: Delte all purchases of recipr from the cart
    func deleteCartRecipePurchase(_ recipeId: Int64, completion: @escaping (Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/purchase/delete/cart?userid=\(globalUserId)&recipeid=\(recipeId)", method: .delete, headers: header).validate(statusCode: 200 ..< 299).response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    if let status = response.response {
                        if status.statusCode > 226 {
                            print("Alamofire failed: ", error.localizedDescription)
                            completion(error)
                        }
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func updatePurchaseInCart(_ purchaseId: Int64, isAdd: Bool, completion: @escaping (Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/purchase/cart?id=\(purchaseId)&isadd=\(isAdd)&user=\(globalUserId)", method: .put, headers: header).validate(statusCode: 200 ..< 299).response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    if let status = response.response {
                        if status.statusCode > 226 {
                            print("Alamofire failed: ", error.localizedDescription)
                            completion(error)
                        }
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func getHeader(completion: (HTTPHeaders) -> ()) {
        guard let authanticateManager = authanticateManager else { return }
        var headers = HTTPHeaders()
        authanticateManager.getUserToken { token in
//            print(token)
            headers = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        }
        completion(headers)
    }
}
