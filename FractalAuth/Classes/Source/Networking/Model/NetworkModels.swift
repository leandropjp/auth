//
//  NetworkModels.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 5/7/19.
//

import Foundation

public struct Credentials: Codable {
    var email: String?
    var password: String?
    var name: String?

    init(login: String, password: String?) {
        self.email = login
        self.password = password
        self.name = nil
    }

    init(login: String, password: String?, name: String?) {
        self.email = login
        self.password = password
        self.name = name
    }
}

public struct User: Codable {
    public var id: Int?
    public var name: String?
    public var email: String?
    public var fractalId: Int?
    public var token: String?
    public var genre: String?
    public var birthday: String?
    public var photoUrl: String?
    public var active: Bool?
    public var facebookUuid: String?

    public var userPhrase: UserPhrase?

    private var password: String?
    private var phraseAnswer: String?
    private var facebookToken: String?
    private var userUserPhraseId: Int?
}

public class UserPhrase: Codable {
    public var id: Int?
    public var name: String?

    public init(){}
}

public struct ResetPasswordCredentials: Codable {
    var fractalId: String?
    var secretAnswer: String?
    var password: String?
}
