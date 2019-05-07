//
//  SignUpViewController.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 5/3/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PromiseKit

protocol SignUpViewInput: class {

}

protocol SignUpViewOutput {
    
}

class SignUpViewController: UIViewController, SignUpViewInput
{

    lazy var nameField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Nome completo"
        return tf
    }()

    lazy var emailField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Email"
        return tf
    }()

    lazy var passwordField: CustomTextField = {
        let tf = CustomTextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "Senha"
        tf.addToggleSecurityButton()
        return tf
    }()

    lazy var confirmPasswordField: CustomTextField = {
        let tf = CustomTextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "Confirmar senha"
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


    lazy var cardLogoView = UIImageView()
    lazy var bottomLogoView = UIImageView()
    var customizeBundle: CustomizeBundle?
    var isFromLogin = false
    lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        return stack
    }()

    var signUpResult: (promise: Promise<User>, resolver: Resolver<User>)?
    var test: Promise<User>?
    var output:  SignUpViewOutput!

    // MARK: Object lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let configurator = SignUpModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let configurator = SignUpModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        let configurator = SignUpModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    // MARK: View lifecycle

    lazy var cardView: CardView = CardView()
    let bundle = Bundle(for: SignUpViewController.self).podResource(name: "FractalAuth")
    var mainStackTopAnchor: NSLayoutConstraint?
    var mainStackBottomAnchor: NSLayoutConstraint?

    let redColor = UIColor(r: 190, g: 12, b: 35)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .red
        self.title = "Cadastro"
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

        cardLogoView.isHidden = true
        if let appName = bundle.appName {
            infoLabel.text = "Crie uma Conta Fractal para prosseguir para o \(appName)."
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

    func setupView() {
        //let img1 = UIImage(named: "bg", in: bundle, compatibleWith: nil)

        view.backgroundColor = .white
        //bgImageView = UIImageView(image: img1)

        view.addSubview(bgImageView)
        bgImageView.fillSuperview()
        let maskView = UIView()
        maskView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(maskView)
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
        addBackButton()

        addFields()
    }

    @objc func hasAccountTapped() {
        if !isFromLogin {
            let vc = LoginViewController()
            vc.customizeBundle = customizeBundle
            vc.isFromSignUp = true
            vc.loginResult = signUpResult
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func submitLogin() {
        guard let email = emailField.text, let password = passwordField.text,
            let confirmPassword = confirmPasswordField.text, let name = nameField.text else {
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

        if !confirmPassword.isValidPassword() && confirmPassword != password {
            confirmPasswordField.tintColor = .red
            confirmPasswordField.textColor = .red
            isValidInfo = false
        }

        if !name.isValidName() {
            nameField.tintColor = .red
            nameField.textColor = .red
            isValidInfo = false
        }

        if isValidInfo {
            let credentials = Credentials(login: email, password: password.toBase64())
            self.displayActivityIndicator(shouldDisplay: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                FractalRestAPI.shared.login(with: credentials)
                }.done {[weak self] (user) in
                    self?.signUpResult?.resolver.fulfill(user)
                    self?.backAction()
                }.ensure {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch {[weak self] (error) in
                    print(error)
                    self?.displayActivityIndicator(shouldDisplay: false)
                    self?.infoLabel.text = "Verifique se os dados inseridos estão corretos."
                    self?.infoLabel.textColor = .red
            }
        }
    }

    func addFields() {

        var buttonFontSize: CGFloat = 16
        var stackViewSpacing: CGFloat = 16
        var defaultFontSize: CGFloat = 14
        var buttonSize: CGFloat = 40
        var bottomHeight: CGFloat = 55
        var logoHeight: CGFloat = 0
        var fieldHeight: CGFloat = 40
        if UIDevice().screenType == .iPhones_5_5s_5c_SE {
            stackViewSpacing = 8
            buttonFontSize = 14
            defaultFontSize = 12
            buttonSize = 38
            bottomHeight = 35
            logoHeight = 60
            fieldHeight = 35
        }

        let logoImg = UIImage(named: "fractal_horizontal", in: bundle, compatibleWith: nil)
        cardLogoView.image = logoImg
        cardLogoView.contentMode = .center
        if logoHeight > 0 {
            logoImageView.heightAnchor.constraint(equalToConstant: logoHeight).isActive = true
            logoImageView.contentMode = .scaleAspectFit
        }

        bottomLogoView.image = logoImg
        bottomLogoView.contentMode = .scaleAspectFit
        bottomLogoView.heightAnchor.constraint(lessThanOrEqualToConstant: bottomHeight).isActive = true

        let enterButton = ButtonWithShadow()
        enterButton.setTitle("Cadastrar", for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.backgroundColor = redColor
        enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonFontSize)
        enterButton.addTarget(self, action: #selector(submitLogin), for: .touchUpInside)

        let signupLabel = UILabel()
        signupLabel.numberOfLines = 0
        signupLabel.textAlignment = .center

        let attrs = NSMutableAttributedString(string: "Já possui uma conta Fractal?\n",
                                              attributes: [.font: UIFont.systemFont(ofSize: defaultFontSize)])
        attrs.append(NSAttributedString(string: "Entrar", attributes: [.foregroundColor: redColor,
                                                                             .font: UIFont.boldSystemFont(ofSize: defaultFontSize)]))

        signupLabel.attributedText = attrs
        signupLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hasAccountTapped))
        signupLabel.addGestureRecognizer(tap)

        infoLabel.font = UIFont.systemFont(ofSize: defaultFontSize, weight: .medium)

        let stackView = UIStackView(arrangedSubviews: [cardLogoView, infoLabel, errorLabel,nameField, emailField,
                                                       passwordField, confirmPasswordField, enterButton, signupLabel, bottomLogoView])
        stackView.axis = .vertical
        stackView.spacing = stackViewSpacing

        nameField.sizeAnchor(widthConstant: 0, heightConstant: fieldHeight)
        confirmPasswordField.sizeAnchor(widthConstant: 0, heightConstant: fieldHeight)
        emailField.sizeAnchor(widthConstant: 0, heightConstant: fieldHeight)
        passwordField.sizeAnchor(widthConstant: 0, heightConstant: fieldHeight)
        enterButton.sizeAnchor(widthConstant: 0, heightConstant: buttonSize)

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
        if isFromLogin && !(signUpResult?.promise.isResolved ?? true) {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.signUpResult?.resolver.reject(ErrorType.resultNil)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }

    }

    public static var bg: UIImage {
        let bundle = Bundle(for: self)

        return UIImage(named: "bg", in: bundle,compatibleWith: nil)!
    }

    deinit {
        print("DENINIT")
    }

}
