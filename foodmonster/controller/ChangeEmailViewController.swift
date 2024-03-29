//
//  ChangeEmailViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/27/22.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var repeatEmailTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var authManager: AuthanticateManagerProtocol?
    private let alertTitle = Bundle.main.localizedString(forKey: "ops", value: LocalizationDefaultValues.OPS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let emailNotSame = Bundle.main.localizedString(forKey: "emailNotSame", value: LocalizationDefaultValues.EMAIL_NOT_SAME.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let emptyField = Bundle.main.localizedString(forKey: "emptyField", value: LocalizationDefaultValues.EMPTY_FIELD.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        repeatEmailTextField.delegate = self
        authManager = AuthanticateManager()
        confirmButton.layer.cornerRadius = 5
        confirmButton.addTarget(self, action: #selector(sundUpdateInformation), for: .touchUpInside)
        // Do any additional setup after loading the view.
        guard let user = user else { return }
        emailTextField.text = user.email
    }
    
    @objc func sundUpdateInformation() {
        updateEmailButtonPressed()
    }
    
    private func updateEmailButtonPressed() {
        guard let authManager = authManager, var user = user else { return }
        
        if !emailTextField.text!.isEmpty && !repeatEmailTextField.text!.isEmpty {
            
            if user.email != emailTextField.text && emailTextField.text == repeatEmailTextField.text {
                user.email = emailTextField.text ?? "none"
                authManager.updateUserInfo(user: user, trigger: "updateEmail") { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: self!.alertTitle, message: error.localizedDescription)
                    } else {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                if emailTextField.text != repeatEmailTextField.text {
                    showAlert(title: alertTitle, message: emailNotSame)
                }
            }
            
        } else {
            showAlert(title: alertTitle, message: emptyField)
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

extension ChangeEmailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            updateEmailButtonPressed()
        }
        return true
    }
    
}
