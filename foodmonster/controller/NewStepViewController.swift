//
//  NewStepViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/26/20.
//

import UIKit

class NewStepViewController: UIViewController {

    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var stepDescriptionTextView: UITextView!
    
    var step: Step?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissNavigationButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
