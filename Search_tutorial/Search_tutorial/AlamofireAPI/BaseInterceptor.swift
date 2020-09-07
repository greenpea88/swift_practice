//
//  BaseInterceptor.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor{
    
    //api를 호출할 때(request할 때) 호출되는 부분
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor -> adpat()")
        
        var request = urlRequest
        
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        //completion을 호출하지 않으면 멈춰있게됨
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor -> retry()")
    }
}
