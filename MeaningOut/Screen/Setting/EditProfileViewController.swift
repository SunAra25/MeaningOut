//
//  EditProfileViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/17/24.
//

import UIKit
import SnapKit

final class EditProfileViewController: UIViewController {
    let userDefaults = UserDefaultsManager()
    
    private lazy var profileImageView: ProfileView = {
        let view = ProfileView(.user, imageNum: imageNum)
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
    private lazy var nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = userDefaults.nickname
        tf.textColor = .meaningBlack
        tf.textAlignment = .left
        tf.font = .subM
        tf.tintColor = .meaningBlack
        tf.delegate = self
        return tf
    }()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .meaningGray3
        return view
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .meaningGray1
        label.textAlignment = .left
        label.font = .capB
        return label
    }()
    private lazy var imageNum = userDefaults.imageNum
    private var nicknameState = NicknameState.none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .meaningWhite
        
        setNavigation()
        setHierachy()
        setConstraints()
    }
    
    private func setNavigation() {
        navigationItem.title = NaviTitle.profileEdit.rawValue
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .meaningBlack
        
        let barButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnDidTap))
        barButtonItem.isEnabled = false
        
        barButtonItem.tintColor = .meaningBlack
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func setHierachy() {
        [profileImageView, cameraView, nicknameTextField, underlineView, messageLabel].forEach {
            view.addSubview($0)
        }
        
        cameraView.addSubview(cameraImageView)
    }
    
    private func setConstraints() {
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
    }
    
    @objc func saveBtnDidTap() {
        guard let nickname = nicknameTextField.text else { return }
        userDefaults.nickname = nickname
        userDefaults.imageNum = imageNum
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func profileDidTap() {
        let nextVC = ProfileViewController(imageNum: imageNum, title: .profileEdit)
        
        nextVC.completionHandler = { [weak self] imageNum in
            guard let self else { return }
            self.imageNum = imageNum
            profileImageView.changeImage(imageNum)
            navigationItem.rightBarButtonItem?.isEnabled = nicknameState == .valid || nicknameState == .none
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let nick = textField.text else { return }
        
        var nickname = nick
        
        if nickname.contains(" ") {
            nickname.removeLast()
        }
        
        nicknameState = NicknameState.checkNickname(nickname)
        navigationItem.rightBarButtonItem?.isEnabled = nicknameState == .valid && nickname != userDefaults.nickname
        messageLabel.text = nicknameState.rawValue
    }
}
