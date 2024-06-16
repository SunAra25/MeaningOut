//
//  CartTableViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/16/24.
//

import UIKit

final class CartTableViewCell: UITableViewCell {
    static let identifier = "OtherTableViewCell"
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningGray1
        label.textAlignment = .left
        label.font = .bodyM
        return label
    }()
    private let basketImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.likeSelected
        view.tintColor = .meaningBlack
        return view
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningBlack
        label.textAlignment = .right
        label.font = .bodyB
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        [contentLabel, basketImageView, countLabel].forEach {
            contentView.addSubview($0)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        basketImageView.snp.makeConstraints { make in
            make.trailing.equalTo(countLabel.snp.leading).offset(-4)
            make.size.equalTo(countLabel.snp.height)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(_ text: String, numOfLike: Int) {
        contentLabel.text = text
        countLabel.text = numOfLike.formatted() + "개의 상품"
        countLabel.partiallyChanged("의 상품", font: .bodyM, color: .meaningGray1)
    }
}
