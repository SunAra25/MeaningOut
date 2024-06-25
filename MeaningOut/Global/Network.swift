//
//  Network.swift
//  MeaningOut
//
//  Created by 아라 on 6/20/24.
//

import UIKit
import Alamofire

class Network {
    static let shared = Network()
    let url = APIURL.searchURL
    
    private init() { }
    
    func getSearchResult(_ target: String, start: Int, sort: SortBy, completionHandler: @escaping (Result<SearchResponse, NetworkError>) -> Void) {
        let url = APIURL.searchURL
        
        let parameters: Parameters = [
            "query" : target,
            "display" : 30,
            "start" : start,
            "sort" : sort.value
        ]
        let headers: HTTPHeaders = [
            Header.id : APIKey.clientId,
            Header.secret : APIKey.clientSecret
        ]
        
        AF.request(
            url,
            parameters: parameters,
            headers: headers
        ).responseDecodable(of: SearchResponse.self) { response in
            switch response.result {
            case .success(let value):
                return completionHandler(.success(value))
            case .failure(_):
                return completionHandler(.failure(.responseFail))
            }
        }
    }
}

enum NetworkError: Error {
    case responseFail
}
