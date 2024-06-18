//
//  ProfileCollectionViewCell.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"
    
    private let profileView = ProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ num: Int, radius: CGFloat, isSelected: Bool) {
        profileView.configureView(isSelected ? .selected : .example, imageNum: num)
        profileView.layer.cornerRadius = radius
    }
    
    private func setLayout() {
        contentView.addSubview(profileView)
        
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(profileView.snp.width)
        }
    }
}
