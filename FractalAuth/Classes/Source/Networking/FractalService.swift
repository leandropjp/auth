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

typealias JSON = [String:Any]

class FractalRestAPI {

    static let shared = FractalRestAPI()

    var environment: Environment = .production
    var token: String?

    func login(with params: Credentials) -> Promise<User> {
        let url = Router.user.urlWith(path: "auth")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .post,
                                                                          urlString: url,
                                                                          obj: params)).validate()
            }.tap {
                print($0)
            }.compactMap {
                try decoder.decode(User.self, from: $0.data)
        }
    }

    func makeUrlRequest<T: Codable>(httpMethod: HTTPMethod = .get, urlString: String, params: JSON? = nil,
                                    obj: T? = nil) throws -> URLRequest {
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

public struct Credentials: Codable {
    var login: String?
    var password: String?
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

