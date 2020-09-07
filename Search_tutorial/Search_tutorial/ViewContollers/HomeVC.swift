//
//  ViewController.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/08/28.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Toast_Swift // 오픈 소스 :  https://github.com/scalessec/Toast-Swift
import Alamofire


class HomeVC: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate{

    
    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    var keyboardDissmissTabGesture: UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("HomeVC -> ViewDidLoad()")
        
        //ui 설정
        self.config()
    }
    
    //화면이 넘어가기 전에 준비
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("HomeVC -> prepare() / segueID : \(segue.identifier)")
        
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            //다음 화면의 뷰컨트롤러를 가져옴
            let nextVC = segue.destination as! UserListVC
            //searchBar에서의 text값이 optional이기 때문에 guard let으로 unwrapping
            guard let userInputValue = self.searchBar.text  else{ return }
            nextVC.vcTitle = userInputValue + "😈"
        case SEGUE_ID.PHOTO_VC:
            let nextVc = segue.destination as! PhotoVC

            guard let userInputValue = self.searchBar.text else { return }
            nextVc.vcTitle = userInputValue + "📸"
            
        default:
            print("default")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC -> viewWillAppear()")
        
        //키보드가 올라가고 내려가고는 iphone에서 defualt로 notification을 보내줌
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC -> viewWillDisappear")
        
        //등록한 notificationcenter 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder() //포커싱 주기
    }
    
    //MARK: - fileprivate
    //fileprivate : 하나의 swift 파일에서만 접근이 가능한 접근 제어 수준
    fileprivate func config(){
        //ui설정
        self.searchBtn.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        
        //설정하지 않으면 delegate를 감지하지 못함
        self.searchBar.delegate = self
        self.keyboardDissmissTabGesture.delegate = self
        
        //최상단에 gesture 설정 : gesture를 감지할 수 있게 됨
        self.view.addGestureRecognizer(keyboardDissmissTabGesture)
        
    }
    
    fileprivate func pushVC(){
        //화면 전환 func
        var segueId : String = ""
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            print("사진 화면으로 이동")
            segueId = "goToPhotoVC"
        case 1:
            print("사용자 화면으로 이동")
            segueId = "goToUserListVC"
        default:
            print("default")
            segueId = "goToPhotoVC"
        }
        
        //화면 이동
        //sender : 이동 시작하는 화면
        self.performSegue(withIdentifier: segueId, sender: self)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        print("HomeVC -> keyboardWillShow")
        //키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if(keyboardSize.height < searchBtn.frame.origin.y){
                //키보드가 버튼을 덮음
                let distance = keyboardSize.height - searchBtn.frame.origin.y
                self.view.frame.origin.y = distance - searchBtn.frame.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        print("HomeVC -> keyboardWillHide")
        //올라간 뷰 원상복귀
        self.view.frame.origin.y = 0
    }
    
    
    //MARK: - IBAction
    @IBAction func searchFilterValueChange(_ sender: UISegmentedControl) {
        print("HomeVC -> searchFilterValueChange() / index : \(sender.selectedSegmentIndex)")
        
        var searchBarTitle = ""
        
        //선택된 요소에 따라
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        self.searchBar.placeholder = searchBarTitle + "입력"
        //searchBar에 포커싱을 줌
        //포커싱 해제 : self.searchBar.resignFirstResponder()
        self.searchBar.becomeFirstResponder()
    }
    
    @IBAction func onSearchBtnClicked(_ sender: UIButton) {
        //검색 버튼이 눌렸을 때
        print("HomeVC -> onSearchBtnClicked() / index : \(searchFilterSegment.selectedSegmentIndex)")
        
//        let url = API.URL + "search/photos"
        
        guard let inputText = searchBar.text else { return }
        
//        let params = ["query" : inputText, "client_id" : API.CLIENT_ID]
        
//        AF.request(url, method: .get, parameters: params).responseJSON(completionHandler: {
//            response in
//            debugPrint(response)
//        })
        
        //optional로 설정
        var urlToCall: URLRequestConvertible?
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
//            urlToCall = MySearchRouter.searchPhotos(term: inputText)
            MyAlamofireManager.shared.getPhotos(searchTerm: inputText, completion: { result in
                switch result{
                case .success(let fetchedPhotos):
                    print("HomeVC -> getPhotos Success fetchedPhotos.count : \(fetchedPhotos.count)")
                case .failure(let error):
                    print("HomeVC -> getPhotos Failure error : \(error.rawValue)")
                }
            })
        case 1:
            urlToCall = MySearchRouter.searchUsers(term: inputText)
        default:
            print("default")
        }
        
        //값이 있을 때
        //validate() -> error를 잡기위해 : retry 호출 됨
//        if let urlConvertible = urlToCall {
//            MyAlamofireManager
//                .shared
//                .session
//                .request(urlConvertible)
//                .validate(statusCode: 200..<401)
//                .responseJSON(completionHandler: {response in
//                debugPrint(response)
//            })
//        }

        
        //화면으로 이동
//        pushVC()
    }
    
 
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //키보드의 검색 버튼이 눌렸을 때
        print("HomeVC -> searchBar searchBtnClicked")
        
        //guard let 뒤의 실행 결과가 true일 때 계속 실행됨
        //if문과는 다르게 항상 else가 있어야 함
        //자신보다 상위 블록을 종료하는 코드가 반드시 들어가야함
        guard let userInputSting = searchBar.text else { return  }
        
        if (userInputSting.isEmpty){
            self.view.makeToast("검색어를 입력해주세요",duration: 1.0,position: .center)
        }
        else{
            //화면 이동
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC -> serachBar textDidChange() searchText : \(searchText)")
        
        //사용자가 입력한 값이 없을 때
        if (searchText.isEmpty){
            self.searchBtn.isHidden = true
            
            //실행 delay를 줌
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                self.searchBar.resignFirstResponder() //포커싱 해제
            })
        }
        else{
            self.searchBtn.isHidden  = false
        }
        
    }

    //글자가 입력될 때
    //위의 함수보다 먼저 접근이 됨
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //값이 비어있을 경우 0을 넣음(?? 0)
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
         print("HomeVC -> searchBar  shouldChangeTextIn \(inputTextCount)")
        
        if (inputTextCount >= 12){
            //duration : 보여주는 시간
            self.view.makeToast("🚨12자 이하로 입력해주세요🚨", duration: 1.0, position: .center)
        }
        
        //12글자가 초과되면 텍스트 입력이 제한됨
        if (inputTextCount <= 12){
            return true
        }
        else{
            return false
        }
        
//        return inputTextCount <= 12 : 위와 동일한 동작
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //사용자가 터치했을 때 동작하게 됨
        print("HomeVC -> gestureRecognizer touch()")
        
        //searchBar 혹은 filter가 터치 됐을 때는 예외처리
        if (touch.view?.isDescendant(of: searchFilterSegment) == true){
            print("segment touched")
            return false
        }
        else if (touch.view?.isDescendant(of: searchBar) == true){
            print("searchBar touched")
            return false
        }
        else if(touch.view?.isDescendant(of: searchBtn) == true){
            print("searchBtn touched")
            return false
        }
        else{
            //편집이 끝났음 -> 키보드가 내려감
            view.endEditing(true)
            return true
        }
    }
}

