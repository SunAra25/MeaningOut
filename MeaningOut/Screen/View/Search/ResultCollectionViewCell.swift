//
//  ResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/15/24.
//

import UIKit
import SnapKit

final class ResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "ResultCollectionViewCell"
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let mallNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningGray2
        label.textAlignment = .left
        label.font = .capM
        return label
    }()
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningBlack
        label.textAlignment = .left
        label.font = .subM
        label.numberOfLines = 2
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningBlack
        label.textAlignment = .left
        label.font = .bodyB
        return label
    }()
    private let likeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage.likeUnselected
        config.baseBackgroundColor = .meaningBlack?.withAlphaComponent(0.5)
        
        button.configuration = config
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        [productImageView, mallNameLabel, productNameLabel, priceLabel, likeButton].forEach {
            contentView.addSubview($0)
        }

        productImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(productImageView.snp.width).multipliedBy(1.2)
        }

        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(4)
        }

        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(4)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview()
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(productImageView).inset(16)
            make.size.equalTo(32)
        }
    }
}
