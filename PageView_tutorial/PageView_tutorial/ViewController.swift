//
//  ViewController.swift
//  PageView_tutorial
//
//  Created by 강민채 on 2020/08/28.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import FSPagerView
//오픈 소스 : https://github.com/WenchaoD/FSPagerView
//pagerview로 사용할 view의 class명 FSPagerView로 변경

class ViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
    
    fileprivate let imageNames = ["1.JPG","2.JPG","3.JPG","4.JPG"]
    
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var myPagerView: FSPagerView!{
        //값이 설정이 됐을 때
        didSet{
            //pagerview에 cell을 등록함
            self.myPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            //아이템 크기 설정 : automaticSize(default 사이즈)
            self.myPagerView.itemSize = FSPagerView.automaticSize
            //무한 스크롤 설정
            self.myPagerView.isInfinite = true
            //자동 스크롤 설정(초단위)
            self.myPagerView.automaticSlidingInterval = 4.0
        }
    }
    @IBOutlet weak var myPageControl: FSPageControl!{
        didSet{
            self.myPageControl.numberOfPages = self.imageNames.count
            //위치 지정
            self.myPageControl.contentHorizontalAlignment = .center
            //점과 점사이의 간격
            self.myPageControl.itemSpacing = 16
            self.myPageControl.interitemSpacing = 16
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.leftBtn.layer.cornerRadius = self.leftBtn.frame.height / 2
        self.rightBtn.layer.cornerRadius = self.rightBtn.frame.height / 2
        
        self.myPagerView.dataSource = self
        self.myPagerView.delegate = self
        
    }

    //MARK: -IBAction
    @IBAction func onLeftBtnClicked(_ sender: UIButton) {
        print("ViewController - onLeftBtnClicked()")
        self.myPageControl.currentPage = self.myPageControl.currentPage - 1
        self.myPagerView.scrollToItem(at: self.myPageControl.currentPage, animated: true)
    }
    
    
    @IBAction func onRightBtnClicked(_ sender: UIButton) {
        print("ViewController - onRightBtnClicked()")
        //left는 무한스크롤 설정 때문에 out of range 발생 안하지만 오른쪽은 발생?
        if(self.myPageControl.currentPage == self.imageNames.count - 1){
            self.myPageControl.currentPage = 0
        }
        else{
            self.myPageControl.currentPage = self.myPageControl.currentPage + 1
        }
        self.myPagerView.scrollToItem(at: self.myPageControl.currentPage, animated: true)
    }
    
    //MARK: -FSPagerVeiw datasource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    //아이템 설정
    //각 셀에 대한 설정
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        //cell의 instance 가져옴
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
//        cell.textLabel?.text = ...
        return cell
    }
    
    //MARK: -FSPagerVeiw delegate
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int){
        //Tells the delegate when the user finishes scrolling the content.
        self.myPageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        //Tells the delegate when a scrolling animation in the pager view concludes.
        self.myPageControl.currentPage = pagerView.currentIndex
    }
    
    //image 누를시 버튼 눌림 표현 해제
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }
    
}

