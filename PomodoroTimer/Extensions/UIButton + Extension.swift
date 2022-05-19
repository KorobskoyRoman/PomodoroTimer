//
//  UIButton + Extension.swift
//  PomodoroTimer
//
//  Created by Roman Korobskoy on 19.05.2022.
//

import UIKit

extension UIButton {
    convenience init(title: String,
                         titleColor: UIColor,
                     imageName: String? = nil) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setImage(UIImage(systemName: imageName ?? ""), for: .normal)
        self.tintColor = titleColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
