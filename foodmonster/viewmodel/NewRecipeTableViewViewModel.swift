//
//  NewRecipeTableViewViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/21/20.
//

import UIKit

class NewRecipeTableViewViewModel: NewRecipeTableViewViewModelProtocol {
    
    private var recipe: Recipe?
    
//    private var selectedIndexPath: IndexPath?
    
    func numberOfRows(inSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        if section == 1 {
            guard let count = recipe?.food.count else { return 1 }
            return count + 1
        }
        if section == 2 {
            guard let count = recipe?.step.count else { return 1 }
            return count + 1
        }
        return 0
    }
    
    func viewForHeader(inSection section: Int, width: CGFloat, height: CGFloat) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let label = UILabel(frame: CGRect(x: 15, y: 25, width: headerView.frame.width - 50, height: headerView.frame.height/2))
        if section == 1 {
            label.text = "Ingredients"
        }
        if section == 2 {
            label.text = "Steps"
        }
        label.textColor = UIColor(named: "lightTextColorSet")
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor(named: "backgroundColorSet")
        return headerView
    }
    
//    func selectedRow(atIndexPath indexPath: IndexPath) {
//        self.selectedIndexPath = indexPath
//    }
    
//    func getIndexPath() -> IndexPath {
//        return selectedIndexPath ?? [0,0]
//    }
    
    func getIngredient(atIndexPath indexPath: IndexPath) -> Food {
        return recipe!.food[indexPath.row]
    }
    
    func getStep(atIndexPath indexPath: IndexPath) -> Step {
        return recipe!.step[indexPath.row]
    }
}
