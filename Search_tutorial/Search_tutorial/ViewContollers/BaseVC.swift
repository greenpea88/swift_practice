//
//  BaseVC.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/08/29.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Toast_Swift

class BaseVC: UIViewController{
    
    var vcTitle: String = "" {
        //외부에서 vcTitle의 값이 변하게될 경우 실행이 되는 부분
        didSet{
            print("UserListVC -> VCTitle didSet() /  \(vcTitle)")
            self.title = vcTitle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //인증 실패 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopUP(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    //MARK: - objc Method
    @objc func showErrorPopUP(notification: NSNotification){
        print("BaseVC -> showErrorPopUp()")
        
        if let data = notification.userInfo?["statusCode"]{
            print("showErrorPopUp() \(data)")
            
            DispatchQueue.main.async {
                //view에 관련된 사항은 main thread에서 진행해줘야함
                self.view.makeToast("☠️\(data) 에러입니다.", duration: 1.0, position: .center)
            }
        }
    }
}
