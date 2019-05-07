//
//  SignUpConfigurator.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 5/3/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

class SignUpModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? SignUpViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: SignUpViewController) {

        let router = SignUpRouter()
        router.view = viewController

        let presenter = SignUpPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = SignUpInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
