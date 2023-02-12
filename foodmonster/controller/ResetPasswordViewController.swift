//
//  ResetPasswordViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/11/23.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cancelButon: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private var authManager: AuthanticateManagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authManager = AuthanticateManager()
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        resetButton.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        resetButton.layer.cornerRadius = 5
        cancelButon.addTarget(self, action: #selector(cancelPasswordReset), for: .touchUpInside)
        cancelButon.layer.cornerRadius = 5
    }
    
    @objc func sendRequest() {
        guard let authManager = authManager, let email = emailTextField.text else { return }
        authManager.resetUserPasswordByEmail(email: email) { error in
            if let error = error {
                self.showAlert(title: "Oooops ... ", message: error.localizedDescription)
            } else {
                self.customAlertHandlerOkButton(title: "Password is resetted", message: "Instructions was sent to \(email). Please follow to instruction to create new password.", submitTitle: "Ok") {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    @objc func cancelPasswordReset() {
        dismiss(animated: true)
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendRequest()
        return true
    }
    
}
