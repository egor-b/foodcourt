//
//  TabBarViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/19/20.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        if let items = tabBar.items {
          if items.count > 0 {
            let itemToDisable = items[2]
              itemToDisable.isEnabled = false
          }
        }
    }
    

    func setupMiddleButton() {
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        menuButton.layer.shadowColor = UIColor.gray.cgColor
        menuButton.layer.shadowOpacity = 1
        menuButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        menuButton.layer.shadowRadius = 3
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 42.5
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        let emptyView = UIView(frame: CGRect(x: view.bounds.width/2 - 35, y: view.bounds.height - menuButtonFrame.height - 50, width: 70, height: 80))
        emptyView.backgroundColor = UIColor(named: "lightBackgroundColorSet")
        emptyView.layer.cornerRadius = 25
        view.addSubview(emptyView)
        
        menuButton.backgroundColor = UIColor(named: "iconColorSet")
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: "ic_add"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }


       // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newRecipeController = storyboard.instantiateViewController(withIdentifier: "newRecipeViewController") as! UINavigationController
        newRecipeController.modalTransitionStyle = .crossDissolve
        newRecipeController.modalPresentationStyle = .fullScreen
        self.present(newRecipeController, animated: true, completion: nil)
    }
    
}
