//
//  FractalService+Olimpiadas.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 5/29/19.
//

import Foundation
import PromiseKit

extension FractalRestAPI {

    public func getStates() -> Promise<[State]> {
        let url = Router.states.withParameters(params: ["page": 1])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .get,
                                                                          urlString: url)).validate()
            }.tap {
                print($0)
            }.compactMap {
                try decoder.decode([State].self, from: $0.data)
        }
    }

    public func getCities(stateId: String) -> Promise<[City]> {
        let url = Router.cities.withParameters(params: ["state_id": stateId, "page": 1])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .get,
                                                                          urlString: url)).validate()
            }.tap {
                print($0)
            }.compactMap {
                try decoder.decode([City].self, from: $0.data)
        }
    }

    public func getUnits(stateId: String, cityId: String) -> Promise<[Unit]> {
        let url = Router.units.withParameters(params: ["address_city_id": cityId, "address_state_id": stateId, "page": 1])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return firstly {
            URLSession.shared.dataTask(.promise, with: try makeUrlRequest(httpMethod: .get,
                                                                          urlString: url)).validate()
            }.tap {
                print($0)
            }.compactMap {
                try decoder.decode([Unit].self, from: $0.data)
        }
    }
}
