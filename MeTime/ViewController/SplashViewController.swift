//
//  ViewController.swift
//  MeTime
//
//  Created by hyunchul on 2023/08/28.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            
            let navigationController = UINavigationController(rootViewController: MainTabBarViewController())
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: false)
        }
    }


}

