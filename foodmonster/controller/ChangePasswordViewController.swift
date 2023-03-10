//
//  ChangePasswordViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/6/22.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var authManager: AuthanticateManagerProtocol?
    private let alertTitle =  Bundle.main.localizedString(forKey: "ops", value: LocalizationDefaultValues.OPS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)

    override func viewDidLoad() {
        super.viewDidLoad()
        authManager = AuthanticateManager()
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        passwordTextField.becomeFirstResponder()
        confirmButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePasswordButton(_ sender: Any) {
        changePasswordButtonPressed()
    }
    
    private func changePasswordButtonPressed() {
        guard let authManager = authManager else {
            return
        }
        if !passwordTextField.text!.isEmpty && !repeatPasswordTextField.text!.isEmpty {
            if passwordTextField.text  == repeatPasswordTextField.text {
                authManager.changeUserPassword(password: passwordTextField.text!) { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: self!.alertTitle, message: error.localizedDescription)
                    } else {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                let message = Bundle.main.localizedString(forKey: "passwordMismatch", value: LocalizationDefaultValues.PASSWORD_MISMATCH.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
                self.showAlert(title: self.alertTitle, message: message)
            }
        } else {
            let message = Bundle.main.localizedString(forKey: "noNewPassword", value: LocalizationDefaultValues.NO_NEW_PASSWORD.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
            self.showAlert(title: self.alertTitle, message: message)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            changePasswordButtonPressed()
        }
        return true
    }
    
}
