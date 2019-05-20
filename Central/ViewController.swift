//
//  ViewController.swift
//  Central
//
//  Created by YOHEI OKAYA on 2019/05/20.
//  Copyright © 2019 YOHEI OKAYA. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    override func viewDidAppear( _ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        let urlString = "https://www.google.co.jp"
        if let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}

