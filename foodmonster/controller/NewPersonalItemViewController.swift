//
//  NewPersonalItemViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/31/22.
//

import UIKit

class NewPersonalItemViewController: UIViewController, UITextFieldDelegate {

    var item: String = ""
    @IBOutlet weak var newItemTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newItemTextField.delegate = self
        newItemTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        return textField.text!.count <= 100
    }
}
