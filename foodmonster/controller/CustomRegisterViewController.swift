//
//  CustomRegisterViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/28/21.
//

import UIKit

class CustomRegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwoedTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    private let activityView = UIActivityIndicatorView(style: .large)
    private var auth: AuthanticateManagerProtocol?
        
    private let alertTitle =  Bundle.main.localizedString(forKey: "ops", value: LocalizationDefaultValues.OPS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let cancelTitle = Bundle.main.localizedString(forKey: "cancel", value: LocalizationDefaultValues.CANCEL.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let termsTitle = Bundle.main.localizedString(forKey: "terms", value: LocalizationDefaultValues.TERMS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let termsMessage = Bundle.main.localizedString(forKey: "termsWarn", value: LocalizationDefaultValues.TERMS_WARN.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let checkPass =  Bundle.main.localizedString(forKey: "checkPass", value: LocalizationDefaultValues.CHECK_PASS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let checkEmail = Bundle.main.localizedString(forKey: "checkEmail", value: LocalizationDefaultValues.CHECK_EMAIL.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = AuthanticateManager()
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        signUpButton.layer.cornerRadius = 5
        emailTextField.becomeFirstResponder()
        dismissKeyboard()
        initTextFields()
    }

    @objc func signUp() {
        signUpButtonPressed()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    private func fillOutUserModel() -> User {
        return User(email: emailTextField.text!, nickname: nicknameTextField.text!, name: nameTextField.text!, lastName: lastnameTextField.text!, accountType: AccountType.EMAIL.rawValue)
    }
    
    func signUpButtonPressed() {
        guard let auth = auth else { return }
        let user = fillOutUserModel()
        if auth.isValidEmail(emailTextField.text!) {
            if passwoedTextField.text == repeatPasswordTextField.text {
                
                self.customAlertWithHandler(title: termsTitle, message: termsMessage, submitTitle: "Ok", declineTitle: cancelTitle) {
                    self.showActivityIndicatory(activityView: self.activityView)
                    auth.registerByEmail(user: user, pass: self.passwoedTextField.text!, completion: { [self] error in
                        if let error = error {
                            self.stopActivityIndicatory(activityView: self.activityView)
                            self.showAlert(title: alertTitle, message: error.localizedDescription)
                        }
                        self.stopActivityIndicatory(activityView: self.activityView)
                        self.performSegue(withIdentifier: Segue.SIGNUP_SEGUE.rawValue, sender: nil)
                    })
                } declineHandler: {
                    
                }
                
            } else {
                showAlert(title: alertTitle, message: checkPass)
            }
        } else {
            showAlert(title: alertTitle, message: checkEmail)
        }
    }

}

extension CustomRegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signUpButtonPressed()
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
    
    func initTextFields() {
        emailTextField.delegate = self
        passwoedTextField.delegate = self
        repeatPasswordTextField.delegate = self
        nicknameTextField.delegate = self
        nameTextField.delegate = self
        lastnameTextField.delegate = self
    }
}
