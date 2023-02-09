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
    
    private var authManager: AuthanticateManagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authManager = AuthanticateManager()
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        passwordTextField.becomeFirstResponder()
        
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
                        self?.showAlert(title: "Oooops ... ", message: error.localizedDescription)
                    } else {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                self.showAlert(title: "Oooops ... ", message: "Password mismatch.")
            }
        } else {
            self.showAlert(title: "Oooops ... ", message: "Looks like you didn't set new password.")
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
