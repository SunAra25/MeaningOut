//
//  NicknameViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import UIKit
import SnapKit

final class NicknameViewController: UIViewController {
    let userDefaults = UserDefaultsManager()
    
    private lazy var profileImageView: ProfileView = {
        let view = ProfileView(.user, imageNum: random)
        view.layer.cornerRadius = 50
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileDidTap))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    private let cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .meaningPrimary
        view.layer.cornerRadius = 16
        return view
    }()
    private let cameraImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage.camera
        view.tintColor = .meaningWhite
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    private let nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "닉네임을 입력해주세요 :>"
        tf.textColor = .meaningBlack
        tf.textAlignment = .left
        tf.font = .subM
        return tf
    }()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .meaningGray3
        return view
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningPrimary
        label.textAlignment = .left
        label.font = .capB
        return label
    }()
    private let completedButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("완료")
        attr.font = UIFont.bodyB
        
        config.attributedTitle = attr
        
        button.configuration = config
        button.tintColor = .meaningWhite
        button.backgroundColor = .meaningGray3
        button.layer.cornerRadius = 20
        
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(completedBtnDidTap), for: .touchUpInside)
        return button
    }()
    
    private var random = Int.random(in: 0...11) {
        willSet {
            profileImageView.changeImage(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .meaningWhite
        nicknameTextField.delegate = self
        
        setNavigation()
        setHierachy()
        setConstraints()
    }
    
    func setNavigation() {
        navigationItem.title = NaviTitle.profileSetting.rawValue
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .meaningBlack
    }
    
    func setHierachy() {
        [profileImageView, cameraView, nicknameTextField, underlineView, messageLabel, completedButton].forEach {
            view.addSubview($0)
        }
        
        cameraView.addSubview(cameraImageView)
    }
    
    func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.size.equalTo(100)
        }
        
        cameraView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
            make.size.equalTo(32)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(5)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        completedButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
    
    @objc func profileDidTap() {
        let nextVC = ProfileViewController(imageNum: random)
        
        nextVC.completionHandler = { imageNum in
            self.random = imageNum
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func completedBtnDidTap() {
        guard let nickname = nicknameTextField.text else { return }
        
        userDefaults.nickname = nickname
        userDefaults.imageNum = random
        
        let current = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy. MM. dd "
        let createdAt = formatter.string(from: current)
        
        userDefaults.createdAt = createdAt
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let rootViewController = MainTabBarController()
        
        sceneDelegate?.window?.rootViewController = rootViewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

extension NicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let nick = textField.text else { return }
        
        var nickname = nick
        
        if nickname.contains(" ") {
            nickname.removeLast()
        }
        
        let nicknameValid = checkNicknameValid(nickname)
        
        completedButton.isEnabled = nicknameValid == .valid
        completedButton.backgroundColor = nicknameValid == .valid ? .meaningPrimary : .meaningGray3
        messageLabel.text = nicknameValid.rawValue
    }
}

extension NicknameViewController {
    func checkNicknameValid(_ nickname: String) -> NicknameVaild {
        if nickname.isEmpty {
            return .none
        }
        
        for char in nickname {
            if ["@", "#", "$", "%"].contains(char) {
                return .symbol
            }
            
            if char.isNumber {
                return .number
            }
            
            if char == " " {
                return .gap
            }
        }
        
        if !(2...9 ~= nickname.count) {
            return .range
        }
        
        return .valid
    }
}
