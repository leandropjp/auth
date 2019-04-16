//
//  ImageHelper.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 4/15/19.
//

import Foundation

extension UIImage {
    convenience init?(podAssetName: String) {
        let podBundle = Bundle(for: LoginViewController.self)

        /// A given class within your Pod framework
        guard let url = podBundle.url(forResource: "FractalAuth",
                                      withExtension: "bundle") else {
                                        return nil

        }

        self.init(named: podAssetName,
                  in: Bundle(url: url),
                  compatibleWith: nil)
    }
}

extension Bundle {

    /**
     Locate an inner Bundle generated from CocoaPod packaging.

     - parameter name: the name of the inner resource bundle. This should match the "s.resource_bundle" key or
     one of the "s.resoruce_bundles" keys from the podspec file that defines the CocoPod.
     - returns: the resource Bundle or `self` if resource bundle was not found
     */
    func podResource(name: String) -> Bundle {
        guard let bundleUrl = self.url(forResource: name, withExtension: "bundle") else { return self }
        return Bundle(url: bundleUrl) ?? self
    }
}
