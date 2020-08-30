//
//  CustomPopUpViewController.swift
//  CustomPopUp_tutorial
//
//  Created by 강민채 on 2020/08/27.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class CustomPopUpViewController: UIViewController {
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bgButton: UIButton!
    @IBOutlet weak var OpenChat: UIButton!
    @IBOutlet weak var instaBtn: UIButton!
    
    
    var buttonCompletionClosure: (() -> Void)? //아무행위도 하지 않음, 발생했음을 알려줌
    
    var myPopUpDeligate: PopUpDeligate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("custom!")
        
        ContentView.layer.cornerRadius = 30
        button.layer.cornerRadius = 10
        OpenChat.layer.cornerRadius = 10
        instaBtn.layer.cornerRadius = 10
    }
    
    //MARK: -IBActions
    
    @IBAction func InstaButtonClicked(_ sender: UIButton) {
        
        print("CustomPopUpViewController - InstaButtonClicked")
        //버튼이 눌렷다는 시그널 보내기
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationName), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BgButtonClicked(_ sender: UIButton) {
         //현재 창 닫기
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func OnButtonClicked(_ sender: UIButton) {
        
        print("butttton")
        
        self.dismiss(animated: true, completion: nil)
        
        //컴플렉션 블록 호출
        if let buttonCompletionClosure = buttonCompletionClosure{
            //메인에 알림
            buttonCompletionClosure()
        }
        
    }
    
    @IBAction func OpenChatBtnClicked(_ sender: UIButton) {
        print("CustomPopUpViewController - open chat clicked")
        
        //리모콘 버튼을 누른 것과 동일, 수신지 -> view controller
        myPopUpDeligate?.onOpenChatBtnClicked()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
