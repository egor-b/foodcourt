//
//  LoginViewViewModel.swift
//  foodster
//
//  Created by Egor Bryzgalov on 2/22/21.
//

import Foundation
import Firebase
import GoogleSignIn

class LoginViewViewModel: LoginViewViewModelProtocol {
    
    func loginByPersonalCredentials(credentials: Credentials) {
        print(credentials)
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { [weak self] authResult, error in
//            guard let strongSelf = self else { return }
            //auth
        }
    }
    
    func loginByGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func loginByFacebook() {
        print("Login by Facebook")
    }
    
    func loginByApple() {
        print("login by Appl")
    }
    
    
}
