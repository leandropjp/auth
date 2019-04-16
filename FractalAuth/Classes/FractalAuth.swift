//
//  FractalAuth.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 4/15/19.
//

import Foundation
import PromiseKit

enum ErrorType: LocalizedError {
    case resultNil

    var errorDescription: String? {
        switch self {
        case .resultNil:
            return "Login dismissed"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .resultNil:
            return "Login dismissed"
        }
    }

}

public class FractalAuth {

    public static func setEnviroment(_ value: Environment) {
        FractalRestAPI.shared.environment = value
    }

    public static func presentSignIn() -> Promise<User> {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        //nav.isNavigationBarHidden = true
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(nav, animated: true, completion: nil)
        }
        //let errorPromise = Promise<User>.init(error: ErrorType.resultNil)

        return vc.loginResult.promise
    }
}
