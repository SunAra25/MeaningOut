//
//  OtherTableViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/16/24.
//

import UIKit
import SnapKit

final class DefaultTableViewCell: BaseTableViewCell {
    static let identifier = "DefaultTableViewCell"
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningGray1
        label.textAlignment = .left
        label.font = .bodyM
        return label
    }()
    
    override func setLayout() {
        contentView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(_ text: String) {
        contentLabel.text = text
    }
}
