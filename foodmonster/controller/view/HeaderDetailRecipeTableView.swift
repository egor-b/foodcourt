//
//  HeaderRecipeTableView.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/12/20.
//

import UIKit

class HeaderDetailRecipeTableView: UITableView {

    var heightHeaderConstraint: NSLayoutConstraint!
    var bottomHeaderConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let header = tableHeaderView else {return}
        
        if let imageView = header.subviews.first as? UIImageView {
            heightHeaderConstraint = imageView.constraints.filter{ $0.identifier == "heightHeader" }.first
            bottomHeaderConstraint = header.constraints.filter{ $0.identifier == "bottomHeader" }.first
        }
        
        let yOffset = -self.contentOffset.y
        bottomHeaderConstraint?.constant = yOffset >= 0 ? 0 : yOffset/2
        heightHeaderConstraint?.constant = max(header.bounds.height, header.bounds.height + yOffset)
        header.clipsToBounds = yOffset <= 0
    }
}
