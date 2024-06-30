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
        guard var component = URLComponents(string: APIURL.searchURL) else { return }
        component.queryItems = [
            URLQueryItem(name: "query", value: target),
            URLQueryItem(name: "display", value: String(30)),
            URLQueryItem(name: "start", value: String(start)),
            URLQueryItem(name: "sort", value: sort.value)
        ]
        
        guard let url = component.url else { return }
        var requestURL = URLRequest(url: url)
        requestURL.addValue(APIKey.clientId,
                            forHTTPHeaderField: Header.id)
        requestURL.addValue(APIKey.clientSecret,
                            forHTTPHeaderField: Header.secret)
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(.failure(.requestFail))
                    return
                }
                
                guard let data else {
                    completionHandler(.failure(.noData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(.failure(.invalidResponse))
                    return
                }
                
                guard response.statusCode == 200 else {
                    completionHandler(.failure(.requestFail))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(.invalidData))
                }
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case requestFail
    case noData
    case invalidResponse
    case invalidData
    case responseFail
}
