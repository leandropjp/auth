//
//  UINavigationController.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 4/15/19.
//

import Foundation

extension UINavigationController {

    func addBackButton(with image: UIImage?) {
        let backButton = UIButton(type: .custom)
        backButton.tintColor = UIColor.black
        backButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle("TESTANDO", for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc private func backAction() {
        self.popViewController(animated: true)
    }
}
