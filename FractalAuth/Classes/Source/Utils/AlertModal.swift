//
//  AlertModal.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 5/3/19.
//

import Foundation
import UIKit

class AlertModal: UIViewController {

    let modalView: CardView = {
        let view = CardView()
        view.backgroundColor = .white
        return view
    }()
    let modalText: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    var dismissCallback: (()->())?
    lazy var contentView = UIView()

    let bundle = Bundle(for: AlertModal.self).podResource(name: "FractalAuth")

    var scrollHeight: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(modalView)
        modalView.translatesAutoresizingMaskIntoConstraints = false
        modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        modalView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        modalView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true

        contentView.backgroundColor = .white

        modalView.addSubview(contentView)
        contentView.anchor(modalView.topAnchor, left: modalView.leftAnchor, bottom: modalView.bottomAnchor,
                          right: modalView.rightAnchor,
                          topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)

        let dismissBtn = UIButton()
        let closeImg = UIImage(named: "ic_close", in: bundle, compatibleWith: nil)
        dismissBtn.setImage(closeImg, for: .normal)
        dismissBtn.backgroundColor = .clear
        dismissBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        modalView.addSubview(dismissBtn)
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 8).isActive = true
        dismissBtn.rightAnchor.constraint(equalTo: modalView.rightAnchor, constant: -8).isActive = true
        dismissBtn.widthAnchor.constraint(equalToConstant: 32).isActive = true
        dismissBtn.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }

    func setupPasswordChange() {
        let infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .left
        infoLabel.text = "Alterar senha:"

        let oldPass = CustomTextField()
        oldPass.placeholder = "Senha atual..."
        let newPass1 = CustomTextField()
        newPass1.placeholder = "Nova senha..."
        let newPass2 = CustomTextField()
        newPass2.placeholder = "Confirmar senha..."

        let enterButton = ButtonWithShadow(type: .system)
        enterButton.setTitle("Alterar", for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.backgroundColor = UIColor(r: 190, g: 12, b: 35)
        enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        enterButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [infoLabel, oldPass, newPass1, newPass2, enterButton])
        stackView.axis = .vertical
        stackView.spacing = 16

        enterButton.sizeAnchor(widthConstant: 0, heightConstant: 40)
        oldPass.sizeAnchor(widthConstant: 0, heightConstant: 40)
        newPass1.sizeAnchor(widthConstant: 0, heightConstant: 40)
        newPass2.sizeAnchor(widthConstant: 0, heightConstant: 40)

        contentView.addSubview(stackView)
        stackView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8,
                         rightConstant: 8, widthConstant: 0, heightConstant: 0)

        view.layoutIfNeeded()
    }

    func setupAlertModal() {
        let stackView = UIStackView(arrangedSubviews: [modalText])
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        stackView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor, topConstant: 60, leftConstant: 8, bottomConstant: 60,
                         rightConstant: 8, widthConstant: 0, heightConstant: 0)

        modalText.text = "O link para recuperar sua senha foi enviado para seu email."
        modalText.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        view.layoutIfNeeded()
    }

    @objc func changePassword() {

    }

    @objc func dismissView() {
        self.dismiss(animated: true) {[weak self] in
            self?.dismissCallback?()
        }
    }
}

