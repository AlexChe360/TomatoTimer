//
//  UIView+Extensions.swift
//  TomatoTimer
//
//  Created by Alex on 18.01.2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
}
