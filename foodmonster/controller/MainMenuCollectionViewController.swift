//
//  MainMenuCollectionViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/4/20.
//

import UIKit

private let reuseIdentifier = "MainMenuCollectionViewCell"

class MainMenuCollectionViewController: UICollectionViewController {
    
    private let constant = Constant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(title: "Menu")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return MainMenu.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.MAIN_MENU_CELL.rawValue, for: indexPath) as? MainMenuCollectionViewCell
    
        guard let collectionCell = cell else { return UICollectionViewCell() }
        collectionCell.layer.cornerRadius = 5
        collectionCell.cathegoryMenuLabel.text = MainMenu.allCases[indexPath.row].rawValue
    
        return collectionCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = main.instantiateViewController(withIdentifier: "CathegoryTableViewController") as! CategoryTableViewController
        destinationVC.cathegory = MainMenu.allCases[indexPath.row].rawValue
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension MainMenuCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        return CGSize(width: width * 0.45, height: height * 0.225)
    }
}

extension MainMenuCollectionViewController {
    func configureNavigationBar(title: String) {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: constant.darkTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: constant.darkTitleColor]
        navBarAppearance.backgroundColor = constant.backgoundColor
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = constant.darkTitleColor
        navigationItem.title = title
    }
}
