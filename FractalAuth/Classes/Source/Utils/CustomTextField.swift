//
//  CustomTextField.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 4/15/19.
//

import Foundation

class CustomTextField: UITextField, UITextFieldDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .black
        font = UIFont.systemFont(ofSize: 14)
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tintColor = .black
        font = UIFont.systemFont(ofSize: 14)
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override var tintColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if tintColor == .red {
            tintColor = .black
            textColor = .black
        }
    }

    override func draw(_ rect: CGRect) {

        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)

        let path = UIBezierPath()

        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 1.0

        tintColor.setStroke()

        path.stroke()
    }
    //ic_visibility

    func addToggleSecurityButton() {

        let bundle = Bundle(for: CustomTextField.self).podResource(name: "FractalAuth")

        let rightButton  = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "ic_visibility", in: bundle, compatibleWith: nil), for: .selected)
        rightButton.setImage(UIImage(named: "ic_visibility_off", in: bundle, compatibleWith: nil), for: .normal)
        rightButton.frame = CGRect(x:0, y:0, width:40, height:24)
        rightButton.addTarget(self, action: #selector(toggleSecurity), for: .touchUpInside)
        rightButton.isSelected = !isSecureTextEntry
        rightButton.tintColor = UIColor.lightGray
        rightViewMode = .always
        rightView = rightButton
    }

    @objc func toggleSecurity() {
        isSecureTextEntry = !isSecureTextEntry
        (rightView as! UIButton).isSelected = !isSecureTextEntry
    }
}
