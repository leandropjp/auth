//
//  ForgetPasswordViewController.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 5/3/19.
//

import Foundation
import PromiseKit
import UIKit

class ForgetPasswordViewController: UIViewController {

    lazy var emailField: CustomTextField = {
        let tf = CustomTextField()
        tf.delegate = self
        tf.placeholder = "Fractal Id ou Email"
        return tf
    }()

    lazy var passwordLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.text = "Insira sua nova senha: "
        lbl.isHidden = true
        return lbl
    }()

    lazy var passwordField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Nova senha"
        tf.delegate = self
        tf.isHidden = true
        tf.isSecureTextEntry = true
        return tf
    }()

    lazy var confirmPasswordField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Confirmar nova senha"
        tf.delegate = self
        tf.isHidden = true
        tf.isSecureTextEntry = true
        return tf
    }()

    lazy var answerField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Resposta da pergunta secreta"
        tf.delegate = self
        tf.isHidden = true
        return tf
    }()

    lazy var answerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.isHidden = true
        lbl.text = "Pergunta secreta: "
        return lbl
    }()

    lazy var infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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


    lazy var logoView = UIImageView()
    lazy var bottomLogoView = UIImageView()
    var customizeBundle: CustomizeBundle?

    lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        return stack
    }()

    lazy var contentStackVIew: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .vertical
        return stack
    }()

    lazy var enterButton: ButtonWithShadow = {
        let btn = ButtonWithShadow()
        btn.setTitle("Enviar", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = redColor
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return btn
    }()


    // MARK: View lifecycle
    var fractalId = ""
    lazy var cardView: CardView = CardView()
    let bundle = Bundle(for: FractalLoginViewController.self).podResource(name: "FractalAuth")
    var mainStackTopAnchor: NSLayoutConstraint?
    var mainStackBottomAnchor: NSLayoutConstraint?

    let redColor = UIColor(r: 190, g: 12, b: 35)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .red
        self.title = "Recuperar senha"
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

        infoLabel.text = "Utilize seu Fractal Id ou E-mail para recuperar sua senha."

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

        //addLogo()
        addFields()
    }

    @objc func submit() {
        guard let email = emailField.text else {
            return
        }
        var isValidInfo = true
        if !email.isValidEmail() {
            emailField.tintColor = .red
            emailField.textColor = .red
            isValidInfo = false
        }
        if isValidInfo {
            let credentials = Credentials(login: email, password: nil)
            self.displayActivityIndicator(shouldDisplay: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                FractalRestAPI.shared.requestPassword(with: credentials)
                }.done {[weak self] (phrase) in
                    //Presente modal
                    if let phrase = phrase.name {
                        self?.fractalId = credentials.email ?? ""
                        self?.prepareRedefineView(with: phrase, fractalId: credentials.email ?? "")
                    } else {
                        self?.presentModal()
                    }
                    //self?.backAction()
                    self?.displayActivityIndicator(shouldDisplay: false)
                }.ensure {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch {[weak self] (error) in
                    print(error)
                    self?.displayActivityIndicator(shouldDisplay: false)
                    self?.infoLabel.text = "Verifique se o email ou Fractal ID está correto e tente novamente."
                    self?.infoLabel.textColor = .red
            }
        }
    }

    @objc func changePassword() {
        guard let answer = answerField.text,
        let password = passwordField.text,
        let confirmPassword = confirmPasswordField.text else {
            return
        }
        var isValidInfo = true
        if answer.isEmpty {
            answerField.tintColor = .red
            answerField.textColor = .red
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

        if isValidInfo {
            let resetPassword = ResetPasswordCredentials(fractalId: fractalId, secretAnswer: answer, password: password)
            self.displayActivityIndicator(shouldDisplay: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                FractalRestAPI.shared.requestResetPassword(with: resetPassword)
                }.done {[weak self] (phrase) in
                    //Presente modal

                    self?.presentModal()

                    //self?.backAction()
                    self?.displayActivityIndicator(shouldDisplay: false)
                }.ensure {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch {[weak self] (error) in
                    print(error)
                    self?.displayActivityIndicator(shouldDisplay: false)
                    self?.infoLabel.text = "Verifique se o email ou Fractal ID está correto e tente novamente."
                    self?.infoLabel.textColor = .red
            }
        }
    }

    func prepareRedefineView(with phrase: String, fractalId: String) {
        self.answerLabel.text = "Pergunta secreta: \(phrase)"
        self.emailField.isHidden = true
        self.passwordLabel.isHidden = false
        self.passwordField.isHidden = false
        self.confirmPasswordField.isHidden = false
        self.answerField.isHidden = false
        self.answerLabel.isHidden = false
        let stackView = UIStackView(arrangedSubviews: [answerLabel, answerField, passwordLabel,
                                                       passwordField, confirmPasswordField])
        stackView.axis = .vertical
        stackView.spacing = 16
        answerLabel.sizeAnchor(widthConstant: 0, heightConstant: 40)
        contentStackVIew.insertArrangedSubview(stackView, at: 2)
        answerField.sizeAnchor(widthConstant: 0, heightConstant: 30)
        confirmPasswordField.sizeAnchor(widthConstant: 0, heightConstant: 30)
        passwordField.sizeAnchor(widthConstant: 0, heightConstant: 30)

        self.infoLabel.isHidden = true

        enterButton.setTitle("Alterar", for: .normal)
        enterButton.removeTarget(self, action: #selector(submit), for: .touchUpInside)

        if UIDevice().screenType == .iPhones_5_5s_5c_SE {
            passwordField.font = UIFont.systemFont(ofSize: 12)
            answerField.font = UIFont.systemFont(ofSize: 12)
            confirmPasswordField.font = UIFont.systemFont(ofSize: 12)
            contentStackVIew.spacing = 10
            stackView.spacing = 8
        }
    }

    func presentModal() {
        let alert = AlertModal()
        alert.modalPresentationStyle = .custom
        alert.modalTransitionStyle = .crossDissolve //you can change this to do different animations
        alert.view.layer.speed = 1 //adjust this to animate at different speeds
        alert.setupAlertModal()

        alert.dismissCallback = {[weak self] in
            self?.backAction()
        }
        self.present(alert, animated: true, completion: nil)
    }

    func addFields() {

        var buttonFontSize: CGFloat = 16
        var stackViewSpacing: CGFloat = 16
        var defaultFontSize: CGFloat = 14
        var buttonSize: CGFloat = 40
        var bottomHeight: CGFloat = 55
        if UIDevice().screenType == .iPhones_5_5s_5c_SE {
            stackViewSpacing = 32
            buttonFontSize = 14
            defaultFontSize = 12
            buttonSize = 40
            bottomHeight = 40
        }

        let logoImg = UIImage(named: "fractal_horizontal", in: bundle, compatibleWith: nil)
        logoView.image = logoImg
        logoView.contentMode = .center

        bottomLogoView.image = logoImg
        bottomLogoView.contentMode = .scaleAspectFit
        bottomLogoView.heightAnchor.constraint(lessThanOrEqualToConstant: bottomHeight).isActive = true

        let helpLabel = UILabel()
        helpLabel.numberOfLines = 0
        helpLabel.textAlignment = .center

        let attrs = NSMutableAttributedString(string: "Está com problemas?\n",
                                              attributes: [.font: UIFont.systemFont(ofSize: defaultFontSize)])
        attrs.append(NSAttributedString(string: "Obtenha ajuda!", attributes: [.foregroundColor: redColor,
                                                                             .font: UIFont.boldSystemFont(ofSize: defaultFontSize)]))
        helpLabel.attributedText = attrs

        infoLabel.font = UIFont.systemFont(ofSize: defaultFontSize, weight: .medium)

        enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonFontSize)

        contentStackVIew = UIStackView(arrangedSubviews: [logoView, infoLabel, emailField,enterButton,
                                                       helpLabel, bottomLogoView])
        contentStackVIew.axis = .vertical
        contentStackVIew.spacing = stackViewSpacing

        emailField.sizeAnchor(widthConstant: 0, heightConstant: 40)
        enterButton.sizeAnchor(widthConstant: 0, heightConstant: buttonSize)

        view.addSubview(contentStackVIew)
        contentStackVIew.anchor(cardView.contentView.topAnchor, left: cardView.contentView.leftAnchor,
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
        self.navigationController?.popViewController(animated: true)
    }

    public static var bg: UIImage {
        let bundle = Bundle(for: self)

        return UIImage(named: "bg", in: bundle,compatibleWith: nil)!
    }

}

extension ForgetPasswordViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
