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
        tf.delegate = self
        tf.placeholder = "Fractal Id ou Email"
        tf.delegate = self
        return tf
    }()

    lazy var passwordField: CustomTextField = {
        let tf = CustomTextField()
        tf.delegate = self
        tf.isSecureTextEntry = true
        tf.placeholder = "Senha"
        tf.addToggleSecurityButton()
        tf.delegate = self
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

    lazy var infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()

    lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIView.ContentMode.center
        return iv
    }()

    lazy var bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        return iv
    }()

    lazy var maskView = UIView()

    lazy var logoView = UIImageView()
    lazy var bottomLogoView = UIImageView()
    var customizeBundle: CustomizeBundle?

    lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        return stack
    }()

    let enterButton = ButtonWithShadow()

    var loginResult: (promise: Promise<User>, resolver: Resolver<User>)?
    var isFromSignUp = false

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
    var mainStackTopAnchor: NSLayoutConstraint?
    var mainStackBottomAnchor: NSLayoutConstraint?

    let redColor = UIColor(r: 190, g: 12, b: 35)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .red
        setupView()

        if let bundle = self.customizeBundle {
            self.prepareViewForCustomApp(with: bundle)
        }
    }

    func prepareViewForCustomApp(with bundle: CustomizeBundle) {

        if UIDevice().isiPhoneXrAndAbove {
            mainStackTopAnchor?.isActive = false
            mainStackBottomAnchor?.isActive = false
            mainStackView.spacing = 32
            mainStackView.anchorCenterYToSuperview()
        }

        logoImageView.image = bundle.image
        mainStackView.insertArrangedSubview(logoImageView, at: 0)
        logoView.isHidden = true

        if let appName = bundle.appName {
            infoLabel.text = "Entre com sua conta Fractal para prosseguir para o \(appName)."
        } else {
            infoLabel.isHidden = true
        }

        if let bgImage = bundle.bgImage {
            bgImageView.image = bgImage
            bgImageView.alpha = 0.6
        } else {
            bgImageView.isHidden = true
        }

        if let bgColor = bundle.bgColor {
            view.backgroundColor = bgColor
        }

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(bgImageView)
        bgImageView.fillSuperview()

        maskView.backgroundColor = UIColor.white.withAlphaComponent(0.6)

        bgImageView.insertSubview(maskView, at: 0)
        maskView.fillSuperview()

        mainStackView.addArrangedSubview(cardView)
        view.addSubview(mainStackView)
        mainStackView.anchor(nil, left: view.leftAnchor, bottom: nil,
                             right: view.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 32,
                             rightConstant: 32, widthConstant: 0, heightConstant: 0)
        mainStackTopAnchor = mainStackView.topAnchor.constraint(equalTo: view.compatibleSafeAreaLayoutGuide.topAnchor, constant: 16)
        mainStackTopAnchor?.isActive = true

        mainStackBottomAnchor = mainStackView.bottomAnchor.constraint(equalTo: view.compatibleSafeAreaLayoutGuide.bottomAnchor, constant: -32)
        mainStackBottomAnchor?.isActive = true
        self.navigationItem.title = "Login"
        addBackButton()

        //addLogo()
        addFields()
    }

    @objc func forgetPasswordTapped() {
        let vc = ForgetPasswordViewController()
        vc.customizeBundle = customizeBundle
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func createAccountTapped() {
        if !isFromSignUp {
            let vc = SignUpViewController()
            vc.customizeBundle = customizeBundle
            vc.isFromLogin = true
            vc.signUpResult = loginResult
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
                    self?.loginResult?.resolver.fulfill(user)
                    self?.backAction()
                }.ensure {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch {[weak self] (error) in
                    print(error)
                    self?.displayActivityIndicator(shouldDisplay: false)
                    self?.infoLabel.text = "Verifique suas credenticias e tente novamente."
                    self?.infoLabel.textColor = .red
            }
        }
    }

    func addFields() {

        var buttonFontSize: CGFloat = 16
        var stackViewSpacing: CGFloat = 16
        var defaultFontSize: CGFloat = 14
        if UIDevice().screenType == .iPhones_5_5s_5c_SE {
            stackViewSpacing = 10
            buttonFontSize = 14
            defaultFontSize = 12
        }

        let logoImg = UIImage(named: "fractal_horizontal", in: bundle, compatibleWith: nil)
        logoView.image = logoImg
        logoView.contentMode = .center

        bottomLogoView.image = logoImg
        bottomLogoView.contentMode = .scaleAspectFit
        bottomLogoView.heightAnchor.constraint(lessThanOrEqualToConstant: 55).isActive = true

        let forgetPasswordBtn = UIButton()
        forgetPasswordBtn.setTitle("Esqueci minha senha", for: .normal)
        forgetPasswordBtn.setTitleColor(redColor, for: .normal)
        forgetPasswordBtn.titleLabel?.font = UIFont.systemFont(ofSize: defaultFontSize)
        forgetPasswordBtn.addTarget(self, action: #selector(forgetPasswordTapped), for: .touchUpInside)

        let passwordView = UIView()
        passwordView.addSubview(passwordField)
        passwordField.anchor(passwordView.topAnchor, left: passwordView.leftAnchor, bottom: nil,
                             right: passwordView.rightAnchor, topConstant: 0, leftConstant: 0,
                             bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        passwordView.addSubview(forgetPasswordBtn)
        forgetPasswordBtn.anchor(passwordField.bottomAnchor, left: nil, bottom: passwordView.bottomAnchor,
                                 right: passwordField.rightAnchor, topConstant: 4, leftConstant: 0,
                                 bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)


        enterButton.setTitle("Entrar", for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.backgroundColor = redColor
        enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonFontSize)
        enterButton.addTarget(self, action: #selector(submitLogin), for: .touchUpInside)

        let signupLabel = UILabel()
        signupLabel.numberOfLines = 0
        signupLabel.textAlignment = .center

        let attrs = NSMutableAttributedString(string: "Não tem conta Fractal?\n",
                                              attributes: [.font: UIFont.systemFont(ofSize: defaultFontSize)])
        attrs.append(NSAttributedString(string: "Cadastre-se!", attributes: [.foregroundColor: redColor,
                                                                             .font: UIFont.boldSystemFont(ofSize: defaultFontSize)]))
        signupLabel.attributedText = attrs
        signupLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(createAccountTapped))
        signupLabel.addGestureRecognizer(tap)
        
        infoLabel.font = UIFont.systemFont(ofSize: defaultFontSize, weight: .medium)

        let stackView = UIStackView(arrangedSubviews: [logoView, infoLabel, errorLabel, emailField, passwordView, enterButton, signupLabel, bottomLogoView])
        stackView.axis = .vertical
        stackView.spacing = stackViewSpacing

        emailField.sizeAnchor(widthConstant: 0, heightConstant: 40)
        passwordField.sizeAnchor(widthConstant: 0, heightConstant: 40)
        enterButton.sizeAnchor(widthConstant: 0, heightConstant: 44)

        view.addSubview(stackView)
        stackView.anchor(cardView.contentView.topAnchor, left: cardView.contentView.leftAnchor,
                         bottom: cardView.contentView.bottomAnchor, right: cardView.contentView.rightAnchor,
                         topConstant: 16, leftConstant: 32, bottomConstant: 16, rightConstant: 32,
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
        if isFromSignUp && !(loginResult?.promise.isResolved ?? true) {
            
            self.navigationController?.popViewController(animated: true)
        } else {
            self.loginResult?.resolver.reject(ErrorType.resultNil)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }


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

extension LoginViewController {

//    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == emailField {
//            if validateEmailField() {
//                passwordField.becomeFirstResponder()
//            } else {
//                emailField.tintColor = .red
//                emailField.textColor = .red
//            }
//        }
//
//        if textField == passwordField {
//            if validatePasswordField() {
//                enterButton.sendActions(for: .touchUpInside)
//                passwordField.resignFirstResponder()
//            } else {
//                passwordField.tintColor = .red
//                passwordField.textColor = .red
//            }
//        }
//
//        return true
//    }

    func validateEmailField() -> Bool {
        if let email = emailField.text, !email.isValidEmail() || email.isEmpty {
            return false
        } else {
            return true
        }
    }

    func validatePasswordField() -> Bool {
        if let password = passwordField.text, !password.isValidPassword() || password.isEmpty {
            return false
        } else {
            return true
        }
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
