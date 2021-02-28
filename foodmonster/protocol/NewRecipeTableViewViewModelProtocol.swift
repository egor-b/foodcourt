//
//  NewRecipeTableViewViewModelProtocol.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/21/20.
//

import UIKit

protocol NewRecipeTableViewViewModelProtocol {
    
    func numberOfRows(inSection section: Int) -> Int
    func viewForHeader(inSection section: Int, width: CGFloat, height: CGFloat) -> UIView
    
//    func selectedRow(atIndexPath indexPath: IndexPath)
//    func getIndexPath() -> IndexPath
    
    func getIngredient(atIndexPath indexPath: IndexPath) -> Food
    func getStep(atIndexPath indexPath: IndexPath) -> Step
    
}
