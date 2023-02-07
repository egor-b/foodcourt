//
//  UIViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/16/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    private func createSubview(activityView: UIActivityIndicatorView) -> UIView {
        let container: UIView = UIView()
        container.tag = 5651489
        container.frame = CGRect(x: view.bounds.width/2 - 60, y: view.bounds.height/2 - 200, width: 120, height: 120) // Set X and Y whatever you want
        container.backgroundColor = UIColor(named: "lightTextColorSet")
        container.alpha = 0.5
        container.layer.cornerRadius = 15
        
        activityView.frame = CGRect(x: 20, y: 20, width: 80, height: 80)
        activityView.color = Constant().darkTitleColor
        
        container.addSubview(activityView)
        return container
    }
    
    func showActivityIndicatory(activityView: UIActivityIndicatorView) {
        let v = createSubview(activityView: activityView)
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(v)
        }, completion: nil)
        activityView.startAnimating()
    }
    
    func stopActivityIndicatory(activityView: UIActivityIndicatorView) {
        if let viewWithTag = self.view.viewWithTag(5651489) {
            UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                viewWithTag.removeFromSuperview()
            }, completion: nil)
        }
        activityView.stopAnimating()
    }
    
    func showAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func showUnknownUserAlert() {
        let dialogMessage = UIAlertController(title: "Ooops ... ", message: "Please, log in or create new acccount for start building you cook book.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Log In", style: .default, handler: { _ in
            UserDefaults.standard.removeObject(forKey: Anon.ANON.rawValue)
            self.dismiss(animated: true)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.tabBarController?.selectedIndex = 0
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    

}

