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
    }
    

    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        menuButton.layer.shadowColor = UIColor.gray.cgColor
        menuButton.layer.shadowOpacity = 1
        menuButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        menuButton.layer.shadowRadius = 3
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

        menuButton.backgroundColor = UIColor(named: "iconColorSet")
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: "ic_add"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }


       // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
    }
    
}
