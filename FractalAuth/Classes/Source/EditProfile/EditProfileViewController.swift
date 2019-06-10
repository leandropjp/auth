//
//  EditProfileViewController.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 5/23/19.
//

import Foundation
import UIKit
import LBTATools

class EditProfileViewController: UIViewController {

    let bundle = Bundle(for: EditProfileViewController.self).podResource(name: "FractalAuth")

    lazy var profileImage: CircularImageView = {
        let iv = CircularImageView(width: 60)
        iv.image =  UIImage(named: "ic_profile_pic", in: bundle, compatibleWith: nil)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#E9E9E9")
        let user = FractalAuth.user
        let profileImageBtn = UIButton(title: "Trocar foto", titleColor: UIColor(hexString: "#C50A27"), font: .systemFont(ofSize: 14, weight: .semibold), backgroundColor: .clear, target: self, action: #selector(changePhoto))
        profileImageBtn.setTitle("Trocar foto", for: .normal)

        let photoStack = UIView().stack(profileImage, profileImageBtn,
                                        spacing: 4,
                                        alignment: .center).padBottom(8).padTop(8)
        photoStack.addBackground(color: .white)

        profileImage.sizeAnchor(widthConstant: 60, heightConstant: 60)
        profileImageBtn.sizeAnchor(widthConstant: 120, heightConstant: 40)

        let nameStack = createFieldStack(title: "Nome", placeholder: "Nome", content: user?.name)
        let emailStack = createFieldStack(title: "Email", placeholder: "Email", content: user?.email)

        let saveBtn = UIButton(title: "Salvar alterações", titleColor: .white, font: .systemFont(ofSize: 16, weight: .semibold), backgroundColor: UIColor(hexString: "#C50A27"), target: nil, action: nil)
        saveBtn.layer.cornerRadius = 8

        let mainStack = UIView().stack(photoStack,
                                       nameStack, emailStack, UIView().stack(saveBtn.withHeight(50)).withMargins(UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)) , UIView(),
                                       spacing: 16)

        view.addSubview(mainStack)
        mainStack.fillSuperview()

        addBackButton()
        self.title = "Editar perfil"
    }

    @objc func changePhoto() {

    }

    func createFieldStack(title: String, placeholder: String, content: String?) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(hexString: "#424141")

        let field = IndentedTextField(placeholder: placeholder, padding: 12, cornerRadius: 8)
        field.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        field.text = content
        field.backgroundColor = .white

        let view = UIView().stack(titleLabel,field.withHeight(50), spacing: 4).withMargins(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        return view
    }

    func addBackButton() {
        let backImg = UIImage(named: "icon-back-gray", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        //self.navigationController?.addBackButton(with: backImg)
        let backButton = UIButton(type: .custom)
        backButton.tintColor = UIColor.black
        backButton.setImage(backImg?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle(nil, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
