//
//  Olympiads.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 5/29/19.
//

import Foundation

public struct State: Codable {
    let id: Int?
    var name: String?
    var uf: String?
}

public struct City: Codable {
    var id: Int?
    var name: String?
}

public struct Unit: Codable {
    let id: Int?
    let name, suggestedName, unitDescription: String?
    let active: Bool?


    enum CodingKeys: String, CodingKey {
        case id, name
        case suggestedName = "suggested_name"
        case unitDescription = "description"
        case active
    }
}
