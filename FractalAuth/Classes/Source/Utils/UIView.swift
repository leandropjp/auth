//
//  UIView.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 5/7/19.
//

import Foundation
import UIKit

extension UIView{
    // For insert layer in Foreground
    func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    // For insert layer in background
    func addBlackGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.insertSublayer(gradient, at: 0)
    }
}

public extension UIImage {

    var hasContent: Bool {
        return cgImage != nil || ciImage != nil
    }
}
