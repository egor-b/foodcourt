//
//  LoginViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 2/21/21.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private var loginViewModel: AuthanticateManagerProtocol?
    private let appleIDProvider = ASAuthorizationAppleIDProvider()

    let activityView = UIActivityIndicatorView(style: .large)

    @IBOutlet weak var emalTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var anonynousLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emalTextField.delegate = self
        passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        loginViewModel = AuthanticateManager()
        applyStyle()
        dismissKeyboard()
    }
    
    func applyStyle() {
        loginButton.layer.cornerRadius = 5
        googleLoginButton.layer.cornerRadius = 5
        facebookLoginButton.layer.cornerRadius = 5
        appleLoginButton.layer.cornerRadius = 5
    }

    @IBAction func login(_ sender: Any) {
        loginButtonPressed()
    }
    
    @IBAction func loginByGoogle(_ sender: Any) {
        loginViewModel?.loginByGoogle(view: self) { error in
            if let error = error {
                self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
            }
            self.performSegue(withIdentifier: Segue.LOGIN_SEGUE.rawValue, sender: nil)
        }
       
    }
    
    @IBAction func loginByFacebook(_ sender: Any) {
        loginViewModel?.loginByFacebook(view: self) { error in
            if let error = error {
                self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
            }
            self.performSegue(withIdentifier: Segue.LOGIN_SEGUE.rawValue, sender: nil)
        }
    }
    
    @IBAction func loginByApple(_ sender: Any) {
        guard let loginViewModel = loginViewModel else { showAlert(title: "Ooops ... ", message: "Something was wrong. We work on it. Please try again little later."); return }
        loginViewModel.randomNonceString(length: 32)
        guard let sha = loginViewModel.sha256() else { showAlert(title: "Ooops ... ", message: "Something was wrong. We work on it. Please try again little later."); return }
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    @IBAction func anonymouslogin(_ sender: Any) {
        guard let loginViewModel = loginViewModel else { return }
        loginViewModel.anonymousLogin { (controller:TabBarViewController) in
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.origin.y = -keyboardFrame.size.height + 150
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func loginButtonPressed() {
        view.endEditing(true)
        showActivityIndicatory(activityView: activityView)
        guard let loginViewModel = loginViewModel else { return }
        loginViewModel.loginByEmail(credential: Credentials.init(email: emalTextField.text!, password: passwordTextField.text!), completion: { error, _  in
            if let error = error {
                self.stopActivityIndicatory(activityView: self.activityView)
                self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
            } else {
                self.stopActivityIndicatory(activityView: self.activityView)
                self.performSegue(withIdentifier: Segue.LOGIN_SEGUE.rawValue, sender: nil)
            }
            
        })
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButtonPressed()
        }
        return true
    }
    
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            var new = false
            if let _ = appleIDCredential.email {
                new = true
            }
            
            loginViewModel?.loginByApple(idTokenString: idTokenString, isNew: new, completion: { error in
                if let error = error {
                    self.stopActivityIndicatory(activityView: self.activityView)
                    self.showAlert(title: "Ooops ... ", message: error.localizedDescription)
                } else {
                    self.stopActivityIndicatory(activityView: self.activityView)
                    self.performSegue(withIdentifier: Segue.LOGIN_SEGUE.rawValue, sender: nil)
                }
            })
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }   
    
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
