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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FractalAuth.setEnviroment(.staging)
        FractalAuth.presentSignIn()
            .done { (user) in
                print(user)
            }.catch { (error) in
                print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

