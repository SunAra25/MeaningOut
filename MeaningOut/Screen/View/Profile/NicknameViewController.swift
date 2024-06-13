//
//  NicknameViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import UIKit
import SnapKit

final class NicknameViewController: UIViewController {
    private let profileImageView: ProfileView = {
        let random = Int.random(in: 0...11)
        let view = ProfileView(image: "profile_\(random)", width: 5, color: .meaningPrimary)
        
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
        label.text = "닉네임에 @는 포함할 수 없어요"
        label.textColor = .meaningPrimary
        label.textAlignment = .left
        label.font = .capB
        label.isHidden = true
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
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .meaningWhite
        nicknameTextField.delegate = self
        
        setNavigation()
        setHierachy()
        setConstraints()
    }
    
    func setNavigation() {
        navigationItem.title = "PROFILE SETTING"
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
            make.height.equalTo(0)
        }
        
        completedButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
}

extension NicknameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nick = textField.text else { return false }
        
        var nickname = nick
        
        if let last = nick.last, last == " " {
            nickname.removeLast()
            textField.text = nickname
        }
        
        let nicknameValid = checkNicknameValid(nickname)
        
        if nicknameValid != .valid {
            showMessage(nicknameValid.rawValue)
            
            completedButton.isEnabled = false
            completedButton.backgroundColor = .meaningGray3
        } else {
            completedButton.isEnabled = true
            completedButton.backgroundColor = .meaningPrimary
            
            messageLabel.isHidden = true
            messageLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        
        return true
    }
}

extension NicknameViewController {
    func checkNicknameValid(_ nickname: String) -> NicknameVaild {
        if nickname.isEmpty {
            return .none
        }
        
        if nickname.contains(" ") {
            return .gap
        }
        
        if nickname.contains("@") {
            return .symbol
        }
        
        return .valid
    }
    
    func showMessage(_ text: String) {
        messageLabel.isHidden = false
        messageLabel.text = text
        
        messageLabel.snp.updateConstraints { make in
            make.height.equalTo(13)
        }
    }
}
