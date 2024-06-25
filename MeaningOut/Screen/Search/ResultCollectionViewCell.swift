//
//  ResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/15/24.
//

import UIKit
import SnapKit

final class ResultCollectionViewCell: BaseCollectionViewCell {
    static let identifier = "ResultCollectionViewCell"
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .meaningGray3?.withAlphaComponent(0.4)
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
    let likeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage.likeUnselected
        config.baseBackgroundColor = .meaningBlack?.withAlphaComponent(0.3)
        
        button.configuration = config
        return button
    }()
    
    override func setLayout() {
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
    
    func configureCell(_ data: Product, target: String, isLike: Bool) {
        guard let imageURL = URL(string: data.image) else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            do {
                let data = try Data(contentsOf: imageURL)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    productImageView.image = UIImage(data: data)
                }
            } catch {
                productImageView.backgroundColor = .lightGray
            }
        }
        
        mallNameLabel.text = data.mallName
        productNameLabel.text = data.titleNoneHTML
        productNameLabel.partiallyChanged(target, font: .capB, color: .meaningPrimary)
        
        priceLabel.text = data.price
        
        var config = likeButton.configuration ?? UIButton.Configuration.filled()
        config.image = isLike ? .likeSelected : .likeUnselected
        config.baseBackgroundColor = isLike ? .meaningWhite : .meaningBlack?.withAlphaComponent(0.5)
        likeButton.configuration = config
    }
}
