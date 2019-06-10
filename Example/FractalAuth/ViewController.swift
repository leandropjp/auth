//
//  ViewController.swift
//  FractalAuth
//
//  Created by leandropjp on 04/15/2019.
//  Copyright (c) 2019 leandropjp. All rights reserved.
//

import UIKit
import FractalAuth

class LoginController: UIViewController {

    let userInfoLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let btn1 = createButton(title: "Custom SignIn", method: #selector(presentCustomSignIn))
        let btn2 = createButton(title: "Default SignIn", method: #selector(presentDefaultSignIn))
        let btn3 = createButton(title: "Default SignUp", method: #selector(presentDefaultSignUp))
        let btn4 = createButton(title: "Custom SignUp", method: #selector(presentCustomSignUp))
        let btn5 = createButton(title: "Profile", method: #selector(presentProfile))

        let btn6 = createButton(title: "Get states", method: #selector(getStates))
        let btn7 = createButton(title: "Get cities", method: #selector(getCities))
        let btn8 = createButton(title: "Get units", method: #selector(getUnits))

        let stackView = UIStackView(arrangedSubviews: [btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = true
        stackView.distribution = .fillEqually
        view.addSubview(stackView)

        stackView.anchorCenterXToSuperview()
        stackView.anchorCenterYToSuperview()
        FractalAuth.setEnviroment(.staging)

        view.addSubview(userInfoLabel)
        userInfoLabel.anchorCenterXToSuperview()
        userInfoLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = FractalAuth.user
        let userName = user?.name ?? "-"
        let fractalId = user?.fractalId ?? 0
        userInfoLabel.numberOfLines = 0
        userInfoLabel.textAlignment = .center
        userInfoLabel.text = #"""
        Nome: \#(userName)
        Fractal ID: \#(fractalId)
        """#

    }

    func createButton(title: String, method: Selector) -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: method, for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true

        return btn
    }

    @objc func getCities() {

    }

    @objc func getUnits() {

    }

    @objc func presentCustomSignIn() {
        let bundle = CustomizeBundle(appImage: UIImage(named: "logo_ludie"), appName: "Ludie",
                                     bgImage: UIImage(named: ""), bgColor: .red)
        FractalAuth.presentSignIn(with: bundle)
            .done { (user) in
                print(user)
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }

    @objc func presentDefaultSignIn() {
        FractalAuth.presentSignIn()
            .done { (user) in
                print(user)
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }

    @objc func presentDefaultSignUp() {
        FractalAuth.presentSignUp()
            .done { (user) in
                print(user)
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }

    @objc func presentCustomSignUp() {
        let bundle = CustomizeBundle(appImage: UIImage(named: "logo_ludie"), appName: "Ludie",
                                     bgImage: UIImage(named: "bg"))
        FractalAuth.presentSignUp(with: bundle)
            .done { (user) in
                print(user)
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }

    @objc func presentProfile() {
        FractalAuth.presentProfile()
    }
}

