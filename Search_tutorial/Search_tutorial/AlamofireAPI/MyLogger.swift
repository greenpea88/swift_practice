//
//  MyLogger.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor{
    
    let queue = DispatchQueue.init(label: "APILog")
    
    func requestDidResume(_ request: Request) {
        print("MyLogger -> requestDidResume()")
        //request 부분에 해당
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger -> request() didPaseResponse")
        //response 부분에 해당
        debugPrint(response)
    }
}
