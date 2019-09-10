//
//  FYBaseViewController.swift
//  qhm
//
//  Created by wang on 2019/4/12.
//  Copyright © 2019 wang. All rights reserved.
//

import UIKit

class FYBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(true, animated: false)
        if self.navigationController?.children.count != 1 {
            self.view.addSubview(self.navBar)
            navBar.fy_setLeftButton(title: "返回", image: UIImage.init(named: "customback")!, titleColor: UIColor.black)
            navBar.fy_setBottomLineHidden(hidden: true)
            navBar.barBackgroundColor = mainColor
        }
    }
    
    lazy var navBar = FYCustomNavigationBar.CustomNavigationBar()

    //状态栏颜色默认为黑色
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}

