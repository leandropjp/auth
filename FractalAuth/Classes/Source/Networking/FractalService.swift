//
//  FractalService.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 4/16/19.
//

import Foundation
import PromiseKit

public enum HTTPMethod {
    case post
    case put
    case patch
    case delete
    case get
}

let userKey = "userKey"
let userPhrase = "userPhraseKey"
typealias JSON = [String:Any]

class FractalRestAPI {

    static let shared = FractalRestAPI()

    var environment: Environment = .production
    var token: String?

    func signUp(with params: Credentials) -> Promise<FractalUser> {
        let url = Router.user.urlWith(path: "")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .post,
                                                                          urlString: url,
                                                                          obj: params)).validate()
            }.tap {
                print($0)
            }.get {
                UserDefaults.standard.set($0.data, forKey: userKey)
            }.compactMap {
                try decoder.decode(FractalUser.self, from: $0.data)
        }
    }

    func login(with params: Credentials) -> Promise<FractalUser> {
        let url = Router.user.urlWith(path: "auth")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .post,
                                                                          urlString: url,
                                                                          obj: params)).validate()
            }.tap {
                print($0)
            }.get {
                UserDefaults.standard.set($0.data, forKey: userKey)
            }.compactMap {
                try decoder.decode(FractalUser.self, from: $0.data)
        }
    }

    func requestPassword(with params: Credentials) -> Promise<UserPhrase> {
        let url = Router.user.urlWith(path: "recover_password")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .post,
                                                                          urlString: url,
                                                                          obj: params)).validate()
            }.tap {
                print($0)
            }.get {
                UserDefaults.standard.set($0.data, forKey: userPhrase)
            }.compactMap {
                if let response = $0.response as? HTTPURLResponse {
                    if response.statusCode != 204 {
                        return try decoder.decode(FractalUser.self, from: $0.data).userPhrase
                    }
                }
                return UserPhrase()
        }

    }

    func requestResetPassword(with obj: ResetPasswordCredentials) -> Promise<UserPhrase> {
        let url = Router.user.urlWith(path: "reset_password")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .post,
                                                                          urlString: url,
                                                                          obj: obj))
            }.tap {
                print($0)
            }.get {
                UserDefaults.standard.set($0.data, forKey: userPhrase)
            }.compactMap {
                return try decoder.decode(FractalUser.self, from: $0.data).userPhrase
        }
    }

    func makeUrlRequest<T: Codable>(httpMethod: HTTPMethod = .get, urlString: String, params: JSON? = nil,
                                    obj: T? = nil as T?) throws -> URLRequest {
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        rq.httpMethod = "\(httpMethod)"
        rq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        rq.addValue("application/json", forHTTPHeaderField: "Accept")

        for header in Router.headers {
            rq.setValue(header.value, forHTTPHeaderField: header.key)
        }

        if httpMethod == .post || httpMethod == .patch || httpMethod == .put {
            if let item = obj {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                rq.httpBody = try encoder.encode(item)
            } else if let json = params {
                rq.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            }
        }

        return rq
    }
}

