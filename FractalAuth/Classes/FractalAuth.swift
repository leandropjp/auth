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

public struct CustomizeBundle {

    var image: UIImage?
    var appName: String?
    var bgImage: UIImage?

    public init(appImage: UIImage?, appName: String, bgImage: UIImage? = nil) {
        self.image = appImage
        self.appName = appName
        self.bgImage = bgImage
    }
}

public class FractalAuth {

    public static func logout() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }

    public static var user: User? {
        get {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let userData = UserDefaults.standard.value(forKey: userKey) as? Data,
                let user = try? decoder.decode(User.self, from: userData) {
                return user
            } else {
                return nil
            }
        }
    }

    public static func setEnviroment(_ value: Environment) {
        FractalRestAPI.shared.environment = value
    }

    public static func presentSignIn(with customApp: CustomizeBundle? = nil) -> Promise<User> {
        let vc = LoginViewController()
        vc.customizeBundle = customApp
        let nav = UINavigationController(rootViewController: vc)
        //nav.isNavigationBarHidden = true
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(nav, animated: true, completion: nil)
        }
        let errorPromise = Promise<User>.init(error: ErrorType.resultNil)
        let pendingPromise = Promise<User>.pending()
        vc.loginResult = pendingPromise
        
        return vc.loginResult?.promise ?? errorPromise
    }

    /**
    This method presents the Fractal Sign Up View.
     - Parameter customApp: The customize bundle used to prepare the view for a specific app.
     - Returns: A Promise<User> that can return an User or Error
     */
    public static func presentSignUp(with customApp: CustomizeBundle? = nil) -> Promise<User> {
        let vc = SignUpViewController()
        vc.customizeBundle = customApp
        let nav = UINavigationController(rootViewController: vc)
        //nav.isNavigationBarHidden = true
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(nav, animated: true, completion: nil)
        }
        let errorPromise = Promise<User>.init(error: ErrorType.resultNil)
        let pendingPromise = Promise<User>.pending()
        vc.signUpResult = pendingPromise

        return vc.signUpResult?.promise ?? errorPromise
    }
}
