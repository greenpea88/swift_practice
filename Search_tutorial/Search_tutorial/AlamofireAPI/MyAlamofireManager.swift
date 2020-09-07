//
//  MyAlamofireManager.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire

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
}
