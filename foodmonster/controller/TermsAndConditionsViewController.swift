//
//  TermsAndConditionsViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/27/23.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {
    
    var loginViewController: LoginViewController?
    var loginType: AccountType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func acceptTerms(_ sender: Any) {
        
        dismiss(animated: true)

        if loginType == AccountType.FACEBOOK {
            loginViewController?.facebookLogin()
        }
        if loginType == AccountType.APPLE {
            loginViewController?.appleLogin()
        }
        if loginType == AccountType.GOOGLE {
            loginViewController?.googleLogin()
        }
        
    }

    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
