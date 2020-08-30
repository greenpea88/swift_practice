//
//  RegisterViewController.swift
//  SwiftPractice
//
//  Created by 강민채 on 2020/08/27.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var ButtonForLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func onLoginControllerButtonClicked(_ sender: UIButton) {
        print("login button clicked")
        
        //네이게이션 뷰 컨트롤러를 pop
        self.navigationController?.popViewController(animated: true)
    }
    
}
