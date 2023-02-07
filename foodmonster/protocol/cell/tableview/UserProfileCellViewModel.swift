//
//  UserProfileCellViewModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/24/22.
//

import Foundation

protocol UserProfileCellViewModelProtocol: AnyObject {
    
    var user: User { get }
    
}

class UserProfileCellViewModel: UserProfileCellViewModelProtocol {
    var user: User
    
    init(user: User) {
        self.user = user
    }
}
