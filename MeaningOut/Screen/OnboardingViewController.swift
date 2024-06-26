//
//  ViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "MeaningOut"
        label.textColor = .meaningPrimary
        label.textAlignment = .center
        label.font = .logo
        return label
    }()
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.launch
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let startButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("시작하기")
        attr.font = UIFont.bodyB
        
        config.attributedTitle = attr
        
        button.configuration = config
        button.tintColor = .meaningWhite
        button.backgroundColor = .meaningPrimary
        button.layer.cornerRadius = 20
        
        button.addTarget(nil, action: #selector(startButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    override func setHierachy() {
        view.addSubview(logoLabel)
        view.addSubview(imageView)
        view.addSubview(startButton)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.top).offset(-44)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
    
    @objc private func startButtonDidTap() {
        let nextVC = NicknameViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

