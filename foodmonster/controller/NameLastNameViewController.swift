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
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        authManager = AuthanticateManager()
        updateButton.addTarget(self, action: #selector(sundUpdateInformation), for: .touchUpInside)
        // Do any additional setup after loading the view.
        guard let user = user else { return }
        nameTextField.text = user.name
        lastNameTextField.text = user.lastName
    }
    

    @objc func sundUpdateInformation() {
        guard let authManager = authManager, var user = user else { return }
        if !nameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty {
            if user.name != nameTextField.text || user.lastName != lastNameTextField.text {
                user.name = nameTextField.text ?? "none"
                user.lastName = lastNameTextField.text ?? ""
                authManager.updateUserInfo(user: user, trigger: "update") { [weak self] error in
                    if let error = error {
                        print(error.localizedDescription)
                        self?.showAlert(title: "Oooops ... ", message: error.localizedDescription)
                    }
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                navigationController?.popToRootViewController(animated: true)
            }
        } else {
            showAlert(title: "Oooops ... ", message: "One of the fields empty")
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
