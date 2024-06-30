//
//  UIViewController+.swift
//  MeaningOut
//
//  Created by 아라 on 6/24/24.
//

import UIKit

extension UIViewController {
    func setRootViewController<T: UIViewController>(_ rootViewController: T) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        sceneDelegate?.window?.rootViewController = rootViewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func showTwoBtnAlert(title: String, message: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showOneBtnAlert(title: String, message: String? = nil, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
