//
//  LoginConfigurator.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 4/16/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

class LoginModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? FractalLoginViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: FractalLoginViewController) {

        let router = LoginRouter()
        router.view = viewController

        let presenter = LoginPresenter()
        presenter.view = viewController
        presenter.router = router

        viewController.output = presenter
    }

}
