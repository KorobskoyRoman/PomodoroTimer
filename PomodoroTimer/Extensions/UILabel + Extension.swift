//
//  UILabel + Extension.swift
//  PomodoroTimer
//
//  Created by Roman Korobskoy on 19.05.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont?, color: UIColor?) {
        self.init()
        
        self.text = text
        self.font = font
        self.textAlignment = .left
        self.textColor = color
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
