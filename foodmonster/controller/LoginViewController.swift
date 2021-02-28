//
//  LoginViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 2/21/21.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    private var loginViewModel: LoginViewViewModelProtocol?

    @IBOutlet weak var emalTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var anonynousLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewViewModel()
        applyStyle()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
    }
    
    func applyStyle() {
        loginButton.layer.cornerRadius = 5
        googleLoginButton.layer.cornerRadius = 5
        facebookLoginButton.layer.cornerRadius = 5
        appleLoginButton.layer.cornerRadius = 5
    }

    @IBAction func login(_ sender: Any) {
        loginViewModel?.loginByPersonalCredentials(credentials: Credentials.init(email: emalTextField.text!, password: passwordTextField.text!))
    }
    
    @IBAction func loginByGoogle(_ sender: Any) {
        loginViewModel?.loginByGoogle()
    }
    
    @IBAction func loginByFacebook(_ sender: Any) {
        loginViewModel?.loginByFacebook()
    }
    
    @IBAction func loginByApple(_ sender: Any) {
        loginViewModel?.loginByApple()
    }
    
    @IBAction func anonymouslogin(_ sender: Any) {
        
    }
    
    @IBAction func signup(_ sender: Any) {
        
    }
}
