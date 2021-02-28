//
//  Cells.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

enum Cells: String {
    case CATEGORY_CELL = "categoryCell"
    case MAIN_MENU_CELL = "mainMenuCell"
    
    //MARK: - My recipes
    case MY_RECIPE_CELL = "myRecipeCell"
    
    //MARK: - Recipe Detail
    case INFO_RECIPE_CELL = "infoRecipeCell"
    case INGREDIENT_CELL = "ingredientCell"
    case ABOUT_RECIPE_CELL = "aboutRecipeCell"
    case STEP_CELL = "stepCell"
    case SERVE_CELL = "serveCell"
    
    //MARK: - List of purchase
    case PURCHASE_CELL = "purchaseCell"
    case HEADER_DISH_PURCHASE_CELL = "headerDishPurchaseCell"
    case CUSTOM_PURCHASE_CELL = "customPurchaseCell"
    case ADD_CUSTOM_PURCHASE_CELL = "addCustomPurchaseCell"
    
    //MARK: - New recipe
    case RECIPE_NAME_CELL = "recipeNameCell"
    case RECIPE_CATEGORY_CELL = "recipeCategoryCell"
    case COOK_TIME_CELL = "cookTimeCell"
    case NEW_INGREFIENT_CELL = "newIngredientCell"
    case ADD_ITEM_CELL = "addItemCell"
    case COOK_STEP_CELL = "cookStepCell"
}
