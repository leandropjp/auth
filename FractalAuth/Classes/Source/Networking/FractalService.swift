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
    var token: String? = "15f251b6fa-38456d09bb-1566319964"

    func signUp(with params: Credentials) -> Promise<FractalUser> {
        let url = Router.user.urlWith(path: "")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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


    func loginWithFacebook(params: AuthParameters) -> Promise<FractalUser> {
        let url = Router.user.urlWith(path: "facebook_auth")
        var parameters = [String:Any]()
        parameters["facebook_uuid"] = params.facebookUuid
        parameters["facebook_token"] = params.facebookToken
        parameters["user_application_id"] = params.appId
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .post,
                                                                          urlString: url,
                                                                          params: parameters)).validate()
            }.tap {
                print($0)
            }.get {
                UserDefaults.standard.set($0.data, forKey: userKey)
            }
            .compactMap {
                try decoder.decode(FractalUser.self, from: $0.data)
        }

    }

    func signUpWithFacebook(params: AuthParameters) -> Promise<FractalUser> {
        let url = Router.user.urlWith(path: "")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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

    func getUserId(from email: String) -> Promise<FractalUser> {
        let url = Router.user.urlWith(path: "names")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let params: [String: Any] = ["emails": email]
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .post,
                                                                          urlString: url,
                                                                          params: params)).validate()
            }.tap {
                print($0)
            }.get {
                UserDefaults.standard.set($0.data, forKey: userKey)
            }.compactMap {
                try decoder.decode(Response<FractalUser>.self, from: $0.data).data?.first
        }
    }

    func updateUserInformation(params: AuthParameters) -> Promise<FractalUser> {
        let url = Router.user.urlWith(path: params.userId ?? "")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let parameters:[String: Any] = ["facebook_uuid" : params.facebookUuid ?? "",
                                        "photo_url": params.photoUrl ?? "",
                                        "facebook_token": params.facebookToken ?? ""]
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .put,
                                                                          urlString: url,
                                                                          params: parameters)).validate()
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

    func makeUrlRequest(httpMethod: HTTPMethod = .get, urlString: String, params: JSON? = nil) throws -> URLRequest {
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        rq.httpMethod = "\(httpMethod)".uppercased()
        rq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        rq.addValue("application/json", forHTTPHeaderField: "Accept")

        for header in Router.headers {
            rq.setValue(header.value, forHTTPHeaderField: header.key)
        }

        if httpMethod == .post || httpMethod == .patch || httpMethod == .put {
            if let json = params {
                rq.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            }
        }

        return rq
    }
}

extension URLRequest {

    public var curlString: String {
        // Logging URL requests in whole may expose sensitive data,
        // or open up possibility for getting access to your user data,
        // so make sure to disable this feature for production builds!
        #if !DEBUG
        return ""
        #else
        var result = "curl -k "

        if let method = httpMethod {
            result += "-X \(method) \\\n"
        }

        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                result += "-H \"\(header): \(value)\" \\\n"
            }
        }

        if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
            result += "-d '\(string)' \\\n"
        }

        if let url = url {
            result += url.absoluteString
        }

        return result
        #endif
    }
}
