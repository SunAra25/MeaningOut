//
//  ResultViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import Alamofire
import SnapKit

final class ResultViewController: UIViewController {
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningPrimary
        label.textAlignment = .left
        label.font = .capB
        return label
    }()
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.spacing = 8
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        
        return view
    }()
    private let sortButtons: [UIButton] = {
        var array: [UIButton] = []
        SortBy.allCases.forEach {
            let button = CapsuleButton(title: $0.rawValue, tag: $0.index)
            button.isSelect = $0.index == 0
        
            array.append(button)
        }
        
        return array
    }()
    private lazy var resultCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .lightGray
        return collection
    }()
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .meaningWhite
        setHierachy()
        setConstraints()
    }
    
    init(searchTarget target: String) {
        super.init(nibName: nil, bundle: nil)
        callRequest(target)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierachy() {
        [totalCountLabel, stackView, resultCollectionView].forEach {
            view.addSubview($0)
        }
        
        sortButtons.forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        totalCountLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(36)
        }
        
        sortButtons.forEach { button in
            button.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview()
            }
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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
