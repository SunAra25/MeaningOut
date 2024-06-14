//
//  ResultViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import Alamofire

class ResultViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .meaningWhite
    }
    
    init(searchTarget target: String) {
        super.init(nibName: nil, bundle: nil)
        callRequest(target)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func callRequest(_ target: String) {
        let url = APIURL.searchURL
        let parameters: Parameters = [
            "query" : target
        ]
        let headers: HTTPHeaders = [
            Header.id : APIKey.clientId,
            Header.secret : APIKey.clientSecret
        ]
        
        AF.request(
            url,
            parameters: parameters,
            headers: headers
        ).responseString { response in
            print(response)
        }
    }
}
