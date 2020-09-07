//
//  MyAlamofireManager.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MyAlamofireManager{
    
    //singleton pattern
    static let shared = MyAlamofireManager()
    
    //인터셉터
    let interceptors = Interceptor(interceptors:
                        [
                            BaseInterceptor()
                        ])
    
    //이벤트 모니터
    let monitor = [MyLogger()] as [EventMonitor]
    
    //session
    var session : Session
    
    private init(){
        session = Session(interceptor: interceptors, eventMonitors: monitor)
    }
    
    func getPhotos(searchTerm userInput: String,
                   completion: @escaping (Result<[Photo], MyError>) -> Void){
        print("MyAlamoFireManger -> getPhotos() : \(userInput)")
        self.session
            .request(MySearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: {response in
                
                guard let responseValue = response.value else {return}
                
                var photos = [Photo]()
                let json = JSON(responseValue)
                
                let jsonArray = json["results"]
                
                print("jsonArray.count \(jsonArray.count)")
                
                for (index, subJson): (String, JSON) in jsonArray{
                    print("index : \(index) subJson : \(subJson)")
                    
                    //데이터 파싱
                    let thumnail = subJson["urls"]["thumb"].string ?? ""
                    let userName = subJson["user"]["username"].string ?? ""
                    let likeCount = subJson["likes"].int ?? 0
                    let createdAt = subJson["created_at"].string ?? ""
                    
                    let photoItem = Photo(thumnail: thumnail, userName: userName, likesCount: likeCount, createdAt: createdAt)
                    //배열에 넣고
                    photos.append(photoItem)
                }
                
                if photos.count > 0 {
                    completion(.success(photos))
                }
                else{
                    completion(.failure(.noContent))
                }
        })
     }
}
