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
    private let alertTitle = Bundle.main.localizedString(forKey: "ops", value: LocalizationDefaultValues.OPS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let passResetted = Bundle.main.localizedString(forKey: "passResetted", value: LocalizationDefaultValues.PASS_RESSETED.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let instructionSent1 = Bundle.main.localizedString(forKey: "instructionSent1", value: LocalizationDefaultValues.INSTRUCTION_SENT_1.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let instructionSent2 = Bundle.main.localizedString(forKey: "instructionSent1", value: LocalizationDefaultValues.INSTRUCTION_SENT_2.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)

    
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
                self.showAlert(title: self.alertTitle, message: error.localizedDescription)
            } else {
                self.customAlertHandlerOkButton(title: self.passResetted, message: "\(self.instructionSent1) \(email). \(self.instructionSent2)", submitTitle: "Ok") {
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
