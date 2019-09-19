//
//  RegulaminVC.swift
//  Pager
//
//  Created by darys on 12.02.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import WebKit

class RegulaminVC: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string:"https://www.cobytu.com/index.php?d=regulamin&mobile=1")
        let request = URLRequest(url:url!)
        webview.load(request)
    }


}
