//
//  TableViewViewModelProtocol.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/7/20.
//

import Foundation

protocol TableViewViewModelProtocol {
    
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RecipeTableViewCellViewModelProtocol?
    
    func viewModelForSelectedRow() -> RecipeTableViewCellViewModel?
    func selectedRow(atIndexPath indexPath: IndexPath)
    
    func getListByType(type: String, completion: @escaping() -> ())
    func getListByUserId(userId id: String, completion: @escaping() -> ())
    
}
