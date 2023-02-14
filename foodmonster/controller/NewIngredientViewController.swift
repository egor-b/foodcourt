//
//  NewIngredientViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/22/20.
//

import UIKit

class NewIngredientViewController: UIViewController {
    
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var measureTextField: UITextField!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
   
    var ingredient = FoodModel()
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTextField.becomeFirstResponder()
        ingredientTextField.delegate = self
        weightTextField.delegate = self
        measureTextField.delegate = self
        saveBarButtonItem.isEnabled = false
        ingredientTextField.addTarget(self, action: #selector(isIngredientExist), for: .allEditingEvents)
        weightTextField.addTarget(self, action: #selector(isWeightExist), for: .allEditingEvents)
        fillInIngredientModel()
    }
    
    @objc func isIngredientExist() {
        if let text = ingredientTextField.text, text.count < 2 {
            saveBarButtonItem.isEnabled = false
        } else {
            if let text = weightTextField.text, text.count < 1 {
                saveBarButtonItem.isEnabled = false
            } else {
                saveBarButtonItem.isEnabled = true
            }
        }
    }
    
    @objc func isWeightExist() {
        if let text = weightTextField.text, text.count < 1 {
            saveBarButtonItem.isEnabled = false
        } else {
            if let text = ingredientTextField.text, text.count < 2 {
                saveBarButtonItem.isEnabled = false
            } else {
                saveBarButtonItem.isEnabled = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fillInIngredientModel() {
        ingredientTextField.text = ingredient.foodstuff.name
        if ingredient.size != 0.0 {
            weightTextField.text = String(describing: ingredient.size)
        }
        measureTextField.text = ingredient.measure
    }

}

extension NewIngredientViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } 
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 0:
            return textField.text!.count < 100
        case 1:
            let ACCEPTABLE_CHARACTERS = "0123456789/."
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered && textField.text!.count < 6)
        case 2:
            return textField.text!.count <= 10
        default:
            return true
        }
        
    }
    
}
