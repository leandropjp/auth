//
//  ProfileInteractor.swift
//  Pods
//
//  Created by Leandro Paiva Andrade on 5/23/19.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfileInteractorInput {

}

protocol ProfileInteractorOutput: class {

}

class ProfileInteractor: ProfileInteractorInput
{
    weak var output: ProfileInteractorOutput?


}
