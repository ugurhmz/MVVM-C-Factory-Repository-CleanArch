//
//  NetworkManager.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async -> Result<T, NetworkError>
}

final class NetworkManager: NetworkServiceProtocol {
    init() {}
    
    func fetch<T: Decodable>(_ endpoint: any Endpoint, type: T.Type) async -> Result<T, NetworkError> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        let request = AF.request(
            url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        ).validate()
        
        let task = request.serializingDecodable(T.self)
        let dataResponse = await task.response
        
        switch dataResponse.result {
        case .success(let data):
            print("Success OK Ok OK")
            return .success(data)
        case .failure(let error):
            print("ERR X X X")
            if let statusCode = dataResponse.response?.statusCode {
                return .failure(.serverError(statusCode: statusCode))
            }
            return .failure(.unknown(error))
        }
    }
}
