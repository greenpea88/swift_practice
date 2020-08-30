//
//  ViewController.swift
//  CustomPopUp_tutorial
//
//  Created by 강민채 on 2020/08/27.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import WebKit

//안테나
let notificationName = "btnClickedNotification"

class ViewController: UIViewController, PopUpDeligate{
    

    @IBOutlet weak var MyWeb: WKWebView!
    @IBOutlet weak var ClickPopUpBtn: UIButton!
    
    //view controller가 메모리에서 해제가 될 때
    deinit {
        //안테나 제거
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //notification이라는 방송 수신기를 장착
        //selector 특정 주파수(action)을 잡을 때 행하는 action
        //name : 주파수의 이름
        //object : 이벤트 뿐만아니라 데이터도 넘어올 때 사용
        NotificationCenter.default.addObserver(self, selector: #selector(loadWebView), name: NSNotification.Name(rawValue: notificationName), object: nil)
    }

    //selector에서 사용하기 위해서는 @objc를 붙여줘야함
    @objc fileprivate func loadWebView(){
        print("ViewController - loadWebView()")
        let myInstaURL = URL(string: "https://www.instagram.com/spacebohemians/")
        self.MyWeb.load(URLRequest(url: myInstaURL!))
    }
    

    @IBAction func onCreatePopUpBtnClicked(_ sender: UIButton) {
        print("click popup botton")
        
        //스토리보드 가져오기
        let storyboard = UIStoryboard.init(name: "PopUp",bundle: nil)
        //스토리보드를 통해 뷰 컨트롤러 가져옴
        let customPopUpVC = storyboard.instantiateViewController(identifier: "alertPopUp") as CustomPopUpViewController
        //팝업 효과 설정
        customPopUpVC.modalPresentationStyle = .overCurrentContext
        //뷰 컨트롤러 사라지는 스타일
        customPopUpVC.modalTransitionStyle = .crossDissolve
        
        customPopUpVC.buttonCompletionClosure = {
            print("컴플레션 블록이 호출됨")
            let myURL = URL(string: "http://www.spacebohemian.com/front/")
            self.MyWeb.load(URLRequest(url: myURL!))
        }
        
        //CustomPopUpViewController애 있는 것과 서로 연결을 시켜줌
        //self는 view controller에서 받은 popUpDeligate를 의미
        customPopUpVC.myPopUpDeligate = self
    
        
        self.present(customPopUpVC,animated: true,completion: nil)
    }
    
    //MARK: - popUpDeligate methods
    func onOpenChatBtnClicked() {
        print("ViewController - openChatBtnClicked")
        let myChannelURL = URL(string: "https://www.youtube.com/channel/UChIKGx60x4D5elEbb5Vjtow")
        self.MyWeb.load(URLRequest(url: myChannelURL!))
    }
}

