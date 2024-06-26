//
//  EditProfileViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/17/24.
//

import UIKit
import SnapKit

final class EditProfileViewController: BaseViewController {
    let userDefaults = UserDefaultsManager()
    
    private lazy var profileImageView: ProfileView = {
        let view = ProfileView(.user, imageNum: initImgNum)
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
        tf.text = userDefaults.nickname
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
    private lazy var initImgNum = userDefaults.imageNum
    private lazy var currentImgNum = initImgNum
    private var isNicknameValid = false
    private lazy var currentName = userDefaults.nickname
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nicknameTextField.text = currentName
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = NaviTitle.profileEdit.rawValue
        
        let barButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBtnDidTap))
        barButtonItem.isEnabled = false
        
        barButtonItem.tintColor = .meaningBlack
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func setHierachy() {
        [profileImageView, cameraView, nicknameTextField, underlineView, messageLabel].forEach {
            view.addSubview($0)
        }
        
        cameraView.addSubview(cameraImageView)
    }
    
    override func setConstraints() {
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
        userDefaults.imageNum = currentImgNum
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func profileDidTap() {
        guard let nickname = nicknameTextField.text else { return }
        
        currentName = nickname
        view.endEditing(true)
        
        let nextVC = ProfileViewController(imageNum: currentImgNum, title: .profileEdit)
        
        nextVC.completionHandler = { [weak self] imageNum in
            guard let self else { return }
            navigationItem.rightBarButtonItem?.isEnabled = initImgNum != imageNum || isNicknameValid
            currentImgNum = imageNum
            profileImageView.changeImage(imageNum)
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nicknameTextField.text = nil
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let nick = textField.text else { return }
        
        var nickname = nick
        
        if nickname.contains(" ") {
            nickname.removeLast()
        }
        
        do {
            let isValid = try NicknameError.checkNickname(nickname)
            messageLabel.text = isValid ? "사용가능한 닉네임입니다." : ""
            navigationItem.rightBarButtonItem?.isEnabled = isValid
            isNicknameValid = isValid
        } catch let error as NicknameError {
            messageLabel.text = error.errorDescription
            navigationItem.rightBarButtonItem?.isEnabled = false
            isNicknameValid = false
        } catch {
            print("error")
        }
    }
}
