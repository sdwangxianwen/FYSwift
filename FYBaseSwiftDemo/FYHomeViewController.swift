//
//  ViewController.swift
//  FYBaseSwiftDemo
//
//  Created by wang on 2019/9/10.
//  Copyright © 2019 wang. All rights reserved.
//

import UIKit

class FYHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if IS_DEBUG {
            view.backgroundColor = UIColor.brown
        } else {
            view.backgroundColor = UIColor.white
        }
        FYNetApi.shared.post(target: .homeURL) { (response) in
            
        }
    }


}

