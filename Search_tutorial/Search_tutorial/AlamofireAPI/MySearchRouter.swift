//
//  MySearchRouter.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire


//검색 관련 API
enum MySearchRouter: URLRequestConvertible {
    case searchPhotos(term: String)
    case searchUsers(term: String)
    
    var baseURL: URL {
        return URL(string: API.URL + "search/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchPhotos, .searchUsers:
            return .get
        }
    }
    
    //end point
    var endPoint: String {
        switch self {
        case .searchPhotos: return "photos/"
        case .searchUsers: return "users/"
        }
    }
    
    var parameters: [String : String]{
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query" : term]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        //api를 호출하면서 발동되는 부분
        let url = baseURL.appendingPathComponent(endPoint) //끝에 요소를 붙임
        
        print("MySearchRouter -> asURLRequest() url :\(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        switch self {
//        case let .get(parameters):
//            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        case let .post(parameters):
//            request = try JSONParameterEncoder().encode(parameters, into: request)
//        }
        
        return request
    }
}
