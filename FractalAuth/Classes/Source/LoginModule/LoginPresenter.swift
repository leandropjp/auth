//
//  LoginPresenter.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 4/16/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginModuleInput: class {

}

class LoginPresenter: LoginModuleInput, LoginViewOutput {
    weak var view: LoginViewInput!
    var router: LoginRouterInput!

    func doLogin(with email: String, password: String) {
        
    }

}
