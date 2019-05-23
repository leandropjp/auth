//
//  ProfileConfigurator.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 5/23/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

class ProfileModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? ProfileViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: ProfileViewController) {

        let router = ProfileRouter()
        router.view = viewController

        let presenter = ProfilePresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = ProfileInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
