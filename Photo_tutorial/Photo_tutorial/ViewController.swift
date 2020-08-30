//
//  ViewController.swift
//  Photo_tutorial
//
//  Created by 강민채 on 2020/08/27.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import YPImagePicker
//오픈소스 : https://github.com/Yummypets/YPImagePicker#configuration

class ViewController: UIViewController {

    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changePhoto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        changePhoto.layer.cornerRadius = 10
        
        //버튼 클릭 액션 설정
        self.changePhoto.addTarget(self, action: #selector(onChangePhotoBtnClicked), for: .touchUpInside)
        //.touchUpInside : button의 안쪽이 클릭되었을 때 행함
    }

    //프사 변경 버튼이 클릭되었을때 동작
    @objc fileprivate func onChangePhotoBtnClicked()
    {
        print("ViewController -> onChangePhotoBtnClicked()")
        
        //카메라 라이브러리 세팅
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo, .video]
//        config.screens = [.library]
        
        //사진이 선택되었을 때
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            //선택되는 사진이 존재한다면
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                //프사 이미지 변경
                self.profileImage.image = photo.image
            }
            //picker 창 닫기
            picker.dismiss(animated: true, completion: nil)
        }
        
        //picker 창 보여주기
        present(picker, animated: true, completion: nil)
    }
}

