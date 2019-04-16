//
//  LoginViewController.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 4/16/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PromiseKit

protocol LoginViewInput: class {

}

protocol LoginViewOutput {
    func doLogin(with email: String, password: String)
}

class LoginViewController: UIViewController, LoginViewInput
{
    var output:  LoginViewOutput!

    lazy var emailField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Fractal Id ou Email"
        return tf
    }()

    lazy var passwordField: CustomTextField = {
        let tf = CustomTextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "Senha"
        tf.addToggleSecurityButton()
        return tf
    }()

    lazy var errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.isHidden = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()

    var loginResult = Promise<User>.pending()

    // MARK: Object lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let configurator = LoginModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let configurator = LoginModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        let configurator = LoginModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    // MARK: View lifecycle

    lazy var cardView: CardView = CardView()
    let bundle = Bundle(for: LoginViewController.self).podResource(name: "FractalAuth")

    let redColor = UIColor(r: 190, g: 12, b: 35)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .red

        let img1 = UIImage(named: "bg", in: bundle, compatibleWith: nil)

        view.backgroundColor = .white
        let bg = UIImageView(image: img1)

        view.addSubview(bg)
        bg.fillSuperview()
        view.addSubview(cardView)
        cardView.anchor(view.compatibleSafeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                        right: view.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 32,
                        rightConstant: 32, widthConstant: 0, heightConstant: 0)
        self.navigationItem.title = "Login"
        addBackButton()

        //addLogo()
        addFields()
    }

    @objc func submitLogin() {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        var isValidInfo = true
        if !email.isValidEmail() {
            emailField.tintColor = .red
            emailField.textColor = .red
            isValidInfo = false
        }

        if !password.isValidPassword() {
            passwordField.tintColor = .red
            passwordField.textColor = .red
            isValidInfo = false
        }

        if isValidInfo {
            let credentials = Credentials(login: email, password: password.toBase64())
            self.displayActivityIndicator(shouldDisplay: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                FractalRestAPI.shared.login(with: credentials)
                }.done {[weak self] (user) in
                    self?.loginResult.resolver.fulfill(user)
                    self?.backAction()
                }.ensure {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch {[weak self] (error) in
                    print(error)
                    self?.displayActivityIndicator(shouldDisplay: false)
                    self?.errorLabel.text = "Verifique suas credenticias e tente novamente."
                    self?.errorLabel.isHidden = false
            }
        }
    }

    func addFields() {

        let logoImg = UIImage(named: "fractal_horizontal", in: bundle, compatibleWith: nil)
        let logoView = UIImageView(image: logoImg)
        logoView.contentMode = .center

        let forgetPasswordBtn = UIButton()
        forgetPasswordBtn.setTitle("Esqueci minha senha", for: .normal)
        forgetPasswordBtn.setTitleColor(redColor, for: .normal)
        forgetPasswordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        let passwordView = UIView()
        passwordView.addSubview(passwordField)
        passwordField.anchor(passwordView.topAnchor, left: passwordView.leftAnchor, bottom: nil, right: passwordView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        passwordView.addSubview(forgetPasswordBtn)
        forgetPasswordBtn.anchor(passwordField.bottomAnchor, left: nil, bottom: passwordView.bottomAnchor, right: passwordField.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)

        let enterButton = ButtonWithShadow()
        enterButton.setTitle("Entrar", for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.backgroundColor = redColor
        enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        enterButton.addTarget(self, action: #selector(submitLogin), for: .touchUpInside)

        let infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center

        let attrs = NSMutableAttributedString(string: "Não tem conta Fractal?\n",
                                              attributes: [.font: UIFont.systemFont(ofSize: 14)])
        attrs.append(NSAttributedString(string: "Cadastre-se!", attributes: [.foregroundColor: redColor,
                                                                             .font: UIFont.boldSystemFont(ofSize: 14)]))
        infoLabel.attributedText = attrs

        let stackView = UIStackView(arrangedSubviews: [logoView, errorLabel, emailField, passwordView, enterButton, infoLabel])
        stackView.axis = .vertical
        stackView.spacing = 20

        emailField.sizeAnchor(widthConstant: 0, heightConstant: 40)
        passwordField.sizeAnchor(widthConstant: 0, heightConstant: 40)
        enterButton.sizeAnchor(widthConstant: 0, heightConstant: 44)

        view.addSubview(stackView)
        stackView.anchor(cardView.contentView.topAnchor, left: cardView.contentView.leftAnchor,
                         bottom: cardView.contentView.bottomAnchor, right: cardView.contentView.rightAnchor,
                         topConstant: 32, leftConstant: 32, bottomConstant: 32, rightConstant: 32,
                         widthConstant: 0, heightConstant: 0)
    }

    func addBackButton() {
        let backImg = UIImage(named: "icon-back-gray", in: bundle, compatibleWith: nil)
        self.navigationController?.addBackButton(with: backImg)
        let backButton = UIButton(type: .custom)
        backButton.tintColor = UIColor.black
        backButton.setImage(backImg?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle(nil, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc private func backAction() {
        self.loginResult.resolver.reject(ErrorType.resultNil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    public static var bg: UIImage {
        let bundle = Bundle(for: self)

        return UIImage(named: "bg", in: bundle,compatibleWith: nil)!
    }

    deinit {
        //loginResult
        //loginResult = nil
    }
}
//
//extension Promise {
//    func timeout(seconds: TimeInterval) -> Promise<T> {
//        let pending = Promise<T>.pending()
//        after(seconds: seconds).done {
//            pending.resolver.reject(TimeoutError())
//        }
//        pipe(to: pending.resolver.resolve)
//        return pending.promise
//    }
//}
