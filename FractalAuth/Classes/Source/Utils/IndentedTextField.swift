//
//  File.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 5/23/19.
//

import Foundation
import UIKit

open class IndentedTextField: UITextField {

    let padding: CGFloat

    public init(placeholder: String? = nil, padding: CGFloat, cornerRadius: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        self.placeholder = placeholder
        layer.cornerRadius = cornerRadius
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
