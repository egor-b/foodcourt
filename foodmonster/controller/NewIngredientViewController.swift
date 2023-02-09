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
    
    var ingredient = FoodModel()
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTextField.becomeFirstResponder()
        ingredientTextField.delegate = self
        weightTextField.delegate = self
        measureTextField.delegate = self
        fillInIngredientModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fillInIngredientModel() {
        ingredientTextField.text = ingredient.foodstuff.name
        weightTextField.text = String(describing: ingredient.size)
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
    
}
