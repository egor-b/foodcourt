//
//  ModificationNewRecipeViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 12/29/21.
//

import UIKit

class AboutNewRecipeViewController: UIViewController {
    
    @IBOutlet weak var itemTextFiled: UITextView!
    @IBOutlet weak var navBar: UINavigationBar!
        
    var modificationType: String?
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if text != nil {
            itemTextFiled.text = text
        }
        itemTextFiled.becomeFirstResponder()
        navBar.topItem?.title = "About"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        itemTextFiled.clipsToBounds = true
        itemTextFiled.layer.cornerRadius = 10
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.origin.y = keyboardFrame.size.height - 200
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

}
