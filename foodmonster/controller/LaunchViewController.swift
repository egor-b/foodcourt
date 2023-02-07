//
//  LaunchViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/28/21.
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {
    
    private var auth: AuthanticateManagerProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        auth = AuthanticateManager()
        auth?.checkAuthStatus()
        auth?.authDidChange = { user in
            if user != nil {
                guard let user = user else { return }
                globalUserId = user.uid
                self.performSegue(withIdentifier: Segue.AUTO_LOGIN_SEGUE.rawValue, sender: nil)
            } else {
                if UserDefaults.standard.object(forKey: Anon.ANON.rawValue) != nil {
                    self.performSegue(withIdentifier: Segue.AUTO_LOGIN_SEGUE.rawValue, sender: nil)
                } else {
                    self.performSegue(withIdentifier: Segue.REGISTER_SEGUE.rawValue, sender: nil)
                }
            }
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
