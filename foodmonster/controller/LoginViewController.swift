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
    private let alertTitle =  Bundle.main.localizedString(forKey: "ops", value: LocalizationDefaultValues.OPS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let termsTitle = Bundle.main.localizedString(forKey: "terms", value: LocalizationDefaultValues.TERMS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let termsMessage = Bundle.main.localizedString(forKey: "termsWarn", value: LocalizationDefaultValues.TERMS_WARN.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let show = Bundle.main.localizedString(forKey: "show", value: LocalizationDefaultValues.SHOW.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let alertMessage = Bundle.main.localizedString(forKey: "somethingWasWrong", value: LocalizationDefaultValues.SOMETHING_WAS_WRONG.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let activityView = UIActivityIndicatorView(style: .large)

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
        self.customAlertWithHandler(title: termsTitle, message: termsMessage, submitTitle: "Ok", declineTitle: show) {
            self.googleLogin()
        } declineHandler: {
            self.showTermsAndConditions(loginType: AccountType.GOOGLE)
        }
    }
    
    func googleLogin() {
        self.loginViewModel?.loginByGoogle(view: self) { error in
            if let error = error {
                self.showAlert(title: self.alertTitle, message: error.localizedDescription)
            }
            self.performSegue(withIdentifier: Segue.LOGIN_SEGUE.rawValue, sender: nil)
        }
    }
    
    @IBAction func loginByFacebook(_ sender: Any) {
        self.customAlertWithHandler(title: termsTitle, message: termsMessage, submitTitle: "Ok", declineTitle: show) {
            self.facebookLogin()
        } declineHandler: {
            self.showTermsAndConditions(loginType: AccountType.FACEBOOK)
        }
    }
    
    func facebookLogin() {
        self.loginViewModel?.loginByFacebook(view: self) { error in
            if let error = error {
                self.showAlert(title: self.alertTitle, message: error.localizedDescription)
            }
            self.performSegue(withIdentifier: Segue.LOGIN_SEGUE.rawValue, sender: nil)
        }
    }
    
    @IBAction func loginByApple(_ sender: Any) {
        self.customAlertWithHandler(title: termsTitle, message: termsMessage, submitTitle: "Ok", declineTitle: show) {
            self.appleLogin()
        } declineHandler: {
            self.showTermsAndConditions(loginType: AccountType.APPLE)
        }
    }
    
    func appleLogin() {
        guard let loginViewModel = self.loginViewModel else {
            self.showAlert(title: self.alertTitle, message: self.alertMessage)
            return
        }
        loginViewModel.randomNonceString(length: 32)
        guard let sha = loginViewModel.sha256() else {
            self.showAlert(title: self.alertTitle, message: self.alertMessage)
            return
        }
        let request = self.appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func anonymouslogin(_ sender: Any) {
        guard let loginViewModel = loginViewModel else { return }
        showActivityIndicatory(activityView: activityView)
        loginViewModel.anonymousLogin { (controller:TabBarViewController) in
            controller.modalTransitionStyle = .crossDissolve
            self.stopActivityIndicatory(activityView: self.activityView)
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
                self.showAlert(title: self.alertTitle, message: error.localizedDescription)
            } else {
                self.stopActivityIndicatory(activityView: self.activityView)
                self.performSegue(withIdentifier: Segue.LOGIN_SEGUE.rawValue, sender: nil)
            }
            
        })
    }
    
    func showTermsAndConditions(loginType: AccountType) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "termsAndConditionsController") as! TermsAndConditionsViewController
        newViewController.loginViewController = self
        newViewController.loginType = loginType
        self.present(newViewController, animated: true, completion: nil)
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
            if let authorizationCode = appleIDCredential.authorizationCode,
               let codeString = String(data: authorizationCode, encoding: .utf8) {
                UserDefaults.standard.set(codeString, forKey: "authorizationCode")
            }
            loginViewModel?.loginByApple(idTokenString: idTokenString, appleIDCredential: appleIDCredential, completion: { error in
                if let error = error {
                    self.stopActivityIndicatory(activityView: self.activityView)
                    self.showAlert(title: self.alertTitle, message: error.localizedDescription)
                } else {
                    self.stopActivityIndicatory(activityView: self.activityView)
                    self.performSegue(withIdentifier: Segue.LOGIN_SEGUE.rawValue, sender: nil)
                }
            })
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
    
    func test() {
        print("akgoeirmgeorimgergoemrgomerogmqerogewormgwq[ermgowergoiwemrg")
    }
    
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
