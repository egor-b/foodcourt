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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func signUpButtonPressed() {
        guard let auth = auth else { return }
        let user = fillOutUserModel()
        if isValidEmail(emailTextField.text!) {
            if passwoedTextField.text == repeatPasswordTextField.text {
                
                self.customAlertWithHandler(title: "Terms and Conditions", message: "By continuing to register, you accept the terms and conditions.", submitTitle: "Ok", declineTitle: "Cancel") {
                    self.showActivityIndicatory(activityView: self.activityView)
                    auth.registerByEmail(user: user, pass: self.passwoedTextField.text!, completion: { error in
                        if let error = error {
                            self.stopActivityIndicatory(activityView: self.activityView)
                            self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
                        }
                        self.stopActivityIndicatory(activityView: self.activityView)
                        self.performSegue(withIdentifier: Segue.SIGNUP_SEGUE.rawValue, sender: nil)
                    })
                } declineHandler: {
                    
                }
                
            } else {
                showAlert(title: "Oooops ... ", message: "Check your password")
            }
        } else {
            showAlert(title: "Oooops ... ", message: "Check email address")
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
