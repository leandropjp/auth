//
//  FractalAuth.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 4/15/19.
//

import Foundation
import PromiseKit
import IQKeyboardManagerSwift

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
    var bgColor: UIColor?

    public init(appImage: UIImage?, appName: String, bgImage: UIImage? = nil, bgColor: UIColor? = nil) {
        if appImage == nil {
            fatalError("Invalid App Image.")
        }
        self.image = appImage
        self.appName = appName
        self.bgImage = bgImage
        self.bgColor = bgColor
    }
}

public struct AuthParameters {
    var name: String?
    var email: String!
    var password: String?
}

public class FractalAuth {

    init() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    public static func logout() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }

    public static var user: FractalUser? {
        get {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let userData = UserDefaults.standard.value(forKey: userKey) as? Data,
                let user = try? decoder.decode(FractalUser.self, from: userData) {
                return user
            } else {
                return nil
            }
        }
    }

    public static func setEnviroment(_ value: Environment, customUrl: String = "") {
        FractalRestAPI.shared.environment = value
        FractalRestAPI.shared.environment.setUrl(customUrl)
    }

    public static func presentSignIn(with customApp: CustomizeBundle? = nil) -> Promise<FractalUser> {
        let vc = FractalLoginViewController()
        vc.customizeBundle = customApp
        let nav = UINavigationController(rootViewController: vc)
        //nav.isNavigationBarHidden = true
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(nav, animated: true, completion: nil)
        }
        let errorPromise = Promise<FractalUser>.init(error: ErrorType.resultNil)
        let pendingPromise = Promise<FractalUser>.pending()
        vc.loginResult = pendingPromise
        
        return vc.loginResult?.promise ?? errorPromise
    }

    public static func signUp(with params: AuthParameters) -> Promise<FractalUser> {
        let credentials = Credentials(login: params.email, password: params.password, name: params.name)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return FractalRestAPI.shared.signUp(with: credentials)
    }

    /**
    This method presents the Fractal Sign Up View.
     - Parameter customApp: The customize bundle used to prepare the view for a specific app.
     - Returns: A Promise<User> that can return an User or Error
     */
    public static func presentSignUp(with customApp: CustomizeBundle? = nil) -> Promise<FractalUser> {
        let vc = SignUpViewController()
        vc.customizeBundle = customApp
        let nav = UINavigationController(rootViewController: vc)
        //nav.isNavigationBarHidden = true
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(nav, animated: true, completion: nil)
        }
        let errorPromise = Promise<FractalUser>.init(error: ErrorType.resultNil)
        let pendingPromise = Promise<FractalUser>.pending()
        vc.signUpResult = pendingPromise

        return vc.signUpResult?.promise ?? errorPromise
    }

    public static func presentProfile() {
        let vc = ProfileViewController()
        let nav = UINavigationController(rootViewController: vc)
        //nav.isNavigationBarHidden = true
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
}
