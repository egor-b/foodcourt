//
//  Seque.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

enum Segue: String {
    case RECIPE_DETAIL_SEGUE = "recipeDetailSeque"
    case EDIT_SEGUE = "editSegue"
    case SHOW_RECIPE_SEGUE = "showRecipeSegue"
    case ADD_NEW_PERSONAL_PURCHASE = "newPersonalPurchaseSegue"
    
    case ADD_INGREDIENT_SEGUE = "addIngredientSegue"
    case ADD_STEP_SEGUE = "addStepSegue"
    case ABOUT_NEW_SEGUE = "aboutNewSegue"
    case MODIFICATION_SEGUE = "modificationSegue"
    
    case EDIT_NAME_SEQUE = "editNameSeque"
    case CHANGE_PASS_SEQUE = "changePasswordSeque"
    case CHANGE_EMAIL_SEGUE = "changeEmailSeque"
    
    case REGISTER_SEGUE = "registerSegue"
    case LOGIN_SEGUE = "loginSegue"
    case AUTO_LOGIN_SEGUE = "autoLoginSegue"
    case NEW_USER_SEGUE = "newUserSegue"
    case SIGNUP_SEGUE = "signUpSegue"
}
