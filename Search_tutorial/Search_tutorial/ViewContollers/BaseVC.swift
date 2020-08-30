//
//  BaseVC.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/08/29.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class BaseVC: UIViewController{
    
    var vcTitle: String = "" {
        //외부에서 vcTitle의 값이 변하게될 경우 실행이 되는 부분
        didSet{
            print("UserListVC -> VCTitle didSet() /  \(vcTitle)")
            self.title = vcTitle
        }
    }
}
