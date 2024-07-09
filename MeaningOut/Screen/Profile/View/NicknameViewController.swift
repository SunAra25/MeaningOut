//
//  NicknameViewController.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import UIKit
import SnapKit

final class NicknameViewController: BaseViewController {
    private let viewModel = NicknameViewModel()
    
    private lazy var profileImageView: ProfileView = {
        let view = ProfileView(.user, imageNum: viewModel.inputNewImageNum.value ?? 0)
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
        tf.tintColor = .meaningBlack
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
        bindData()
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationItem.title = NaviTitle.profileSetting.rawValue
    }
    
    override func setHierachy() {
        [profileImageView, cameraView, nicknameTextField, underlineView, messageLabel, completedButton].forEach {
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
        
        completedButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
    
    func bindData() {
        var isInitialLoad = true
        viewModel.outputShowProfileView.bind { [weak self] imgNum in
            guard let self else { return }
            let nextVC = ProfileViewController(imageNum: imgNum, title: .profileSetting)
            
            nextVC.completionHandler = { [weak self] imageNum in
                guard let self else { return }
                viewModel.inputNewImageNum.value = imageNum
            }
            
            if isInitialLoad {
                return
            }
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        viewModel.outputChangeProfileImage.bind { [weak self] imgNum in
            guard let self else { return }
            
            if isInitialLoad {
                return
            }
            profileImageView.changeImage(imgNum)
        }
        
        viewModel.outputSetRootVC.bind { [weak self] _ in
            guard let self else { return }
            
            if isInitialLoad {
                return
            }
            setRootViewController(MainTabBarController())
        }
        
        isInitialLoad = false
    }
    
    @objc private func profileDidTap() {
        viewModel.inputProfileBtnTap.value = ()
    }
    
    @objc private func completedBtnDidTap() {
        guard let nickname = nicknameTextField.text else { return }
        viewModel.inputCompletedBtnTap.value = nickname
    }
}

extension NicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let nick = textField.text else { return }
        
        var nickname = nick
        
        if nickname.contains(" ") {
            nickname.removeLast()
        }
        
        do {
            let isValid = try NicknameError.checkNickname(nickname)
            messageLabel.text = isValid ? "사용가능한 닉네임입니다." : ""
            completedButton.isEnabled = isValid
            completedButton.backgroundColor = isValid ? .meaningPrimary : .meaningGray3
        } catch let error as NicknameError {
            completedButton.isEnabled = false
            completedButton.backgroundColor = .meaningGray3
            messageLabel.text = error.errorDescription
        } catch {
            print("error")
        }
    }
}
