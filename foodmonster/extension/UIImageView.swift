//
//  UIImageView.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/3/23.
//

import Foundation
import UIKit

extension UIImageView {
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let startColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).cgColor
        gradient.colors = [startColor, endColor]
        if self.layer.sublayers == nil {
            self.layer.insertSublayer(gradient, at: 0)
        }
    }
    
}
