//
//  LoginInteractor.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 4/16/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginInteractorInput {

}

protocol LoginInteractorOutput: class {

}

class LoginInteractor: LoginInteractorInput
{
    weak var output: LoginInteractorOutput?


}
