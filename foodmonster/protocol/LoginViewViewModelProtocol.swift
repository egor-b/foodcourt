//
//  LoginViewViewModelProtocol.swift
//  foodster
//
//  Created by Egor Bryzgalov on 2/21/21.
//

import Foundation

protocol LoginViewViewModelProtocol {
    
    func loginByPersonalCredentials(credentials: Credentials)
    func loginByGoogle()
    func loginByFacebook()
    func loginByApple()
    
}
