//
//  EnviromentConstants.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 4/16/19.
//

import Foundation

public enum Environment: Int {
    case production = 0
    case presentation
    case staging
    case development
    case custom

    var customUrl : String {
        get { return UserDefaults.standard.string(forKey: "CUSTOM_URL") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "CUSTOM_URL") }
    }

    var baseUrl: String {
        switch self {
        case .production: return "https://datagateway.fractaltecnologia.com.br/api/v1"
        case .presentation: return "https://demo-datagateway.fractaltecnologia.com.br/api/v1"
        case .staging: return "https://staging.datagateway.fractaltecnologia.com.br/api/v1"
        case .development: return "https://dev-datagateway.fractaltecnologia.com.br/api/v1"
        case .custom: return "https://\(customUrl)"
        }
    }

    public var title: String {
        switch self {
        case .production: return "Production"
        case .presentation: return "Demonstration"
        case .staging: return "Staging"
        case .development: return "Development"
        case .custom: return "Custom"
        }
    }

    public mutating func setUrl(_ url: String){
        self.customUrl = url
    }
}

public enum Router: String {
    case user = "users"
    case userPhrase = "user_phrases"

    var baseUrl: String {
        return FractalRestAPI.shared.environment.baseUrl
    }

    var url: String {
        return "\(baseUrl)/\(self.rawValue)"
    }

    func urlWith(path:String) -> String {
        return "\(url)/\(path)"
    }

    static var headers: [String: String] {
        return ["X-TOKEN": FractalRestAPI.shared.token ?? ""]
    }
}
