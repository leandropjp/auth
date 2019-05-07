//
//  SignUpPresenter.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 5/3/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignUpModuleInput: class {

}

class SignUpPresenter: SignUpModuleInput, SignUpViewOutput, SignUpInteractorOutput {
    weak var view: SignUpViewInput!
    var interactor: SignUpInteractorInput!
    var router: SignUpRouterInput!

}
