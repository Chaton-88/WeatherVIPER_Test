//
//  UILabel.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 07.01.2023.
//

import UIKit

extension UILabel {
    
    convenience init(text: String = "", font: UIFont?) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = .black
        self.textAlignment = .left
        self.toAutoLayout()
    }
}

