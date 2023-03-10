//
//  NameTimeViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/3/22.
//

import UIKit

class NameTimeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTimeTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var modType: String?
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTimeTextField.delegate = self
        if text != nil {
            nameTimeTextField.text = text
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        nameTimeTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        setViewContent()
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.origin.y = keyboardFrame.size.height - 100
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setViewContent() {
        if modType == "Cook time" {
            let cookTime = Bundle.main.localizedString(forKey: "cookTime", value: LocalizationDefaultValues.COOK_TIME.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
            navBar.topItem?.title = cookTime
            nameTimeTextField.keyboardType = .numberPad
            nameTimeTextField.textAlignment = .center
        } else {
            let recipeName = Bundle.main.localizedString(forKey: "recipeName", value: LocalizationDefaultValues.RECIPE_NAME.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
            navBar.topItem?.title = recipeName
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if modType == "Cook time" {
            return textField.text!.count < 4
        } else {
            return textField.text!.count <= 100
        }
        
    }

}
