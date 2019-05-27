//
//  ProfileViewController.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 5/23/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfileViewInput: class {

}

protocol ProfileViewOutput {
    
}

class ProfileViewController: UIViewController, ProfileViewInput
{
    var output:  ProfileViewOutput!
    lazy var cardView: CardView = CardView()
    lazy var profileImage: UIImageView = {
        let iv = UIImageView()

        iv.contentMode = .scaleAspectFill
        return iv
    }()

    lazy var userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    lazy var userEmailLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lbl.textAlignment = .center
        lbl.textColor = UIColor(hexString: "#424141")
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    let bundle = Bundle(for: ProfileViewController.self).podResource(name: "FractalAuth")
    // MARK: Object lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let configurator = ProfileModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let configurator = ProfileModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        let configurator = ProfileModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: self)
    }

    // MARK: View lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#E9E9E9")
        let bgView = UIImageView(image: UIImage(named: "bg", in: bundle, compatibleWith: nil))
        bgView.contentMode = .scaleAspectFill
        view.addSubview(bgView)
        bgView.fillSuperview()
        view.addSubview(cardView)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        var sidePadding: CGFloat = 32
        if UIDevice().screenType == .iPhones_5_5s_5c_SE {
            sidePadding = 16
//            cardView.topAnchor.constraint(equalTo: view.compatibleSafeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
//            cardView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16).isActive = true
        } else {

        }

        cardView.anchorCenterYToSuperview()
        cardView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sidePadding).isActive = true
        cardView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sidePadding).isActive = true

//        cardView.fillSuperview()

        let labelsStack = UIStackView(arrangedSubviews: [userNameLabel, userEmailLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        let profileStack = UIStackView(arrangedSubviews: [profileImage, labelsStack])
        profileStack.alignment = .center
        profileStack.axis = .vertical
        profileStack.spacing = 13
        profileImage.sizeAnchor(widthConstant: 60, heightConstant: 60)
        profileImage.layer.cornerRadius = 60 / 2
        let profileBtn = createButton(title: "Editar perfil")
        profileBtn.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        let configBtn = createButton(title: "Configurações")
        //let nameBtn = createButton(title: "Alterar nome")
        profileBtn.sizeAnchor(widthConstant: 0, heightConstant: 44)
        let buttonsStack = UIStackView(arrangedSubviews: [profileBtn, configBtn])
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 16

        let logoImg = UIImage(named: "fractal_horizontal", in: bundle, compatibleWith: nil)
        let logoImageView = UIImageView(image: logoImg)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 55).isActive = true
        profileImage.image = UIImage(named: "ic_profile_pic", in: bundle, compatibleWith: nil)

        let mainStack = UIStackView(arrangedSubviews: [profileStack, buttonsStack, logoImageView])
        mainStack.axis = .vertical
        mainStack.spacing = 26

        cardView.addSubview(mainStack)
        mainStack.anchor(cardView.topAnchor, left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: cardView.rightAnchor,
                         topConstant: 32, leftConstant: 32, bottomConstant: 32, rightConstant: 32,
                         widthConstant: 0, heightConstant: 0)

        let user = FractalAuth.user
        userNameLabel.text = user?.name
        userEmailLabel.text = user?.email

        addBackButton()
        setupNavBar()
    }

    @objc func editProfile() {
        let vc = EditProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func createButton(title: String) -> UIButton {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(hexString: "#C50A27")
        btn.layer.cornerRadius = 8
        return btn
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
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .red
        title = "Minha conta"
    }
}
