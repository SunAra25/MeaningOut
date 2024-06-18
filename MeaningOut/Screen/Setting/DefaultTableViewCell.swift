//
//  OtherTableViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/16/24.
//

import UIKit
import SnapKit

final class DefaultTableViewCell: UITableViewCell {
    static let identifier = "DefaultTableViewCell"
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningGray1
        label.textAlignment = .left
        label.font = .bodyM
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
