//
//  ProfileView.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import UIKit
import SnapKit

final class ProfileView: UIView {
    private let profileImageView = UIImageView()
    
    init(image: String, width: CGFloat, color: UIColor?) {
        super.init(frame: .zero)
        
        configureView(image: image, width: width, color: color)
        setLayout()
    }
    
    init(width: CGFloat, color: UIColor?) {
        super.init(frame: .zero)
        
        configureView(image: "", width: width, color: color)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(image: String, width: CGFloat, color: UIColor?) {
        backgroundColor = .clear
        
        layer.cornerRadius = 50
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
        
        clipsToBounds = true
        
        profileImageView.image = UIImage(named: image)
        profileImageView.contentMode = .scaleAspectFit
    }
    
    func configureImage(_ imageName: String) {
        profileImageView.image = UIImage(named: imageName)
    }
    
    func setLayout() {
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
    }
}
