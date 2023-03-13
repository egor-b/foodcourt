//
//  NameLastNameViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/23/22.
//

import UIKit

class NameLastNameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    private var authManager: AuthanticateManagerProtocol?
    private let alertTitle = Bundle.main.localizedString(forKey: "ops", value: LocalizationDefaultValues.OPS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let emptyField = Bundle.main.localizedString(forKey: "emptyField", value: LocalizationDefaultValues.EMPTY_FIELD.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        authManager = AuthanticateManager()
        updateButton.layer.cornerRadius = 5
        updateButton.addTarget(self, action: #selector(sundUpdateInformation), for: .touchUpInside)
        // Do any additional setup after loading the view.
        guard let user = user else { return }
        nameTextField.text = user.name
        lastNameTextField.text = user.lastName
    }
    

    @objc func sundUpdateInformation() {
        updateNameButtonPressed()
    }
    
    private func updateNameButtonPressed() {
        guard let authManager = authManager, var user = user else { return }
        if !nameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty {
            if user.name != nameTextField.text || user.lastName != lastNameTextField.text {
                user.name = nameTextField.text ?? "none"
                user.lastName = lastNameTextField.text ?? ""
                authManager.updateUserInfo(user: user, trigger: "update") { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: self!.alertTitle, message: error.localizedDescription)
                    }
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                navigationController?.popToRootViewController(animated: true)
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

extension NameLastNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            updateNameButtonPressed()
        }
        return true
    }
    
}
